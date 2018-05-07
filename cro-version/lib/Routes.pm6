use Cro::HTTP::Router;
use Template::Mojo;

use Judo;
use MyJudo;
use Crypt::Bcrypt;
use DBIish;

my $version = '0.0.1';

my $mj = MyJudo.new(
    dbh => DBIish.connect("SQLite", :database<../db/myjudo.db>),
);
class UserSession does Cro::HTTP::Auth {
    has $.username is rw;

    method logged-in() {
        defined $!username;
    }
}
sub routes() is export {
    route {
        subset LoggedIn of UserSession where *.logged-in;
        get -> {
            my $t = Template::Mojo.from-file('views/index.tm');
            content 'text/html', $t.render(
                {name => 'lance'}
            );
        };

        get -> 'login' {
            my $t = Template::Mojo.from-file('views/login.tm');
            content 'text/html', $t.render(
                {name => 'lance'}
            );
        };
        post -> 'login' {
            request-body -> %params {
                if ( %params<login> && %params<password> ) {

                    my ($user_id, $user_name) = $mj.valid_user_credentials(
                        user_name => %params<login>,
                        password => %params<password>
                    );

                    if ($user_id) {
                            #my $session = session;
                            #$session<user> = $user_name;
                            #$session<user_id> = $user_id;
                            redirect :see-other, "/user/$user_name";
                    } else {
                        content 'text/html', 'NOPE';
                    }
                }
                #redirect :see-other, "/";
            }
        }

        get -> LoggedIn $user, 'user', $user_name {
            my %user_data = $mj.get_user_data( user_name => $user_name );

            my $waza = Judo.waza();

            my $t = Template::Mojo.from-file('views/user/home.tm');

            content 'text/html', $t.render( {
                user_data => $(%user_data),
                waza => $waza,
                } );
        };

        get -> 'user', $user_name, 'training-sessions' {
            my %user_data = $mj.get_user_data( user_name => $user_name );
            my @sessions = $mj.training-sessions( user_id => %user_data<id> );

            my $t = Template::Mojo.from-file('views/user/training-sessions.tm');
            content 'text/html', $t.render( {
                user_data => $(%user_data),
                sessions => item @sessions,
                }
            );
        };

        get -> 'user', $user_name, 'training-session', 'edit', $session_id {
            my %user_data = $mj.get_user_data( user_name => $user_name );
            my $waza = Judo.waza();

            my $training_session = $mj.get_training_session(
                user_id => %user_data<id>,
                session_id    => $session_id,
            );

            my $t = Template::Mojo.from-file('views/user/training-session/add_edit.tm');
            content 'text/html', $t.render(
                {
                    session => $training_session,
                    user_data => %user_data,
                    waza => $waza,
                }
            );
        };
        post -> 'user', $user_name, 'training-session', 'edit', $session_id {
            my $user_data = $mj.get_user_data( user_name => $user_name );

            request-body -> ( *%params ) {
                my @techniques;
                my $date = %params<session-date>:delete;
                my @types = 'randori-tachi-waza','randori-ne-waza','uchi-komi','nage-komi','kata';
                my @training_types;
                for @types {
                    @training_types.push($_) if %params{$_}:delete;
                }

                for %params.kv -> $k, $v {
                    @techniques.push(lc $k);
                }

                $mj.training_session_update(
                    date => $date,
                    user_id => $user_data<id>,
                    techniques => @techniques.join(','),
                    training_types => @training_types.join(','),
                    session_id => $session_id,
                );
            }

            # "see-other" generates a 303, causing a GET
            redirect :see-other, "/user/$user_name/training-sessions";
        };

        get -> 'user', $user_name, 'training-session', 'add' {
            my %user_data = $mj.get_user_data( user_name => $user_name );
            my $waza = Judo.waza();

            my $t = Template::Mojo.from-file('views/user/training-session/add_edit.tm');
            content 'text/html', $t.render(
                {
                    user_data => %user_data,
                    waza => $waza,
                }
            );
        };
        post -> 'user', $user_name, 'training-session', 'add' {
            my $user_data = $mj.get_user_data( user_name => $user_name );

            request-body -> ( *%params ) {
                my @techniques;
                my $date = %params<session-date>:delete;
                my @types = 'randori-tachi-waza','randori-ne-waza','uchi-komi','nage-komi','kata';
                my @training_types;
                for @types {
                    @training_types.push($_) if %params{$_}:delete;
                }

                for %params.kv -> $k, $v {
                    @techniques.push(lc $k);
                }

                my $session_exists = $mj.training_session_exists(
                    user_id => $user_data<id>,
                    date => $date,
                );

                if ( $session_exists ) {
                   content 'text/html', 'Session Already Exists - Edit instead';
                } else {

                    $mj.training_session_add(
                        date => $date,
                        user_id => $user_data<id>,
                        techniques => @techniques.join(','),
                        training_types => @training_types.join(','),
                    );

                    # "see-other" generates a 303, causing a GET
                    redirect :see-other, "/user/$user_name/training-sessions";
                }
            }

        };
        get -> 'favicon.ico', {static 'static/favicon.ico' };
    }
}
