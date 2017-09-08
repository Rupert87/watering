use Mojolicious::Lite;

# /foo?user=sri
get '/foo' => sub {
  my $c    = shift;
  my $user = $c->param('user');
  $c->render(text => "Hello $user.");
};

app->start;