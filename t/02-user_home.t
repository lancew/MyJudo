use Cro::HTTP::Test;
use Cro::HTTP::Auth;

use Routes;

test-service routes(), fake-auth => UserSession.new(:username('lancew')), {
    test get('/user/lancew'),
        status => 200,
        content-type => 'text/html',
        body => /lancew/;
}

done-testing;

