#!/usr/bin/perl
use strict;
use warnings 'FATAL' => 'all';

use parent 'Test::Class';
use Test::More tests => 6;

use App::AHAProject::Module::Sensor::DHT11;
use App::AHAProject::Board::ESP8266;
use_ok('App::AHAProject::Board::ESP8266');

sub generate_board_and_module : Test(startup) {
    my ($test) = @_;
    $test->{id} = '_test_board_' . rand(9999);

    my $dht = App::AHAProject::Module::Sensor::DHT11->new(id => $test->{id});
    my $esp = App::AHAProject::Board::ESP8266->new(id => $test->{id});

    $dht->setPins(
        ground => $esp->getGPIO()->getPin('7'),
        power  => $esp->getGPIO()->getPin('8'),
        data   => $esp->getGPIO()->getPin('9')
    );

    $test->{dht} = $dht;
    $test->{esp} = $esp;
}

sub esp8266_module :Tests(3) {
    my $test = shift;

    my App::AHAProject::Board::ESP8266 $esp = $test->{esp};
    $esp->addModule($test->{dht});

    my %pins = $esp->getGPIO();

    ok($pins{D5}->isPower(), 'Pin connected as an DHT11 power is saved as power');
    ok($pins{D6}->isInput(), 'Pin that is used as an DHT11 digital input is saved as input');
    ok($pins{D6}->isDigitalInput(), 'Pin that is used as an DHT11 digital input is saved as digital input');
}

sub esp8266_data :Tests(2) {
    my $test = shift;

    my App::AHAProject::Board::ESP8266 $esp = $test->{esp};
    my App::AHAProject::Module::Sensor::DHT11 $dht = $test->{dht};
    $esp->addModule($dht);

    $esp->acquireData($dht->{id}, { type => 'values', temperature => 290, humidity => 600 });

    ok($dht->getTemperature()->getLastValue() == 29.0, 'Temperature acquired');
    ok($dht->getHumidity()->getLastValue() == 60.0, 'Humidity acquired');
}

Test::Class->runtests();
done_testing();

