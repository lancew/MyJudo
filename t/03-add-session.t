use Cro::HTTP::Test;
use Cro::HTTP::Auth;

use Routes;

test-service routes(), fake-auth => UserSession.new(:username('lancew')), {
    test get('user/lancew/training-session/add'),
        status => 200,
        content-type => 'text/html',
        body => /投技/; # Nage-Waza
}

done-testing;

