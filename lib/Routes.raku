use Cro::HTTP::Router;
use Template::Mojo;
use Template::Mustache;

use Judo;
use MyJudo;
use Crypt::Bcrypt;
use DBIish;

#| HTTP route definitions for the MyJudo web application.
#| Handles authentication, user management, and training session CRUD.

#| Version string shown in the page footer. Resolved from, in order:
#| the MYJUDO_VERSION env var, a git hash stamped at image build time
#| (.git-hash), a live git checkout, or a fallback marker.
my $version = sub {
    my $env = %*ENV<MYJUDO_VERSION>;
    return "$env" if $env;

    my $file = try $*CWD.add('.git-hash').slurp.trim;
    return "$file" if $file;

    if $*CWD.add('.git').d {
        my $proc = run('git', 'rev-parse', '--short', 'HEAD', :out, :err);
        my $git  = $proc.out.slurp.trim;
        return "$git" if $git;
    }

    'dev-build';
}();

#| Common view data merged into every template render.
my sub view(Hash $data) {
    $data<version> //= $version;
    $data<year>    //= Date.today.year;
    $data
}

#| Merge per-page SEO metadata (page title, description, canonical path)
#| into the view data for the shared header.
my sub meta(Hash $data, Str :$title!, Str :$description, Str :$canonical) {
    $data<title>       = $title;
    $data<description> = $description // 'Judo training application, record your sessions and techniques';
    $data<canonical>   = $canonical // '/';
    view($data)
}

class UserSession does Cro::HTTP::Auth {
    has $.username is rw;

    method logged-in() { defined $!username }
}

my $mj = MyJudo.new(
    dbh => DBIish.connect("SQLite", :database<db/myjudo.db>),
);

my $stache = Template::Mustache.new: :from('views'.IO.absolute);

#| Extract training types from request parameters.
#| Returns a list of valid training type strings found in %params.
my sub extract_training_types(%params) {
    my @valid_types = Judo.training_types;
    my @found;
    for @valid_types -> $type {
        @found.push($type) if %params{$type}:delete;
    }
    @found
}

#| Extract technique names from remaining request parameters.
#| Returns a comma-joined string of lowercased technique names.
my sub extract_techniques(%params) {
    my @techniques;
    for %params.kv -> $k, $v {
        @techniques.push(lc $k);
    }
    @techniques.join(',')
}

