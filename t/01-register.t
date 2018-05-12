use Cro::HTTP::Test;
use Routes;

test-service routes(), {
    test get('/register'),
        status => 200,
        content-type => 'text/html',
        body => /usernamesignup/;
}

done-testing;

