use strict;
use warnings;

use Test::More;
use Github::NabaztagHook;

my @tests = (
    { payload => {
        repository => {
            name => 'Super Projet',
        },
        commits => [
            { author => { name => 'Alexis' } },
            { author => { name => 'Franck' } },
            { author => { name => 'Alexis' } },
        ],
      },
      format => 'Et voici un push sur %p par %a',
      expected => 'Et voici un push sur Super Projet par Alexis, Franck'
    },
);

plan tests => scalar(@tests);

for my $test (@tests) {
    my $payload  = $test->{payload};
    my $format   = $test->{format};
    my $expected = $test->{expected};

    my $m = Github::NabaztagHook::_get_message($payload, $format);
    is $m, $expected;

}
