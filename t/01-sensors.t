#!/usr/bin/perl
use strict;
use warnings 'FATAL' => 'all';

use parent qw(Test::Class);
use Test::More tests => 2;

use Test::Exception;

use_ok('App::AHAProject::Value::Base');
use_ok('App::AHAProject::Value::Humidity');

sub create_sensor :Test(startup) {
    shift->{id} = '_test_module_' . int(rand(5000));
}

sub remove_sensor :Test(shutdown) {

}

sub base_sensor :Tests(1) {
    my $test = shift;
    throws_ok {my $module = App::AHAProject::Value::Base->new(id => $test->{id})}
        qr/should be called on concrete class/, 'Is abstract';
}

sub sensor_type :Tests(1) {
    my $sensor = App::AHAProject::Value::Temperature->new();
    ok($sensor->getType() eq 'temperature', 'Type is correctly got from package')
}

done_testing();

