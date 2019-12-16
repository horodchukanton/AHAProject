package App::AHAProject::Data::Point;
use strict;
use warnings FATAL => 'all';


sub new {
    my ($class, %params) = @_;

    my $self = {
        time  => time(),
        value => $params{value}
    };

    bless $self, $class;
    return $self;
}

sub getTime {
    return shift->{time};
}
sub setTime {
    my ($self, $new_value) = @_;
    $self->{time} = $new_value;
    return $self;
}
sub getValue {
    return shift->{value};
}
sub setValue {
    my ($self, $new_value) = @_;
    $self->{value} = $new_value;
    return $self;
}
1;