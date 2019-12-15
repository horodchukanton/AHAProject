#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use base qw(Test::Class);
use Test::More tests => 5;

use_ok('App::AHAProject::Sensor::Concrete::DHT11');

sub create_sensor :Test(startup) {
    shift->{id} = '_test_sensor_' . int(rand(5000));
}

sub remove_sensor :Test(shutdown) {

}

sub dht11 :Tests(4) {
    my $dht = App::AHAProject::Sensor::Concrete::DHT11->new(id => shift->{id});

    my $temp_value = $dht->getTemperature()->getLastValue();
    ok(!defined $temp_value, 'No last temp value on a fresh sensor');

    my $humdt_value = $dht->getHumidity()->getLastValue();
    ok(!defined $humdt_value, 'No last humidity value on a fresh sensor');

    my $test_value_temp = 22;
    my $test_value_humdt = 80;

    # $dht->addValue('temperature', $test_value_temp);
    # $dht->addValue('humidity', $test_value_humdt);


    $dht->getTemperature()->addValue($test_value_temp);
    $dht->getHumidity()->addValue($test_value_humdt);

    my $last_temp_value = $dht->getTemperature()->getLastValue();
    ok($last_temp_value == $test_value_temp, 'Last temp value is what has been set up');

    my $last_humdt_value = $dht->getHumidity()->getLastValue();
    ok($last_humdt_value == $test_value_humdt, 'Last humidity value is what has been set up');

}


Test::Class->runtests();

done_testing();

