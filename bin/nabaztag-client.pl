use Nabaztag::Client;

my $client = Nabaztag::Client->new(
    serial => $ARGV[0],
    token => $ARGV[1],
);

$client->send_message(message => $ARGV[2]);
