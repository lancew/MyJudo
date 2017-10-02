use v6.c;
use Bailador;

use lib 'lib';
use Judo;
use MyJudo;
use Crypt::Bcrypt;
use DBIish;

my $version = '0.0.1';

config.hmac-key = 'lance-key';

static-dir / (.+) / => 'static/';

get '/' => sub {
        my $session = session;
        if ($session<user>:exists ) { redirect '/user/' ~ $session<user> }

        template 'index.tt';
}

get '/login' => sub {
    template 'login.tt';
}

post '/login' => sub {
    my %params = request.params;
    if ( %params<login> && %params<password> ) {
        my $dbh = DBIish.connect("SQLite", :database<db/myjudo.db>);

        my $sth = $dbh.prepare(q:to/STATEMENT/);
            SELECT password_hash,id
              FROM users
             WHERE username = ?
        STATEMENT

        $sth.execute(%params<login>);
        my $row = $sth.row();

        if (my $hash = $row[0]) {
            if ( bcrypt-match(%params<password>, $hash) ) {
                my $session = session;
                $session<user> = %params<login>;
                $session<user_id> = $row[1];
            }
        }
    }
    redirect '/';
}

get '/logout' => sub {
    my $session = session;
    session-delete;
    redirect '/';
}

get '/register' => sub {
    template 'register.tt';
}

post '/register' => sub {
    my %params = request.params;
    redirect '/' unless %params;
    if (%params<passwordsignup> eq %params<passwordsignup_confirm>) {

        my $dbh = DBIish.connect("SQLite", :database<db/myjudo.db>);

        my $sth = $dbh.prepare(q:to/STATEMENT/);
            SELECT 1
              FROM users
             WHERE username = ?
           STATEMENT

        $sth.execute(%params<usernamesignup>);

        my @rows = $sth.allrows();
        if (@rows.elems) {
            return 'User Name Taken';
        }

        $sth = $dbh.prepare(q:to/STATEMENT/);
            INSERT INTO users
                (username,password_hash)
                VALUES (?,?)
           STATEMENT

        my $hash = bcrypt-hash(%params<passwordsignup>);
        $sth.execute(%params<usernamesignup>,$hash);

        my $session = session;
        $session<user> = %params<usernamesignup>;

        redirect '/login';
        return;
    }
    redirect '/register';
}
prefix '/user' => sub {
    get "/:user" => sub ($user){
        my $session = session();
        redirect '/' unless $session<user>:exists && $session<user> eq $user;

        my %user_data = MyJudo.get_user_data( user_name => $session<user> );

        redirect '/' unless %user_data;

        my $waza = Judo.waza();

        template 'user/home.tt', {
            user_data => $(%user_data),
            waza => $waza,
            };
    }
}

prefix '/sensei' => sub {
    get '/add' => sub {
        my $session = session;
        redirect '/' unless $session<user>:exists;

        template 'sensei/add.tt';
    }
    post '/add' => sub {
        my $session = session;
        redirect '/' unless $session<user>:exists;

        my %params = request.params;
        my $dbh = DBIish.connect("SQLite", :database<db/myjudo.db>);

        my $sth = $dbh.prepare(q:to/STATEMENT/);
            SELECT 1
              FROM sensei
             WHERE family_name = ?
               AND given_name = ?
            STATEMENT
        $sth.execute(%params<family_name>.tc, %params<given_name>.tc);

        my @rows = $sth.allrows();
        if (!@rows.elems) {
            # No matching session(s) so add one

            $sth = $dbh.prepare(q:to/STATEMENT/);
                INSERT INTO sensei
                  (family_name, given_name)
                  VALUES (?,?)
            STATEMENT

            $sth.execute(
                %params<family_name>.tc,
                %params<given_name>.tc
            );
        }

        # TODO: Check that we have not added this sensei for the user already

        $sth = $dbh.prepare(q:to/STATEMENT/);
            SELECT *
              FROM sensei
             WHERE family_name = ?
               AND given_name = ?
        STATEMENT

        $sth.execute(
            %params<family_name>.tc,
            %params<given_name>.tc
        );

        my %sensei = $sth.row(:hash);
        warn %sensei.perl;

        $sth = $dbh.prepare(q:to/STATEMENT/);
            SELECT 1
              FROM users_sensei
             WHERE sensei_id = ?
               AND user_id =?
        STATEMENT
        $sth.execute(
            %sensei<id>,
            $session<user_id>
        );
        @rows = $sth.allrows();

        unless ( @rows ) {
            $sth = $dbh.prepare(q:to/STATEMENT/);
                INSERT INTO users_sensei
                            (user_id, sensei_id )
                       VALUES (?, ?)
            STATEMENT
            $sth.execute(
                $session<user_id>,
                %sensei.<id>
            );
        }

        redirect '/'; # this will return us to home via another redirect.
    }
}

prefix '/training_session' => sub {
    get "/add" => sub {
        my $session = session;
        redirect '/' unless $session<user>:exists;

        my $user_data = MyJudo.get_user_data( user_name => $session<user> );
        my $waza = Judo.waza();

        template 'session/add.tt', {
            user_data => $user_data,
            waza => $waza,
        };
    }
    post "/add" => sub {
        my $session = session;
        redirect '/' unless $session<user>:exists;

        my $user_data = MyJudo.get_user_data( user_name => $session<user> );

        my %params = request.params;

        my $dbh = DBIish.connect("SQLite", :database<db/myjudo.db>);

        # Add logic for inserting into DB.

        my $sth = $dbh.prepare(q:to/STATEMENT/);
            SELECT id
              FROM sessions
             WHERE user_id = ?
               AND date = ?
            STATEMENT
        $sth.execute($user_data<id>, %params<session-date>);

        my @rows = $sth.allrows();
        if (!@rows.elems) {
            # No matching session(s) so add one

            $sth = $dbh.prepare(q:to/STATEMENT/);
                INSERT INTO sessions
                  (date, user_id, techniques)
                  VALUES (?,?,?)
            STATEMENT

            my @techniques;
            my $date = %params<session-date>:delete;
            for %params.kv -> $k, $v {
                @techniques.push(lc $k);
            }

            $sth.execute(
                $date,
                $user_data<id>,
                @techniques.join(',')
            );
        } else {
            return 'session exists';
        }
        redirect '/';
    }
}

baile();
