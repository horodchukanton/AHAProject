package App::AHAProject::Board::ESP8266;
use strict;
use warnings FATAL => 'all';

use base 'App::AHAProject::Module::Base';

sub new {
    my ($class, %params) = @_;



    my $self = { %params };
    bless $self, $class;
    return $self;
}

1;