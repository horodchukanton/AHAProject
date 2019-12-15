package App::AHAProject::Sensor::Concrete::DHT11;
use strict;
use warnings FATAL => 'all';

use base 'App::AHAProject::Sensor';

my @measurables = (
    {
        name   => 'temperature',
        type   => 'absolute',
        class  => 'TimeSeries',
        public => 1
    },
    {
        name   => 'humidity',
        type   => 'relative',
        class  => 'TimeSeries',
        public => 1
    }
);

sub new {
    my ($class, %params) = @_;
    my $self = $class->SUPER::new(%params);

    foreach my $entry (keys %App::AHAProject::Sensor::Concrete::DHT11) {
        print "$entry\n";
    }

    return $self;
}

sub getMeasurables {
    return \@measurables;
}

1;