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

method get_training_sessions(:$user_id){
        my $sth = $.dbh.prepare(q:to/STATEMENT/);
            SELECT * from sessions
             WHERE user_id = ?
        STATEMENT

        $sth.execute($user_id);
        my @sessions = $sth.allrows(:array-of-hash);
        return @sessions;
}

method get_user_data(:$user_name) {
        my %techniques;

        my $sth = $.dbh.prepare(q:to/STATEMENT/);
            SELECT id,username
              FROM users
             WHERE username = ?
        STATEMENT

        $sth.execute($user_name);
        my %row = $sth.row(:hash);

        my %user = (
            id => %row<id>,
            user_name => %row<username>,
            sessions => 0,
            sessions_this_month => 0,
            sessions_last_month => 0,
            sessions_this_year  => 0,
        );

        my $dt = Date.new(DateTime.now);
        my @sessions = $.get_training_sessions(user_id => %user<id>);
        for @sessions[0] -> @session {
            for @session -> %session {
                %user<sessions>++;

                my @techniques = %session<techniques>.split(',');
                for @techniques -> $waza {
                    %user<techniques>{$waza}++;
                }

                my $session_dt = Date.new(%session<date>);

                if $session_dt >= $dt.truncated-to('month') {
                    %user<sessions_this_month>++;
                    for @techniques -> $waza {
                        %user<techniques_this_month>{$waza}++;
                    }
                }


                if ( $session_dt >= $dt.truncated-to('month').earlier(month => 1)
                 && $session_dt < $dt.truncated-to('month')  ) {
                    %user<sessions_last_month>++;
                    for @techniques -> $waza {
                        %user<techniques_last_month>{$waza}++;
                    }
                }

                if $session_dt >= $dt.truncated-to('year') {
                    %user<sessions_this_year>++;
                    for @techniques -> $waza {
                        %user<techniques_this_year>{$waza}++;
                    }
                }
            }
        }
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
        SELECT password_hash,id,username
            FROM users
            WHERE username = ?
               OR email = ?
    STATEMENT

    $sth.execute($user_name,$user_name);
    my $row = $sth.row();

    if (my $hash = $row[0]) {
        if ( bcrypt-match($password, $hash) ) {
            return $row[1],$row[2];
        }
    }


    return 0;
}
