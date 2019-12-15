requires 'JSON';
requires 'Mojolicious::Lite';

on 'test' => sub {
    requires 'Test::More';
    requires 'Test::Class';
};