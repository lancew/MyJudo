use v6.c;
use Test;
use Bailador::Test;
use DBIish;

plan 4;

%*ENV<P6W_CONTAINER> = 'Bailador::Test';
%*ENV<BAILADOR_APP_ROOT> = $*CWD.absolute;
my $app = EVALFILE "bin/app.pl6";
my $dbh = DBIish.connect("SQLite", :database<db/myjudo.db>);

subtest {
    plan 4;
    my %data = run-psgi-request($app, 'GET', '/');
    my $html = %data<response>[2];
    %data<response>[2] = '';
    is-deeply %data<response>[0], 200, 'GET 200 status';
    is %data<err>, '', 'No errors';
    like $html, rx:s/Register/;
    like $html, rx:s/Login/;
}, '/';

subtest {
    plan 2;
    my %data = run-psgi-request($app, 'GET', '/login');
    my $html = %data<response>[2];
    %data<response>[2] = '';
    is-deeply %data<response>[0], 200;
    is %data<err>, '';
}, '/login';

subtest {
    plan 2;
    my %data = run-psgi-request($app, 'GET', '/logout');
    my $html = %data<response>[2];
    %data<response>[2] = '';
    is-deeply %data<response>[0], 302;
    is %data<err>, '';
}, '/logout';

subtest {
    plan 4;

    _clean_tables;

    my %data = run-psgi-request($app, 'GET', '/register');
    my $html = %data<response>[2];
    %data<response>[2] = '';
    is-deeply %data<response>[0], 200, 'Get should return 200';
    is %data<err>, '', 'Get should create no errors';

    # FIXME: This test write to db/myjudo.db not the test DB
    my $username = 'tester' ~ time;
    %data = run-psgi-request($app, 'POST', '/register',
        "usernamesignup=tester&emailsignup=test@test.com&passwordsignup=foobar&passwordsignup_confirm=foobar"
    );

    is %data<response>[0], 302, 'Successful registration should redirect to /';

    my $sth = $dbh.prepare('SELECT id,username,email from users');
    $sth.execute;
    my %user = $sth.row(:hash);

    is-deeply %user, {
        id => 1,
        username => 'tester',
        email => 'test@test.com',
    }, 'New user is added';
}, '/register';

done-testing;

sub _clean_tables {
    $dbh.do('DELETE FROM users;');
    $dbh.do('DELETE FROM sensei;');
    $dbh.do('DELETE FROM sensei_sensei;');
    $dbh.do('DELETE FROM sessions;');
    $dbh.do('DELETE FROM users_sensei;');
}
