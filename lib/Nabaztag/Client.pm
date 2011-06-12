package Nabaztag::Client;
# ABSTRACT: HTTP client for the Nabaztag webservice

use Carp;
use Const::Fast;
use LWP::UserAgent;
use Moose;
use MooseX::Params::Validate;
use URI::Escape;

=attr serial 

The serial number of the Nabaztag to request

You can get your Nabaztag's SN on http://violet.net/object_ecosystem

=cut

has serial => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);


=attr token

The token of the Nabaztag to request

You can get your Nabaztag's token on http://violet.net/object_ecosystem

=cut

has token => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

=method send_message

Send a message to the Nabaztag for reading.

Arguments:

    - "message" (Str): the message to send

Returns: 

    - Void on success, exception on failure

=cut

const my $_NABAZTAG_API_ROOT => 'http://api.nabaztag.com/vl/FR/api.jsp';

sub send_message {
    my ($self, $message) = validated_list(\@_, message => {isa => 'Str'});

    my $url =
        $_NABAZTAG_API_ROOT . '?sn='
      . $self->serial
      . '&token='
      . $self->token . '&tts='
      . uri_escape($message);

    my $ua = LWP::UserAgent->new;
    my $response = $ua->get($url);

    # TODO use XML::Simple to parse the response
    if ($response->is_success) {
        $response->content =~ /TTSSENT/
          or croak "Unable to send the message";
    }
    else {
        croak "Error received when communicating with Nabaztag API webservice";
    }
}

1;
