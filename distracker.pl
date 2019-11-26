#!/usr/bin/env perl
use Mojolicious::Lite;
use Distracker;

get '/' => sub {
  my $c = shift;

  my @sensors = Distracker::get_sensors();

  my @text = ();
  for (@sensors){
    push @text, "Sensor $_->{name}";
    push(@text, Distracker::read_values($_->{id}));
  }

  $c->render(text => join("<br>", @text));
};

post '/:id/:temp/:humidity' => sub {
  my $c = shift;
  my $id = $c->param('id');

  Distracker::save_values($id, {
      temp => $c->param('temp'),
      humidity => $c->param('humidity')
  });

  $c->render(text => 'received')
};

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Welcome';
<h1>Welcome to the Mojolicious real-time web framework!</h1>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>
