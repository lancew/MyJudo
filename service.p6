use Cro::HTTP::Log::File;
use Cro::HTTP::Router;
use Cro::HTTP::Server;
use Cro::HTTP::Session::InMemory;
use Routes;

$*ERR.out-buffer = $*OUT.out-buffer = False;

class StrictTransportSecurity does Cro::Transform {
        has Duration:D $.max-age is required;

        method consumes() { Cro::HTTP::Response }
        method produces() { Cro::HTTP::Response }

        method transformer(Supply $pipeline --> Supply) {
            supply {
                whenever $pipeline -> $response {
                    $response.append-header:
                        'Strict-Transport-Security',
                        "max-age=$!max-age; includeSubDomains; preload";
                    emit $response;
                }
            }
        }
    }

class XFrameHeaders does Cro::Transform {
        method consumes() { Cro::HTTP::Response }
        method produces() { Cro::HTTP::Response }

        method transformer(Supply $pipeline --> Supply) {
            supply {
                whenever $pipeline -> $response {
                    $response.append-header:
                        'Content-Security-Policy',
                        "frame-ancestrors 'none'";
                    $response.append-header:
                        'X-Frame-Options',
                        'DENY';
                    $response.append-header:
                        'X-XSS-Protection',
                        '1; mode=block';
                    emit $response;
                }
            }
        }
    }

# Redirect HTTP to HTTPS.
my $http = Cro::HTTP::Server.new(
    :1080port,
    :host<0.0.0.0>,
    application => route {
        get -> *@path, :%headers is header {
            my $url = "https://%headers<Host>" ~ (request.path // '');

            $url ~= '?' ~ request.query if request.query;

            redirect :permanent, $url;
        }
    },
);

my $https = Cro::HTTP::Server.new(
    :1443port,
    :host<0.0.0.0>,
    # FIXME h2 POST /register - Can not decode a utf-8 buffer as if it were ascii
    http => <1.1>,
    before => [
        Cro::HTTP::Session::InMemory[UserSession].new;
    ],
    tls => %(
        private-key-file => %*ENV<MYJUDO_TLS_KEY> ||
            %?RESOURCES<fake-tls/server-key.pem> || "resources/fake-tls/server-key.pem",
        certificate-file => %*ENV<MYJUDO_TLS_CERT> ||
            %?RESOURCES<fake-tls/server-crt.pem> || "resources/fake-tls/server-crt.pem",
        ciphers => 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256',
    ),
    application => routes(),
    after => [
        Cro::HTTP::Log::File.new(logs => $*OUT, errors => $*ERR),
        # set max age to be one year and one day, 366 days
        StrictTransportSecurity.new(max-age => Duration.new(366 * 24 * 60 * 60)),
        XFrameHeaders.new(),
    ]
);

$http.start;
$https.start;

say 'Listening…';

react {
    whenever signal(SIGINT) {
        say 'Stopping…';

        $http.stop;
        $https.stop;

        done;
    }
}
