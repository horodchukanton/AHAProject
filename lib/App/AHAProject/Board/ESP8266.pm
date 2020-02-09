package App::AHAProject::Board::ESP8266;
use strict;
use warnings FATAL => 'all';

use parent 'App::AHAProject::Board::Base';

use constant {
    pinoutScheme => {
        total       => 30,
        vin         => 0,
        '3v'        => [ 5, 16, 25 ],
        ground      => [ 2, 17, 24 ],
        analogInput => [ 15 ],
        led         => [],
        GPIO        => {
            27   => { id => 'GPIO0', type => undef, name => => 'D27' },
            20   => { id => 'GPIO1', type => undef, name => 'D20' },
            26   => { id => 'GPIO2', type => undef, name => 'D26' },
            21   => { id => 'GPIO3', type => undef, name => 'D21' },
            28   => { id => 'GPIO4', type => undef, name => 'D28' },
            29   => { id => 'GPIO5', type => undef, name => 'D29' },
            19   => { id => 'GPIO9', type => undef, name => 'D19' },
            18   => { id => 'GPIO10', type => undef, name => 'D18' },
            24   => { id => 'GPIO12', type => undef, name => 'D24' },
            23   => { id => 'GPIO13', type => undef, name => 'D23' },
            25   => { id => 'GPIO14', type => undef, name => 'D25' },
            22   => { id => 'GPIO15', type => undef, name => 'D22' },
            30   => { id => 'GPIO16', type => undef, name => 'D30' },
        },
    }
};

sub new {
    my ($class, %params) = @_;
    my $self = $class->SUPER::new(
        %params,
        modules => []
    );

    $self->addModule(App::AHAProject::Board::ESP8266::GPIO->new(
        pinout => pinoutScheme->{GPIO},
        id     => $self->{id} . '_gpio'
    ));

    return $self;
}

#@returns App::AHAProject::Board::ESP8266::GPIO
sub getGPIO {
    my ($self, $pin) = @_;
    return $self->{modules}->[0] unless defined $pin;
    return $self->{modules}->[0]->getPin($pin);
}


package App::AHAProject::Board::ESP8266::GPIO;
use parent 'App::AHAProject::Module::GPIO';

1;