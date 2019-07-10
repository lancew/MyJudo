use Cro::HTTP::Log::File;
use Cro::HTTP::Router;
use Cro::HTTP::Server;
use Cro::HTTP::Session::InMemory;
use Routes;

$*ERR.out-buffer = $*OUT.out-buffer = False;

class CSPolicy does Cro::Transform {
        method consumes() { Cro::HTTP::Response }
        method produces() { Cro::HTTP::Response }

        method transformer(Supply $pipeline --> Supply) {
            supply {
                whenever $pipeline -> $response {
                    $response.append-header:
                        'Content-Security-Policy',
                        "frame-ancestors 'none'";
                    $response.append-header:
                        'Content-Security-Policy-Report-Only',
                        "default-src 'none';"
                        ~ "font-src 'self';"
                        ~ "img-src 'self' data:;"
                        ~ "object-src 'none';"
                        ~ "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://www.gstatic.com https://cdnjs.cloudflare.com;"
                        ~ "style-src 'self' 'unsafe-inline' https://www.gstatic.com;"
                        ~ "report-uri /csp-violation/;";
                    emit $response;
                }
            }
        }
    }

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

class XHeaders does Cro::Transform {
        method consumes() { Cro::HTTP::Response }
        method produces() { Cro::HTTP::Response }

        method transformer(Supply $pipeline --> Supply) {
            supply {
                whenever $pipeline -> $response {
                    $response.append-header:
                        'X-Frame-Options',
                        'DENY';
                    $response.append-header:
                        'X-XSS-Protection',
                        '1; mode=block';
                    $response.append-header:
                        'X-Content-Type-Options',
                        'nosniff';
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
    # FIXME POST /login doesnt't work with h2.
    http => <1.1>,
    before => [
        Cro::HTTP::Session::InMemory[UserSession].new;
    ],
    tls => %(
        private-key-file => %*ENV<MYJUDO_TLS_KEY> ||
            %?RESOURCES<fake-tls/server-key.pem> || "resources/fake-tls/server-key.pem",
        certificate-file => %*ENV<MYJUDO_TLS_CERT> ||
            %?RESOURCES<fake-tls/server-crt.pem> || "resources/fake-tls/server-crt.pem",
    ),
    application => routes(),
    after => [
        Cro::HTTP::Log::File.new(logs => $*OUT, errors => $*ERR),
        # set max age to be one year and one day, 366 days
        StrictTransportSecurity.new(max-age => Duration.new(366 * 24 * 60 * 60)),
        XHeaders.new(),
        CSPolicy.new(),
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
