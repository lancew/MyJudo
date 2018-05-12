use Cro::HTTP::Test;
use Routes;

test-service routes(), {
    test get('/'),
        status => 200,
        content-type => 'text/html',
        body => /\/register/;
}

done-testing;

