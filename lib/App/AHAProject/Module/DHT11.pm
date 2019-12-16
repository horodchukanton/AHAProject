package App::AHAProject::Module::DHT11;
use strict;
use warnings FATAL => 'all';

use base 'App::AHAProject::Module::Base';

my @measurables = (
    {
        name   => 'temperature',
        sensor => 'Temperature',
        type   => 'absolute',
        class  => 'TimeSeries',
        public => 1
    },
    {
        name   => 'humidity',
        sensor => 'Humidity',
        type   => 'relative',
        class  => 'TimeSeries',
        public => 1
    }
);

sub new {
    my ($class, %params) = @_;
    my $self = $class->SUPER::new(%params);

    return $self;
}

sub getSensorDefinitions {
    return \@measurables;
}

#@returns App::AHAProject::Sensor::Temperature
sub getTemperature {
    my ($self) = @_;
    return $self->{temperature};
}

#@returns App::AHAProject::Sensor::Humidity
sub getHumidity {
    my ($self) = @_;
    return $self->{humidity};
}

1;