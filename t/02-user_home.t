use Cro::HTTP::Test;
use Cro::HTTP::Auth;

use Routes;

test-service routes(), fake-auth => UserSession.new(:username('asdf')), {
    # User asdf getting thier own page should work OK
    test get('/user/asdf'),
        status => 200,
        content-type => 'text/html',
        body => /asdf/;

    # User asdf getting lancew's page should get their own home page
    test get('/user/lancew'),
        status => 200,
        content-type => 'text/html',
        body => /asdf/;
}

done-testing;

