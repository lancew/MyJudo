use Cro::HTTP::Log::File;
use Cro::HTTP::Server;
use Cro::HTTP::Session::InMemory;
use Routes;

my Cro::Service $http = Cro::HTTP::Server.new(
    http => <1.1>,
    host => %*ENV<MYJUDO_HOST> ||
        die("Missing MYJUDO_HOST in environment"),
    port => %*ENV<MYJUDO_PORT> ||
        die("Missing MYJUDO_PORT in environment"),
    before => [
        Cro::HTTP::Session::InMemory[UserSession].new;
    ],
    tls => %(
        private-key-file => %*ENV<ONE_TLS_KEY> ||
            %?RESOURCES<fake-tls/server-key.pem> || "resources/fake-tls/server-key.pem",
        certificate-file => %*ENV<ONE_TLS_CERT> ||
            %?RESOURCES<fake-tls/server-crt.pem> || "resources/fake-tls/server-crt.pem",
    ),
    application => routes(),
    after => [
        Cro::HTTP::Log::File.new(logs => $*OUT, errors => $*ERR)
    ]
);
$http.start;
say "Listening at http://%*ENV<MYJUDO_HOST>:%*ENV<MYJUDO_PORT>";
react {
    whenever signal(SIGINT) {
        say "Shutting down...";
        $http.stop;
        done;
    }
}
