unit class MyJudo;

use Crypt::Bcrypt;
use DBIish;

has $.dbh is rw;

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

method add_new_user(:$user_name, :$password) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
        INSERT INTO users
            (username,password_hash)
            VALUES (?,?)
        STATEMENT

    my $hash = bcrypt-hash($password);
    $sth.execute($user_name,$hash);
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

method link_user_to_sensei (:$user_id, :$sensei_id) {
    my $sth = $.dbh.prepare(q:to/STATEMENT/);
            INSERT INTO users_sensei
              (user_id,sensei_id)
              VALUES (?,?)
            STATEMENT

    $sth.execute($user_id, $sensei_id);
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
              FROM sensei
              JOIN users_sensei ON sensei.id = users_sensei.sensei_id
             WHERE users_sensei.user_id = ?
        STATEMENT

        $sth.execute(%user<id>);
        my @sensei = $sth.allrows(:array-of-hash);

        my $sensei_get = $.dbh.prepare(q:to/STATEMENT/);
            SELECT *
              FROM sensei
             WHERE id = ?
        STATEMENT

        $sth = $.dbh.prepare(q:to/STATEMENT/);
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
	        %user<sessions_this_month> = @sessions_this_month.elems;
            %user<sessions_this_year> = @sessions_this_year.elems;
            %user<techniques> = item %techniques;
            %user<techniques_this_month> = item %techniques_this_month;
            %user<techniques_this_year> = item %techniques_this_year;
            %user<user_name> = $user_name;
            %user<sensei> = item @sensei;
            %user<tree> = item %tree;

         return %user;
    }

