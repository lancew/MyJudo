unit class MyJudo;

use Crypt::Bcrypt;
use DBIish;
use Email::Simple;
use Net::SMTP;
use UUID;

#| Data access layer for the MyJudo application.
#| Handles all database operations for users, sensei, and training sessions.

has $.dbh is required;

#| Insert a new user with a bcrypt-hashed password.
method add_new_user(:$user_name, :$password, :$email) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        INSERT INTO users
            (username, password_hash, email)
            VALUES (?, ?, ?)
        STATEMENT

    my $hash = bcrypt-hash($password);
    $sth.execute($user_name, $hash, $email);
}

#| Insert a new sensei (instructor) record.
#| Family and given names are title-cased automatically.
method add_sensei(:$family_name, :$given_name) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        INSERT INTO sensei
            (family_name, given_name)
            VALUES (?, ?)
        STATEMENT

    $sth.execute(
        $family_name.tc,
        $given_name.tc,
    );
}

#| Clear a password reset code for the given code value.
method delete_reset_code(:$code) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        UPDATE users
           SET password_reset_code = ''
         WHERE password_reset_code = ?
        STATEMENT

    $sth.execute(~$code);
}

#| Aggregate statistics for the admin dashboard.
method get_admin_dashboard_data() {
    my %data;

    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        SELECT id FROM users
        STATEMENT
    $sth.execute();
    %data<total_users> = $sth.allrows().elems;

    $sth = $.dbh.prepare(q:to/STATEMENT/);
        SELECT * FROM sessions
        STATEMENT
    $sth.execute();

    my @rows = $sth.allrows(:array-of-hash);
    %data<total_sessions> = @rows.elems;

    my $total_techniques = 0;
    my %techniques;
    for @rows -> %session {
        for %session<techniques>.split(',') -> $waza {
            $total_techniques++ if $waza;
            %techniques{$waza}++ if $waza;
        }
    }
    %data<total_techniques> = $total_techniques;
    %data<techniques> = %techniques;
    %data
}

#| Look up a sensei by family and given name.
method get_sensei_by_name(:$family_name, :$given_name) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        SELECT *
          FROM sensei
         WHERE family_name = ?
           AND given_name = ?
        STATEMENT

    $sth.execute($family_name.tc, $given_name.tc);
    $sth.row(:hash);
}

#| Retrieve a single training session by user ID and session ID.
method get_training_session(:$user_id, :$session_id) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        SELECT *
          FROM sessions
         WHERE id = ?
           AND user_id = ?
        STATEMENT

    $sth.execute(~$session_id, $user_id);
    $sth.row(:hash);
}

#| Retrieve all training sessions for a user, ordered by date descending.
method get_training_sessions(:$user_id) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        SELECT *
          FROM sessions
         WHERE user_id = ?
         ORDER BY date DESC
        STATEMENT

    $sth.execute($user_id);
    $sth.allrows(:array-of-hash);
}

#| Look up a user by their password reset code.
method get_user_from_reset_code(:$reset_code) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        SELECT id, username
          FROM users
         WHERE password_reset_code = ?
        STATEMENT

    $sth.execute(~$reset_code);
    $sth.row(:hash);
}

#| Get full user data including session counts and technique breakdowns
#| by time period (this month, last month, this year, last year).
method get_user_data(:$user_name) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        SELECT id, dojo, username
          FROM users
         WHERE username = ?
        STATEMENT

    $sth.execute($user_name);
    my %row = $sth.row(:hash);

    my %user = (
        id                      => %row<id>,
        dojo                    => %row<dojo>,
        user_name               => %row<username>,
        sessions                => 0,
        sessions_this_month     => 0,
        sessions_last_month     => 0,
        sessions_this_year      => 0,
        sessions_last_year      => 0,
        session_types           => {},
        techniques              => {},
        techniques_this_month   => {},
        techniques_last_month   => {},
        techniques_this_year    => {},
        techniques_last_year    => {},
    );

    my $dt = Date.new(DateTime.now);
    my $month_start = $dt.truncated-to('month');
    my $year_start  = $dt.truncated-to('year');

    my @sessions = self.get_training_sessions(user_id => %user<id>);
    for @sessions -> %session {
        %user<sessions>++;

        my @techniques = %session<techniques>.split(',');
        self!count_techniques(@techniques, %user<techniques>);

        if %session<types> {
            for %session<types>.split(',') -> $type {
                %user<session_types>{$type}++ if $type;
            }
        }

        my $session_dt = Date.new(%session<date>);

        if $session_dt >= $month_start {
            %user<sessions_this_month>++;
            self!count_techniques(@techniques, %user<techniques_this_month>);
        }

        if $session_dt >= $month_start.earlier(month => 1)
           && $session_dt < $month_start {
            %user<sessions_last_month>++;
            self!count_techniques(@techniques, %user<techniques_last_month>);
        }

        if $session_dt >= $year_start {
            %user<sessions_this_year>++;
            self!count_techniques(@techniques, %user<techniques_this_year>);
        }

        if $session_dt >= $year_start.earlier(year => 1)
           && $session_dt < $year_start {
            %user<sessions_last_year>++;
            self!count_techniques(@techniques, %user<techniques_last_year>);
        }
    }
    %user
}

