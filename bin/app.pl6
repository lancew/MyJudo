use v6.c;
use Bailador;

use lib 'lib';
use Judo;
use MyJudo;
use DBIish;

my $version = '0.0.1';
config.cookie-expiration = 60 * 5; # 5minutes
config.hmac-key = 'lance-key';

static-dir / (.+) / => 'static/';

# MongoDB credentials:
# lwtest01
# 9JKP@jd$nrkXsP%Byv4HD

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
            SELECT 1
              FROM users
             WHERE username = ?
               AND password_hash = ?
        STATEMENT

        $sth.execute(%params<login>, %params<password>);
        my @rows = $sth.allrows();
        if (@rows.elems) {
            my $session = session;
            $session<user> = %params<login>;
        }
    }
    redirect '/';
}

get '/logout' => sub {
    template 'logout.tt';
}

post '/logout' => sub {
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

        $sth.execute(%params<usernamesignup>,%params<passwordsignup>);

        my $session = session;
        $session<user> = %params<usernamesignup>;

        redirect '/';
        exit;
    }
    redirect '/register';
}
prefix '/user' => sub {
    get "/:user" => sub ($user){
        my $session = session;
        redirect '/' unless $session<user>:exists && $session<user> eq $user;

        my $user_data = MyJudo.get_user_data( user_name => $session<user> );
        redirect '/' unless $user_data;

        my $waza = Judo.waza();

        template 'user/home.tt', {
            user_data => $user_data,
            waza => $waza,
            };
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

        # Next add actual logic to add a session
        my %params = request.params;
        say %params.perl;

        my $dbh = DBIish.connect("SQLite", :database<db/myjudo.db>);

        my $sth = $dbh.prepare(q:to/STATEMENT/);
            SELECT 1
              FROM users
             WHERE user_name = ?
               AND password_hash = ?
        STATEMENT

        $sth.execute(%params<login>, %params<password>);        

        redirect "/user/$session<user>";
    }
}


baile();
