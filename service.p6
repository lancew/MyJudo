use Cro::HTTP::Log::File;
use Cro::HTTP::Server;
use Cro::HTTP::Session::InMemory;
use Routes;

my Cro::Service $http = Cro::HTTP::Server.new(
    http => <1.1 2>,
    host => %*ENV<MYJUDO_HOST> ||
        die("Missing MYJUDO_HOST in environment"),
    port => %*ENV<MYJUDO_PORT> ||
        die("Missing MYJUDO_PORT in environment"),
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
