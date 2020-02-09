package App::AHAProject::Module::GPIO;
use strict;
use warnings FATAL => 'all';

use parent 'App::AHAProject::Module::Base';

use App::AHAProject::Module::GPIO::Pin;

use Carp;

sub new {
    my ($class, %params) = @_;
    my $self = $class->SUPER::new(%params);

    croak "Argument 'pinout' should be supplied" unless $params{pinout};

    # This one will initialize pins scheme
    $self->{pins} = $self->initPins($params{pinout});

    # This one will initialize pins initial state if it is specified
    if ($params{pins}) {
        $self->acquirePins($params{pins});
    }

    return $self;
}

sub getPin {
    my ($self, $pinNum) = @_;

    if (!defined $pinNum || $pinNum !~ /^\d+$/) {
        croak "Argument pinNum should be a number.";
    }

    if (scalar(@{$self->{pins}}) <= $pinNum) {
        croak "Requested non-existing pin";
    }

    return($self->{pins}->[$pinNum]);
}

sub initPins {
    my ($self, $pinout) = @_;

    $self->{pins} = [];

    for (keys %$pinout) {
        $self->{pins}->[$_] = App::AHAProject::Module::GPIO::Pin->new(%{$pinout->{$_}});
    }

    return $self->{pins};
}

sub acquirePins {
    my ($self, $pins) = @_;
    croak 'not implemented';
}

1;