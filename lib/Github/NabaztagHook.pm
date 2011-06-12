package Github::NabaztagHook;
# ABSTRACT: root package for the Nabaztag webhook routes

=head1 DESCRIPTION

This package provides the needed routes and all the Dancer code.

=cut

use Dancer ':syntax';
use Nabaztag::Client;

my $_nabaztag;

sub nabaztag {
    return $_nabaztag if defined $_nabaztag;
    
    $_nabaztag = Nabaztag::Client->new(
        serial => setting('serial'),
        token  => setting('token')
    );
}

post '/' => sub {
    my $payload = from_json(param('payload'));
    my $format  = setting('app')->{'message_format'};
    my $message = _get_message($payload, $format);

    nabaztag->send_message(message => $message);
};

sub _get_message {
    my ($payload, $format) = @_;

    my $repo = $payload->{repository}{name};
    my $commits = $payload->{commits};
    my %authors = map { $_->{author}{name} => 1 } @$commits;
    my $authors = join(', ', sort(keys(%authors)));

    my $message = $format;
    $message =~ s/%a/$authors/g;
    $message =~ s/%p/$repo/g;

    return $message;
}

1;
