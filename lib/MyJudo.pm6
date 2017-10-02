unit class MyJudo;

use DBIish;

method get_user_data(:$user_name) {
        my %user;

        my $dbh = DBIish.connect("SQLite", :database<db/myjudo.db>);

        my $sth = $dbh.prepare(q:to/STATEMENT/);
            SELECT id,username
              FROM users
             WHERE username = ?
        STATEMENT

        $sth.execute($user_name);
        my %row = $sth.row(:hash);

        %user<id> = %row<id>;
        %user<user_name> = %row<username>;

        $sth = $dbh.prepare(q:to/STATEMENT/);
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

        $sth = $dbh.prepare(q:to/STATEMENT/);
            SELECT *
              FROM sensei
              JOIN users_sensei ON sensei.id = users_sensei.sensei_id
             WHERE users_sensei.user_id = ?
        STATEMENT

        $sth.execute(%user<id>);
        my @sensei = $sth.allrows(:array-of-hash);

        # Temporary Data
            %user<sessions>  = @sessions.elems;
            %user<techniques> = item %techniques;
            %user<user_name> = $user_name;
            %user<sensei> = item @sensei;

         return %user;
    }
