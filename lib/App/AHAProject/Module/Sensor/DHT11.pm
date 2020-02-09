package App::AHAProject::Module::Sensor::DHT11;
use strict;
use warnings FATAL => 'all';

use parent qw/App::AHAProject::Module::Base/;

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

my %pinoutScheme = (
    0 => { id => 'power', type => 'power' },
    1 => { id => undef, type => undef },
    2 => { id => 'data', type => 'data' },
    3 => { id => 'ground', type => 'ground' },
);

sub new {
    my ($class, %params) = @_;
    my $self = $class->SUPER::new(%params);

    return $self;
}

sub getPinoutScheme {
    return \%pinoutScheme;
}

sub getMeasurables {
    return \@measurables;
}

#@returns App::AHAProject::Value::Temperature
sub getTemperature {
    my ($self) = @_;
    return $self->{temperature};
}

#@returns App::AHAProject::Value::Humidity
sub getHumidity {
    my ($self) = @_;
    return $self->{humidity};
}

1;