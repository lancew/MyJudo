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

        my $sensei_get = $dbh.prepare(q:to/STATEMENT/);
            SELECT *
              FROM sensei
             WHERE id = ?
        STATEMENT

        $sth = $dbh.prepare(q:to/STATEMENT/);
            WITH CTE AS
            (
            SELECT parent_sensei_id
                FROM sensei_sensei
                WHERE child_Sensei_id=?
            UNION ALL
            SELECT sensei_sensei.parent_sensei_id
                FROM CTE
                JOIN sensei_sensei
                ON CTE.parent_sensei_id=sensei_sensei.child_sensei_id
            )
            SELECT distinct * FROM CTE;
        STATEMENT
        
        my %tree;
        for @sensei -> $s {
            $sth.execute($s<sensei_id>);
            $sensei_get.execute($s<sensei_id>);
            my %child = $sensei_get.row(:hash);
            
            my $child_coach = %child<given_name> ~ ' ' ~ %child<family_name>;
            
            my @parents = $sth.allrows(:array);
            
            for @parents -> $p {
                $sensei_get.execute($p[0]);
                my %data = $sensei_get.row(:hash);
         
                my $parent = %data<given_name> ~ ' ' ~ %data<family_name>;
                %tree{$child_coach}{$parent}++;
            }
        }


        # Temporary Data
            %user<sessions>  = @sessions.elems;
            %user<techniques> = item %techniques;
            %user<user_name> = $user_name;
            %user<sensei> = item @sensei;
            %user<tree> = item %tree;

         return %user;
    }
