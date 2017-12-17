unit class MyJudo;

use Crypt::Bcrypt;
use DBIish;

has $.dbh is rw;

method add_new_user(:$user_name, :$password, :$email) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        INSERT INTO users
            (username,password_hash,email)
            VALUES (?,?,?)
        STATEMENT

    my $hash = bcrypt-hash($password);
    $sth.execute($user_name,$hash,$email);
}

method add_sensei (:$family_name, :$given_name) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        INSERT INTO sensei
            (family_name, given_name)
            VALUES (?,?)
    STATEMENT

    $sth.execute(
        $family_name.tc,
        $given_name.tc
    );
}

method get_admin_dashboard_data {
    my %data;
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        SELECT id
          FROM users
        STATEMENT
    $sth.execute();

    my @rows = $sth.allrows();
    %data<total_users> = @rows.elems;

    $sth = $.dbh.prepare(q:to/STATEMENT/);
        SELECT *
          FROM sessions
        STATEMENT
    $sth.execute();

    @rows = $sth.allrows(:array-of-hash);
    %data<total_sessions> = @rows.elems;

    my $total_techniques = 0;
    my %techniques;
    for @rows -> %session {
        my @techniques = %session<techniques>.split(',');
        for @techniques -> $waza {
            $total_techniques++;
            %techniques{$waza}++;
        }
    }
    %data<total_techniques> = $total_techniques;
    %data<techniques> = %techniques;
    return %data;
}

method get_sensei_by_name(:$family_name, :$given_name){
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
            SELECT *
              FROM sensei
             WHERE family_name = ?
               AND given_name = ?
            STATEMENT

        $sth.execute($family_name.tc, $given_name.tc);

        return $sth.row(:hash);
}

method get_user_data(:$user_name) {
        my %user;

        my $sth = $.dbh.prepare(q:to/STATEMENT/);
            SELECT id,username
              FROM users
             WHERE username = ?
        STATEMENT

        $sth.execute($user_name);
        my %row = $sth.row(:hash);

        %user<id> = %row<id>;
        %user<user_name> = %row<username>;

        $sth = $.dbh.prepare(q:to/STATEMENT/);
            SELECT *
              FROM sessions
             WHERE user_id = ?
        STATEMENT

        $sth.execute(%user<id>);
        my @sessions = $sth.allrows(:array-of-hash);

        my %techniques;
        for @sessions -> %session {
           my @techniques = %session<techniques>.split(',');
           for @techniques -> $waza {
               %techniques{$waza}++;
           }
        }

        $sth = $.dbh.prepare(q:to/STATEMENT/);
        SELECT *
            FROM sessions
            WHERE user_id = ?
            AND date >= ?
        STATEMENT

        my $start_of_month = Date.today.year ~ '-' ~ Date.today.month ~ '-01';
        $sth.execute(%user<id>, $start_of_month);
        my @sessions_this_month = $sth.allrows(:array-of-hash);
        my %techniques_this_month;
        for @sessions_this_month -> %session {
           my @techniques = %session<techniques>.split(',');
           for @techniques -> $waza {
               %techniques_this_month{$waza}++;
           }
        }

        my $start_of_year = Date.today.year ~ '-01-01';
        $sth.execute(%user<id>, $start_of_year);
        my @sessions_this_year = $sth.allrows(:array-of-hash);
        my %techniques_this_year;
        for @sessions_this_year -> %session {
           my @techniques = %session<techniques>.split(',');
           for @techniques -> $waza {
               %techniques_this_year{$waza}++;
           }
        }

        $sth = $.dbh.prepare(q:to/STATEMENT/);
        SELECT *
            FROM sessions
            WHERE user_id = ?
            AND date < ?
        AND date >= ?
        STATEMENT

        my $start_of_last_month = Date.today.year ~ '-' ~ Date.today.month-1 ~ '-01';
        $sth.execute(%user<id>, $start_of_month, $start_of_last_month );
        my @sessions_last_month = $sth.allrows(:array-of-hash);
        my %techniques_last_month;
        for @sessions_last_month -> %session {
           my @techniques = %session<techniques>.split(',');
           for @techniques -> $waza {
               %techniques_last_month{$waza}++;
           }
        }

        # Temporary Data
        %user<sessions>  = @sessions.elems;
        %user<sessions_this_month> = @sessions_this_month.elems;
        %user<sessions_last_month> = @sessions_last_month.elems;
        %user<sessions_this_year> = @sessions_this_year.elems;
        %user<techniques> = item %techniques;
        %user<techniques_this_month> = item %techniques_this_month;
        %user<techniques_last_month> = item %techniques_last_month;
        %user<techniques_this_year> = item %techniques_this_year;
        %user<user_name> = $user_name;

        return %user;
}

method is_user_linked_to_sensei (:$user_id, :$sensei_id) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        SELECT 1
          FROM users_sensei
         WHERE user_id = ?
           AND sensei_id = ?
    STATEMENT

    $sth.execute(
        $user_id, $sensei_id
    );

    my @rows = $sth.allrows();
    if (@rows.elems) {
        return 1;
    }

    return 0;
}

method is_username_taken(:$user_name) {
        my $sth = $.dbh.prepare(q:to/STATEMENT/);
            SELECT 1
              FROM users
             WHERE username = ?
           STATEMENT

        $sth.execute($user_name);

        my @rows = $sth.allrows();
        if (@rows.elems) {
            return 1;
        }

        return 0;
}

method link_user_to_sensei (:$user_id, :$sensei_id) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
            INSERT INTO users_sensei
              (user_id,sensei_id)
              VALUES (?,?)
            STATEMENT

    $sth.execute($user_id, $sensei_id);
}

method training_session_add (:$date, :$user_id, :$techniques) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
                INSERT INTO sessions
                  (date, user_id, techniques)
                  VALUES (?,?,?)
            STATEMENT

    $sth.execute(
        $date,
        $user_id,
        $techniques
    );
}

method training_session_exists (:$user_id, :$date) {
        my $sth = $.dbh.prepare(q:to/STATEMENT/);
            SELECT id
              FROM sessions
             WHERE user_id = ?
               AND date = ?
            STATEMENT
        $sth.execute($user_id, $date);

        my @rows = $sth.allrows();
    return @rows.elems ?? True !! False;;
};

method valid_user_credentials(:$user_name, :$password) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        SELECT password_hash,id
            FROM users
            WHERE username = ?
    STATEMENT

    $sth.execute($user_name);
    my $row = $sth.row();

    if (my $hash = $row[0]) {
        if ( bcrypt-match($password, $hash) ) {
            return $row[1];
        }
    }
    return 0;
}
