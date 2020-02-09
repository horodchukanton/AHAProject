#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use parent qw(Test::Class);
use Test::More tests => 9;
use Test::Exception;

use_ok('App::AHAProject::Module::Base');
use_ok('App::AHAProject::Module::Sensor::DHT11');

sub create_module :Test(startup) {
    shift->{id} = '_test_module_' . int(rand(5000));
}

sub remove_module :Test(shutdown) {

}

sub base_module :Tests(1) {
    my $test = shift;
    throws_ok {my $module = App::AHAProject::Module::Base->new(id => $test->{id})}
        qr/should be overriden in the ancestor of/, 'Is abstract';
}

sub module_sensors :Tests(2) {
    my $module = App::AHAProject::Module::Sensor::DHT11->new(id => shift->{id});

    my @sensors = $module->getMeasurables();

    ok(ref $sensors[0] eq 'App::AHAProject::Value::Temperature', 'Temperature sensor is initialized');
    ok(ref $sensors[1] eq 'App::AHAProject::Value::Humidity', 'Temperature sensor is initialized');

}

sub dht11_values :Tests(4) {
    my $dht = App::AHAProject::Module::Sensor::DHT11->new(id => shift->{id});

    my $temp_value = $dht->getTemperature()->getLastValue();
    ok(!defined $temp_value, 'No last temp value on a fresh sensor');

    my $humdt_value = $dht->getHumidity()->getLastValue();
    ok(!defined $humdt_value, 'No last humidity value on a fresh sensor');

    my $test_value_temp = 22;
    $dht->getTemperature()->addValue($test_value_temp);
    my $last_temp_value = $dht->getTemperature()->getLastValue();
    ok($last_temp_value == $test_value_temp, 'Last temp value is what has been set up');

    my $test_value_humdt = 80;
    $dht->getHumidity()->addValue($test_value_humdt);
    my $last_humdt_value = $dht->getHumidity()->getLastValue();
    ok($last_humdt_value == $test_value_humdt, 'Last humidity value is what has been set up');
}

Test::Class->runtests();

done_testing();

