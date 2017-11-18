use v6.c;
use Bailador;

use lib 'lib';
use Judo;
use MyJudo;
use Crypt::Bcrypt;
use DBIish;

my $version = '0.0.1';

my $mj = MyJudo.new(
    dbh => DBIish.connect("SQLite", :database<db/myjudo.db>), 
);

# SSL serving config
#config.default-command      = 'ogre';
#config.tls-mode             = True;
#config.tls-config           = (
#    certificate-file => '/root/dehydrated/certs/myjudo.net/cert.pem',
#    private-key-file => '/root/dehydrated/certs/myjudo.net/privkey.pem',
#);

config.hmac-key = 'lance-key';

# Serve the challenge for letsencrypt SSL:
#        https://github.com/lukas2511/dehydrated
# static-dir '/.well-known/acme-challenge/' => '/var/www/dehydrated/';
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

        my $user_id = $mj.valid_user_credentials(
            user_name => %params<login>,
            password => %params<password>
        );
        
        if ($user_id) {
                my $session = session;
                $session<user> = %params<login>;
                $session<user_id> = $user_id;
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

        my $is_username_taken = $mj.is_username_taken( user_name => %params<usernamesignup>);
        return 'Username is taken' if $is_username_taken;

        $mj.add_new_user( user_name => %params<usernamesignup>, password => %params<passwordsignup> );


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

        my %user_data = $mj.get_user_data( user_name => $session<user> );

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

        my $sensei = $mj.get_sensei_by_name(
            family_name => %params<given_name>,
            given_name  => %params<family_name>,
        );

        if ( ! $sensei ) {
            $sensei = $mj.add_sensei(
                family_name => %params<given_name>,
                given_name  => %params<family_name>,
            );


            $sensei = $mj.get_sensei_by_name(
                family_name => %params<given_name>,
                given_name  => %params<family_name>,
            );
        }
 
        if ( $sensei ) {
            my $user_is_linked_to_sensei = $mj.is_user_linked_to_sensei(
                user_id => $session<user_id>, 
                sensei_id => $sensei<id>, 
            ); 

            if ( ! $user_is_linked_to_sensei ) {
                $mj.link_user_to_sensei( 
                    user_id => $session<user_id>, 
                    sensei_id => $sensei<id> 
                );
            }
        }

        redirect '/'; # this will return us to home via another redirect.
    }
}

prefix '/training_session' => sub {
    get "/add" => sub {
        my $session = session;
        redirect '/' unless $session<user>:exists;

        my $user_data = $mj.get_user_data( user_name => $session<user> );
        my $waza = Judo.waza();

        template 'session/add.tt', {
            user_data => $user_data,
            waza => $waza,
        };
    }
    post "/add" => sub {
        my $session = session;
        redirect '/' unless $session<user>:exists;

        my $user_data = $mj.get_user_data( user_name => $session<user> );

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
