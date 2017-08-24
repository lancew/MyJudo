use v6.c;
use Bailador;

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
    my $session = session;
    $session<user> = 'lancew';
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
    template 'register.tt', {registered => 1};
}
prefix '/user' => sub {
    get "/:user" => sub ($user){
        my $session = session;
        redirect '/' unless $session<user>:exists && $session<user> eq $user;

        my $user_data = get_user_data( username => $session<user> );
        redirect '/' unless $user_data;

        template 'user/home.tt', { user_data => $user_data }; 
    }
}

prefix '/session' => sub {
    get "/add" => sub {
        my $session = session;
        redirect '/' unless $session<user>:exists;

        my $user_data = get_user_data( username => $session<user> );
        template 'session/add.tt', { user_data => $user_data }; 
    }
    post "/add" => sub {
        my $session = session;
        redirect '/' unless $session<user>:exists;

        # Next add actual logic to add a session

        redirect "/user/$session<user>";
    }
}

sub get_user_data(:$username) {
        return { 
            first_session => Date.new('2015-12-24').Date,
            hours     => 122,
            latest_session => Date.new('2016-12-24').Date,
            sessions  => 22,
            techniques => [
                { name => 'Seoi Nage', sessions => '10'},
                { name => 'Taio Toshi', sessions => '9'},
                { name => 'O Soto Gari', sessions => '8'},
                { name => 'Yoko Shiho Gatame', sessions => '55'},
            ],
            user_name => $username,
         };
    }

baile();
