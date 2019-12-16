package App::AHAProject::Data::TimeSeries;
use strict;
use warnings FATAL => 'all';

# one value per second for a day
my $cache_limit = 86400;

sub new {
    my ($class, %params) = @_;
    my $self = {
        cachedPoints => [],
        (%params)
    };
    bless $self, $class;
    return $self;
}

sub addValue {
    my ($self, $value) = @_;
    push(@{$self->{cachedValues}}, $value);
}

sub getValues {
    return shift->{cachedValues};
}

sub getLastValue {
    my ($self) = @_;
    return $self->{cachedValues}->[$#{$self->{cachedValues}}];
}

1;