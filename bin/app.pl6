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

        my ($user_id, $user_name) = $mj.valid_user_credentials(
            user_name => %params<login>,
            password => %params<password>
        );

        if ($user_id) {
                my $session = session;
                $session<user> = $user_name;
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

get '/password-change' => sub {
    my $session = session;
    redirect '/' unless $session<user>:exists;
    template 'password-change.tt';
}

post '/password-change' => sub {
    my $session = session;
    redirect '/' unless $session<user>:exists;

    my %params = request.params;

    if ( %params<password-new>.chars && %params<password-new> eq %params<password-repeat> ) {
        my ($user_id, $user_name) = $mj.valid_user_credentials(
            user_name => $session<user>,
            password => %params<password>
        );
        if ( $user_id ) {
            $mj.password_change(
                username => $session<user>,
                password => %params<password-new>
            );
            return redirect '/';
        }
    }

    redirect '/password-change';
}

get '/password-reset' => sub {
    template 'password-reset.tt',{};
}
post '/password-reset' => sub {
    my $r = request;

    my %params = request.params;
    if ( %params<login> ) {
        $mj.password_reset_request(
            login => %params<login>
        );
    }
    template 'password-reset.tt',{submitted => 1};
}

get '/reset-password/:code' => sub ($code){
    my %user_data = $mj.get_user_from_reset_code( reset_code => $code );
    return redirect '/' unless %user_data<username>:exists;
    template 'reset-password.tt';
}

post '/reset-password/:code' => sub ($code) {
    my %params = request.params;

    my %user_data = $mj.get_user_from_reset_code( reset_code => $code );
    return redirect '/' unless %user_data<username>:exists;

    if ( %params<password-new>.chars && %params<password-new> eq %params<password-repeat> ) {
            $mj.password_change(
                username => %user_data<username>,
                password => %params<password-new>
            );

            $mj.delete_reset_code(code => $code );

            my $session = session;
            $session<user> = %user_data<username>;
            return redirect '/';
    }

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

        $mj.add_new_user(
            user_name => %params<usernamesignup>,
            password => %params<passwordsignup>,
            email => %params<emailsignup>,
        );


        my $session = session;
        $session<user> = %params<usernamesignup>;

        redirect '/login';
        return;
    }
    redirect '/register';
}

prefix '/admin' => sub {
    get '/dashboard' => sub {
        my $session = session;
        redirect '/' unless $session<user>:exists;

        my %dashboard_data = $mj.get_admin_dashboard_data;
        template 'admin/dashboard.tt', {
            dashboard_data => %dashboard_data,
            waza => Judo.waza(),
        };
    }
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

    my $session_exists = $mj.training_session_exists(
        user_id => $user_data<id>,
        date => %params<session-date>,
    );
        if ( ! $session_exists ) {
            my @techniques;
            my $date = %params<session-date>:delete;
            for %params.kv -> $k, $v {
                @techniques.push(lc $k);
            }

            $mj.training_session_add(
                date => $date,
                user_id => $user_data<id>,
                techniques => @techniques.join(','),
            );
        } else {
            return 'session exists';
        }
        redirect '/';
    }
}

get '/training-sessions' => sub {
    my $session = session;
    redirect '/' unless $session<user>:exists;

    my %params = request.params;

    my $user_data = $mj.get_user_data( user_name => $session<user> );
    my @sessions = $mj.training-sessions( user_id => $user_data<id> );

    template 'training-sessions.tt', {
        sessions => item @sessions,
    };
}
baile();
