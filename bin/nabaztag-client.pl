use Nabaztag::Client;
# PODNAME: nabaztag-client
# ABSTRACT: simple interface over the client to send messages to a Nabaztag 

my $client = Nabaztag::Client->new(
    serial => $ARGV[0],
    token => $ARGV[1],
);

$client->send_message(message => $ARGV[2]);
