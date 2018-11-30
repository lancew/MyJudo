use Cro::HTTP::Router;
use Template::Mojo;
use Template::Mustache;

use Judo;
use MyJudo;
use Crypt::Bcrypt;
use DBIish;

my $version = '0.0.1';

class UserSession does Cro::HTTP::Auth {
    has $.username is rw;

    method logged-in() { defined $!username }
}

my $mj = MyJudo.new(
    dbh => DBIish.connect("SQLite", :database<db/myjudo.db>),
);

my $stache = Template::Mustache.new: :from('views'.IO.absolute);

sub routes() is export {
    route {
        subset LoggedIn of UserSession where *.logged-in;

        get -> { content 'text/html', $stache.render('index', {}) };
        
        get -> 'register' {
            content 'text/html', $stache.render('register', {});
        };
        post -> 'register' {
            request-body -> %params {
                if (%params<passwordsignup> eq %params<passwordsignup_confirm>) {
                    my $is_username_taken = $mj.is_username_taken( user_name => %params<usernamesignup>);
                    content 'text/html', 'Username is taken' if $is_username_taken;

                    $mj.add_new_user(
                        user_name => %params<usernamesignup>,
                        password => %params<passwordsignup>,
                        email => %params<emailsignup>,
                    );
                    redirect :see-other, "/login";
                 }
            }
        };

        get -> LoggedIn $user, 'password-change' {
            my $t = Template::Mojo.from-file('views/password-change.tm');
            content 'text/html', $t.render();
        };
        post -> LoggedIn $user, 'password-change' {
            request-body -> %params {
                if (    %params<password-new>.chars
                     && %params<password-new> eq %params<password-repeat>
                   ) {
                       my ($user_id, $user_name) = $mj.valid_user_credentials(
                        user_name => $user.username,
                        password => %params<password>
                    );
                    if ( $user_id ) {
                        $mj.password_change(
                            username => $user.username,
                            password => %params<password-new>
                        );
                        redirect "/user/$user_name", :see-other;
                    }
                }
            }
            content 'text/html', 'Passord change error';
        };

        get -> 'password-reset' {
            my $t = Template::Mojo.from-file('views/password-reset.tm');
            content 'text/html', $t.render;
        };

        post -> 'password-reset' {
            request-body -> %params {
                if ( %params<login> ) {
                    $mj.password_reset_request(
                        login => %params<login>
                    );
                }
            }
            my $t = Template::Mojo.from-file('views/password-reset.tm');
            content 'text/html', $t.render( submitted => 1  );
        };

        get -> UserSession $user, 'logout' {
            $user.username = Nil;
            redirect :see-other, "/";
        };

        get -> 'login' {
            my $t = Template::Mojo.from-file('views/login.tm');
            content 'text/html', $t.render(
                {name => 'lance'}
            );
        };
        post -> UserSession $user, 'login' {
            request-body -> %params {
                if ( %params<login> && %params<password> ) {
                    my ($user_id, $user_name) = $mj.valid_user_credentials(
                        user_name => %params<login>,
                        password => %params<password>
                    );

                    if ($user_id) {
                            $user.username = $user_name;
                            redirect "/user/$user_name", :see-other;
                    } else {
                        redirect :see-other, "/login";
                    }
                }
            }
        }

        get -> LoggedIn $user, 'user', $user_name {
            my %user_data = $mj.get_user_data( user_name => $user.username );

            my $waza = Judo.waza();

            my $t = Template::Mojo.from-file('views/user/home.tm');

            content 'text/html', $t.render( {
                user_data => $(%user_data),
                waza => $waza,
                } );
        };

        get -> LoggedIn $user, 'user', $user_name, 'training-sessions' {
            my %user_data = $mj.get_user_data( user_name => $user.username );
            my @sessions = $mj.training-sessions( user_id => %user_data<id> );

            my $t = Template::Mojo.from-file('views/user/training-sessions.tm');
            content 'text/html', $t.render( {
                user_data => $(%user_data),
                sessions => item @sessions,
                }
            );
        };

        get -> LoggedIn $user,'user', $user_name, 'training-session', 'edit', $session_id {
            my %user_data = $mj.get_user_data( user_name => $user.username );
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
        post -> LoggedIn $user,'user', $user_name, 'training-session', 'edit', $session_id {
            my $user_data = $mj.get_user_data( user_name => $user.username );

            request-body -> ( *%params ) {
                my @techniques;
                my $date = %params<session-date>:delete;
                my $dojo = %params<session-dojo>:delete;
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
                    dojo => $dojo,
                    user_id => $user_data<id>,
                    techniques => @techniques.join(','),
                    training_types => @training_types.join(','),
                    session_id => $session_id,
                );
            }

            # "see-other" generates a 303, causing a GET
            redirect :see-other, "/user/$user_name/training-sessions";
        };

        get -> LoggedIn $user,'user', $user_name, 'training-session', 'add' {
            my %user_data = $mj.get_user_data( user_name => $user.username );
            my $waza = Judo.waza();

            my $t = Template::Mojo.from-file('views/user/training-session/add_edit.tm');
            content 'text/html', $t.render(
                {
                    user_data => %user_data,
                    waza => $waza,
                }
            );
        };
        post -> LoggedIn $user,'user', $user_name, 'training-session', 'add' {
            my $user_data = $mj.get_user_data( user_name => $user.username );

            request-body -> ( *%params ) {
                my @techniques;
                my $date = %params<session-date>:delete;
                my $dojo = %params<session-dojo>:delete;
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
                        dojo => $dojo,
                        user_id => $user_data<id>,
                        techniques => @techniques.join(','),
                        training_types => @training_types.join(','),
                    );

                    # "see-other" generates a 303, causing a GET
                    redirect :see-other, "/user/$user_name";
                }
            }

        };

        get -> 'favicon.ico', {static 'static/favicon.ico' };

        get -> 'js', *@path {
            static 'static/js/', @path;
        }

        get -> 'css', *@path {
            static 'static/css/', @path;
        }
        
        get -> 'img', *@path {
            static 'static/img/', @path;
        }
    }
}
