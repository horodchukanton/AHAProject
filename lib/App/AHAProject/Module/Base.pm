package App::AHAProject::Module::Base;
use strict;
use warnings FATAL => 'all';

use App::AHAProject::Data::TimeSeries;

use App::AHAProject::Sensor::Humidity;
use App::AHAProject::Sensor::Temperature;
use App::AHAProject::Sensor::Moisture;

my @fields = (
    {
        name     => 'id',
        required => 1
    },
    {
        name => 'name'
    },
    {
        name => 'sensors',
        type => 'array'
    },
    {
        name => 'reportType',
        type => 'enum',
        enum => [ qw/schedule pull/ ]
    }
);

sub new {
    my ($class, %params) = @_;

    my $self = {};
    bless $self, $class;

    $self->acquireParameters(\%params, \@fields);
    $self->initSensors();

    return $self;
}

sub acquireParameters {
    my ($self, $parameters, $givenFields) = @_;

    for (@$givenFields) {
        if ($_->{required} && !$parameters->{$_->{name}}) {
            die "No \$params{$_->{name}} given to the Sensor constructor.\n";
        }
        else {
            $self->{$_->{name}} = $parameters->{$_->{name}};
        }
    }
}


sub initSensors {
    my ($self) = @_;

    for my $m (@{$self->getSensorDefinitions}) {
        my $sensor = _initializeSensor(%$m);
        $self->{$m->{name}} = $sensor;
        push(@{$self->{sensors}}, $sensor);
    }
}

sub getSensors {
    my $self = shift;
    return wantarray ? @{$self->{sensors}} : $self->{sensors};
}

sub getSensorDefinitions {
    die "'getSensorDefinitions()' should be overridden in the concrete class";
}

sub _initializeSensor {
    my (%measurableDefinition) = @_;

    my $package = "App::AHAProject::Sensor::" . $measurableDefinition{sensor};
    my $instance = $package->new(%measurableDefinition);

    return $instance;
}

=cut

# Using perl magic is awesome, but looks ugly in IDE and makes code harder to read (virtual methods are not clear when seen)
# This is saved for historical reasons.

sub prepareMeasurables {
    my ($self) = @_;

    no strict 'refs';

    for my $field (@{$self->getMeasurables()}) {
        if ($field->{public} == 1) {
            my $packageName = __PACKAGE__;
            my $getterName = 'get' . ucfirst $field->{name};
            my $setterName = 'set' . ucfirst $field->{name};

            my $setter = sub {shift->{$field->{name}} = shift};
            my $getter = sub {
                my $sensor = shift;
                return $sensor->{$field->{name}} if ($sensor->{$field->{name}});
                return $sensor->{$field->{name}} = _initializeMeasurable(%$field);
            };

            *{"$packageName\:\:$setterName"} = $setter;
            *{"$packageName\:\:$getterName"} = $getter;
        }
    }
}

=cut

1;