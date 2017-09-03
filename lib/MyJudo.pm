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
        my @rows = $sth.allrows(:array-of-hash);
     
        # Temporary Data        
            %user<first_session> = Date.new('2015-12-24').Date;
            %user<hours>     = 122;
            %user<latest_session> = Date.new('2016-12-24').Date;
            %user<sessions>  = 22;
            %user<techniques> = [
                { name => 'Seoi-nage', sessions => '10'},
                { name => 'Tai-otoshi', sessions => '5'},
                { name => 'Kata-guruma', sessions => '2'},
            ];
            %user<user_name> = $user_name;
        
         return %user;
    }
