package App::AHAProject::Sensor;
use strict;
use warnings FATAL => 'all';

use App::AHAProject::Data::TimeSeries;

use constant {
    MEASURABLE_ABSOLUTE => 0,
    MEASURABLE_RELATIVE => 1,
    MEASURABLE_BOOLEAN  => 2,
};

my @fields = (
    {
        name     => 'id',
        required => 1
    },
    {
        name => 'name'
    }
);

sub new {
    my ($class, %params) = @_;

    my $self = {};
    bless $self, $class;

    $self->acquireParameters(\%params, \@fields);
    $self->prepareMeasurables();

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

sub getMeasurables {
    die "'getMeasurables()' should be overridden in the Concrete class";
}

sub _initializeMeasurable {
    my (%measurableDefinition) = @_;

    my $package = "App::AHAProject::Data::" . $measurableDefinition{class};

    my $instance = $package->new(%measurableDefinition);

    return $instance;
}

1;