sub routes() is export {
    route {
        subset LoggedIn of UserSession where *.logged-in;

        # Home page
        get -> {
            content 'text/html', $stache.render('index', meta(%(), title => 'MyJudo.net - Judo Training Tracker', description => 'Track your Judo training sessions and techniques.'));
        }

        # Registration
        get -> 'register' {
            content 'text/html', $stache.render('register', meta(%(), title => 'Register | MyJudo.net - Judo Training Tracker', canonical => '/register'));
        }

        post -> 'register' {
            request-body -> %params {
                if %params<passwordsignup> eq %params<passwordsignup_confirm> {
                    my $is_taken = $mj.is_username_taken(
                        user_name => %params<usernamesignup>,
                    );
                    content 'text/html', 'Username is taken' if $is_taken;

                    $mj.add_new_user(
                        user_name => %params<usernamesignup>,
                        password  => %params<passwordsignup>,
                        email     => %params<emailsignup>,
                    );
                    redirect :see-other, "/login";
                }
            }
        }

        # Password change
        get -> LoggedIn $user, 'password-change' {
            content 'text/html', $stache.render('password-change', meta(%(), title => 'Change Password | MyJudo.net - Judo Training Tracker', canonical => '/password-change'));
        }

        post -> LoggedIn $user, 'password-change' {
            request-body -> %params {
                if %params<password-new>.chars
                   && %params<password-new> eq %params<password-repeat> {
                    my ($user_id, $user_name) = $mj.valid_user_credentials(
                        user_name => $user.username,
                        password  => %params<password>,
                    );
                    if $user_id {
                        $mj.password_change(
                            username => $user.username,
                            password => %params<password-new>,
                        );
                        redirect "/user/$user_name", :see-other;
                    }
                }
            }
            content 'text/html', 'Password change error';
        }

        # Password reset
        get -> 'password-reset' {
            content 'text/html', $stache.render('password-reset', meta(%(), title => 'Password Reset | MyJudo.net - Judo Training Tracker', canonical => '/password-reset'));
        }

        post -> 'password-reset' {
            request-body -> %params {
                if %params<login> {
                    $mj.password_reset_request(
                        login => %params<login>,
                    );
                }
            }
            content 'text/html', $stache.render('password-reset', meta(%( :submitted(1) ), title => 'Password Reset | MyJudo.net - Judo Training Tracker', canonical => '/password-reset'));
        }

        # Logout
        get -> UserSession $user, 'logout' {
            $user.username = Nil;
            redirect :see-other, "/";
        }

        # Login
        get -> 'login' {
            content 'text/html', $stache.render('login', meta(%( :nav-login(1) ), title => 'Login | MyJudo.net - Judo Training Tracker', canonical => '/login'));
        }

        post -> UserSession $user, 'login' {
            request-body -> %params {
                if %params<login> && %params<password> {
                    my ($user_id, $user_name) = $mj.valid_user_credentials(
                        user_name => %params<login>,
                        password  => %params<password>,
                    );

                    if $user_id {
                        $user.username = $user_name;
                        redirect "/user/$user_name", :see-other;
                    } else {
                        redirect :see-other, "/login";
                    }
                }
            }
        }

        # User home dashboard
        get -> LoggedIn $user, 'user', $user_name {
            my %data = $mj.get_user_data(user_name => $user.username);
            my %waza = Judo.waza;
            my %flat_waza = Judo.flattened_waza;

            my @sessions;
            for %data<session_types>.sort(*.value).reverse>>.kv.flat -> $name, $number {
                @sessions.push: { name => $name.tc, :$number };
            }

            my @techniques;
            for %data<techniques>.sort(*.value).reverse>>.kv.flat -> $name, $number {
                @techniques.push: {
                    kanji                 => %flat_waza{$name}<kanji> // '',
                    number                => $number || 0,
                    name                  => $name.tc,
                    techniques_this_month => %data<techniques_this_month>{$name} || 0,
                    techniques_last_month => %data<techniques_last_month>{$name} || 0,
                    techniques_this_year  => %data<techniques_this_year>{$name} || 0,
                };
            }

            content 'text/html', $stache.render(
                'user/home',
                meta(%( :%data, :@sessions, :@techniques, :$user, :%waza ),
                    title => 'My Jüdo Home | MyJudo.net - Judo Training Tracker',
                    canonical => "/user/$user_name"));
        }

        # Training sessions list
        get -> LoggedIn $user, 'user', $user_name, 'training-sessions' {
            my %data = $mj.get_user_data(user_name => $user.username);
            my @sessions = $mj.get_training_sessions(user_id => %data<id>);

            content 'text/html', $stache.render(
                'user/training-sessions',
                meta(%( :%data, :@sessions, total => @sessions.elems, :$user ),
                    title => "Training Sessions for $user_name | MyJudo.net",
                    canonical => "/user/$user_name/training-sessions"));
        }

        # Edit training session
        get -> LoggedIn $user, 'user', $user_name, 'training-session', 'edit', $session_id {
            my %user_data = $mj.get_user_data(user_name => $user.username);
            my $waza = Judo.waza;

            my $training_session = $mj.get_training_session(
                user_id     => %user_data<id>,
                session_id  => $session_id,
            );

            my $t = Template::Mojo.from-file('views/user/training-session/add_edit.tm');
            content 'text/html', $t.render(|meta(%{
                session    => $training_session,
                user_data  => %user_data,
                waza       => $waza,
            }, title => "Edit Session | MyJudo.net",
                canonical => "/user/$user_name/training-session/edit/$session_id").pairs);
        }

        post -> LoggedIn $user, 'user', $user_name, 'training-session', 'edit', $session_id {
            my $user_data = $mj.get_user_data(user_name => $user.username);

            request-body -> (*%params) {
                my $date    = %params<session-date>:delete;
                my $dojo    = %params<session-dojo>:delete;
                my @types   = extract_training_types(%params);
                my $techniques = extract_techniques(%params);

                $mj.training_session_update(
                    date           => $date,
                    dojo           => $dojo,
                    user_id        => $user_data<id>,
                    techniques     => $techniques,
                    training_types => @types.join(','),
                    session_id     => $session_id,
                );
            }

            redirect :see-other, "/user/$user_name/training-sessions";
        }

        # Add training session
        get -> LoggedIn $user, 'user', $user_name, 'training-session', 'add' {
            my %user_data = $mj.get_user_data(user_name => $user.username);
            my $waza = Judo.waza;

            my $t = Template::Mojo.from-file('views/user/training-session/add_edit.tm');
            content 'text/html', $t.render({
                user_data => %user_data,
                waza      => $waza,
            });
        }

        post -> LoggedIn $user, 'user', $user_name, 'training-session', 'add' {
            my $user_data = $mj.get_user_data(user_name => $user.username);

            request-body -> (*%params) {
                my $date    = %params<session-date>:delete;
                my $dojo    = %params<session-dojo>:delete;
                my @types   = extract_training_types(%params);
                my $techniques = extract_techniques(%params);

                my $session_exists = $mj.training_session_exists(
                    user_id => $user_data<id>,
                    date    => $date,
                );

                if $session_exists {
                    content 'text/html', 'Session already exists - edit instead';
                } else {
                    $mj.training_session_add(
                        date           => $date,
                        dojo           => $dojo,
                        user_id        => $user_data<id>,
                        techniques     => $techniques,
                        training_types => @types.join(','),
                    );
                    redirect :see-other, "/user/$user_name";
                }
            }
        }

        # Static assets
        get -> 'favicon.ico', { static 'static/favicon.ico' };

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
