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

            template 'user/home.tt', { user_name => $session<user> }; 
    }
}

baile();
