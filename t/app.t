use v6.c;
use Test;
use Bailador::Test;

plan 4;

%*ENV<P6W_CONTAINER> = 'Bailador::Test';
%*ENV<BAILADOR_APP_ROOT> = $*CWD.absolute;
my $app = EVALFILE "bin/app.pl6";

subtest {
    plan 5;
    my %data = run-psgi-request($app, 'GET', '/');
    my $html = %data<response>[2];
    %data<response>[2] = '';
    is-deeply %data<response>[0], 200, 'GET 200 status';
    is %data<err>, '', 'No errors';
    like $html, rx:s/Register/;
    like $html, rx:s/Login/;
    like $html, rx:s/Logout/;
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
    is-deeply %data<response>[0], 200;
    is %data<err>, '';
}, '/logout';

subtest {
    plan 2;
    my %data = run-psgi-request($app, 'GET', '/register');
    my $html = %data<response>[2];
    %data<response>[2] = '';
    is-deeply %data<response>[0], 200;
    is %data<err>, '';
}, '/register';
