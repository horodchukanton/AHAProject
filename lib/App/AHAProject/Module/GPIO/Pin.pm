package App::AHAProject::Module::GPIO::Pin;
use strict;
use warnings FATAL => 'all';

use constant {
    NONE           => '',
    POWER          => 'power',
    GROUND         => 'ground',
    INPUT          => 'input',
    DIGITAL_INPUT  => 'digitalinput',
    DIGITAL_OUTPUT => 'digitaloutput',
    PWM            => 'pwm',
    ANALOG_INPUT   => 'analoginput',
    ANALOG_OUTPUT  => 'analogoutput',
};

sub new {
    my ($class, %params) = @_;
    my $self = {
        %params
    };
    bless $self, $class;
    return $self;
}

sub isPower {return(shift->getType() eq POWER)}
sub isGround {return(shift->getType() eq GROUND)}
sub isInput {return(shift->getType() eq INPUT)}
sub isDigitalInput {return(shift->getType() eq DIGITAL_INPUT)}
sub isDigitalOutput {return(shift->getType() eq DIGITAL_OUTPUT)}
sub isPWM {return(shift->getType() eq PWM)}
sub isAnalogInput {return(shift->getType() eq ANALOG_INPUT)}
sub isAnalogOutput {return(shift->getType() eq ANALOG_OUTPUT)}

package App::AHAProject::Module::GPIO::Pin::None;
sub getType() {return(App::AHAProject::Module::GPIO::Pin::NONE)};

package App::AHAProject::Module::GPIO::Pin::Power;
sub getType() {return(App::AHAProject::Module::GPIO::Pin::POWER)};

package App::AHAProject::Module::GPIO::Pin::Ground;
sub getType() {return(App::AHAProject::Module::GPIO::Pin::GROUND)};

package App::AHAProject::Module::GPIO::Pin::Input;
sub getType() {return(App::AHAProject::Module::GPIO::Pin::INPUT)};

package App::AHAProject::Module::GPIO::Pin::DigitalInput;
sub getType() {return(App::AHAProject::Module::GPIO::Pin::DIGITAL_INPUT)};

package App::AHAProject::Module::GPIO::Pin::DigitalOutput;
sub getType() {return(App::AHAProject::Module::GPIO::Pin::DIGITAL_OUTPUT)};

package App::AHAProject::Module::GPIO::Pin::PWM;
sub getType() {return(App::AHAProject::Module::GPIO::Pin::PWM)};

package App::AHAProject::Module::GPIO::Pin::AnalogInput;
sub getType() {return(App::AHAProject::Module::GPIO::Pin::ANALOG_INPUT)};

package App::AHAProject::Module::GPIO::Pin::AnalogOutput;
sub getType() {return(App::AHAProject::Module::GPIO::Pin::ANALOG_OUTPUT)};

1;