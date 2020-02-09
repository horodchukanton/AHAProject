package App::AHAProject::Board::Base;
use strict;
use warnings FATAL => 'all';

sub new {
    my ($class, %params) = @_;

    my $self = {
        name    => $params{name},
        size    => undef,
        power   => '',
        pinout  => undef,
        modules => [],
        %params,
    };
    bless $self, $class;
    return $self;
}

sub addModule {
    my ($self, $module) = @_;
    push(@{$self->{modules}}, $module);
    return($self);
};

1;