package App::AHAProject::Module::Base;
use strict;
use warnings FATAL => 'all';

use App::AHAProject::Board::Pinout;

use App::AHAProject::Data::TimeSeries;
use App::AHAProject::Value::Humidity;
use App::AHAProject::Value::Temperature;
use App::AHAProject::Value::Moisture;

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

    if ($self->can('initMeasurables')) {
        $self->initMeasurables();
    };

    if ($self->can('getPinoutScheme')) {
        $self->pinout(App::AHAProject::Board::Pinout->new(pinout => $self->getPinoutScheme()));
        initMeasurables();
    };

    return $self;
}

#@returns App::AHAProject::Board::Pinout
sub pinout {
    if (defined($_[1])) {
        $_[0]->{pinout} = $_[1];
    }
    return $_[0]->{pinout};
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


sub initMeasurables {
    my ($self) = @_;

    if (ref $self eq 'App::AHAProject::Module::Base') {
        die "initMeasurables() should be overriden in the ancestor of ...Module::Base.\n.";
    }

    if (my $method = $self->can('getMeasurables')) {
        for my $m (@{$self->$method}) {
            my $measurable = _initializeMeasurable(%$m);
            $self->{$m->{name}} = $measurable;
            push(@{$self->{measurables}}, $measurable);
        }
    }
    return 1;
}

sub getMeasurables {
    my $self = shift;
    return wantarray ? @{$self->{measurables}} : $self->{measurables};
}

sub _initializeMeasurable {
    my (%measurableDefinition) = @_;

    my $package = "App::AHAProject::Value::" . $measurableDefinition{sensor};
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