#| Check whether a user is linked to a sensei.
method is_user_linked_to_sensei(:$user_id, :$sensei_id) returns Bool {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        SELECT 1
          FROM users_sensei
         WHERE user_id = ?
           AND sensei_id = ?
        STATEMENT

    $sth.execute($user_id, $sensei_id);
    so $sth.allrows().elems;
}

#| Check whether a username is already taken.
method is_username_taken(:$user_name) returns Bool {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        SELECT 1
          FROM users
         WHERE username = ?
        STATEMENT

    $sth.execute($user_name);
    so $sth.allrows().elems;
}

#| Create a link between a user and a sensei.
method link_user_to_sensei(:$user_id, :$sensei_id) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        INSERT INTO users_sensei
            (user_id, sensei_id)
            VALUES (?, ?)
        STATEMENT

    $sth.execute($user_id, $sensei_id);
}

#| Update a user's password (bcrypt-hashed).
method password_change(:$username, :$password) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        UPDATE users
           SET password_hash = ?
         WHERE username = ?
        STATEMENT

    my $hash = bcrypt-hash($password);
    $sth.execute($hash, $username);
}

#| Send a password reset email.
#| Generates a UUID code, stores it, and emails a reset link.
method password_reset_request(:$login, :$host = 'myjudo.net') {
    warn 'Email reset request made by: ', $login;

    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        SELECT id, username, email
          FROM users
         WHERE username = ?
            OR email = ?
        STATEMENT

    $sth.execute($login, $login);
    my $row = $sth.row();

    warn 'No user record found' unless $row[0];
    return unless $row[0];

    warn 'No email address: ', $row.gist unless $row[2];

    my $uuid = UUID.new;

    $sth = $.dbh.prepare(q:to/STATEMENT/);
        UPDATE users
           SET password_reset_code = ?
         WHERE id = ?
        STATEMENT

    $sth.execute(~$uuid, $row[0]);

    my $server   = %*ENV<MYJUDO_SMTP_SERVER>   // '';
    my $port     = %*ENV<MYJUDO_SMTP_PORT>     // 25;
    my $username = %*ENV<MYJUDO_SMTP_USERNAME>  // '';
    my $password = %*ENV<MYJUDO_SMTP_PASSWORD>  // '';
    my $from     = %*ENV<MYJUDO_FROM_EMAIL>     // 'myjudo-noreply@myjudo.net';

    my $url = "https://$host/reset-password/$uuid";

    my $email = Email::Simple.create(
        header => [
            ['To', $row[2]],
            ['From', $from],
            ['Subject', 'MyJudo: Password reset request'],
        ],
        body => qq:to/EMAIL/,
            Reset your password by clicking this URL: $url

            A password reset request has been made on https://$host;
            please contact support@$host if you did not request this password reset.
            EMAIL
    );

    my $client = Net::SMTP.new(
        :port($port),
        :server($server),
        :debug,
    );

    $client.auth($username, $password);
    $client.send($from, $row[2], $email.Str());
    $client.quit;
}

#| Add a new training session record.
method training_session_add(:$date, :$dojo, :$user_id, :$techniques, :$training_types) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        INSERT INTO sessions
            (date, dojo, user_id, techniques, types)
            VALUES (?, ?, ?, ?, ?)
        STATEMENT

    $sth.execute($date, $dojo, $user_id, $techniques, $training_types);
}

#| Update an existing training session record.
method training_session_update(:$date, :$dojo, :$user_id, :$techniques, :$training_types, :$session_id) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        UPDATE sessions
           SET date = ?,
               dojo = ?,
               user_id = ?,
               techniques = ?,
               types = ?
         WHERE id = ?
        STATEMENT

    $sth.execute(
        ~$date,
        ~$dojo,
        ~$user_id,
        ~$techniques,
        ~$training_types,
        ~$session_id,
    );
}

#| Check whether a session already exists for a user on a given date.
method training_session_exists(:$user_id, :$date) returns Bool {
    my $sth = $.dbh.prepare(
        'SELECT 1 FROM sessions WHERE user_id = ? AND date = ?');

    $sth.execute($user_id, $date);
    $sth.row.Bool;
}

#| Validate user credentials against the database.
#| Returns a list of (user_id, username) on success, or False on failure.
method valid_user_credentials(:$user_name, :$password) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        SELECT password_hash, id, username
          FROM users
         WHERE username = ?
            OR email = ?
        STATEMENT

    $sth.execute($user_name, $user_name);
    my $row = $sth.row();

    if (my $hash = $row[0]) {
        if bcrypt-match($password, $hash) {
            return $row[1], $row[2];
        }
    }

    False
}

#| Private helper: increment technique counts for non-empty technique names.
method !count_techniques(@techniques, %target) {
    for @techniques -> $waza {
        %target{$waza}++ if $waza;
    }
}
