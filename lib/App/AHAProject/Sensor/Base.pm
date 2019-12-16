package App::AHAProject::Sensor::Base;
use strict;
use warnings FATAL => 'all';

sub new {
    my ($class, %params) = @_;

    my $self = { %params };
    bless $self, $class;

    $self->{data} = App::AHAProject::Data::TimeSeries->new();
    $self->{sensor} = $params{sensor};
    $self->{type} = $self->getType();

    return $self;
}

sub setValues {
    my ($self, $values) = @_;

    if (ref $values eq 'App::AHAProject::Data::TimeSeries') {
        $self->{data} = $values;
    }
    elsif (ref $values eq 'ARRAY') {
        $self->getData()->setValuesArray(@$values);
    }
}

#@returns App::AHAProject::Data::TimeSeries
sub getData {
    return(shift->{data});
}

sub getLastValue {
    return shift->getData()->getLastValue();
}

sub addValue {
    return shift->getData()->addValue(shift);
}

sub getType {
    my $self = shift;
    if (ref $self eq 'App::AHAProject::Sensor::Base') {
        die "'getType()' should be called on concrete class.";
    }

    my $typeFullName = '$App::AHAProject::Sensor::' . $self->{sensor} . '::TYPE';
    return eval {"$typeFullName"};
}



1;