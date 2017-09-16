package Garden;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by "my_app.conf"
  my $config = $self->plugin('Config');

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer') if $config->{perldoc};

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('Core#home');
  $r->get('/login')->('account#loginform');
  $r->post('/login')->('account#login');
  $authed = $r->under()->to('auth#checksession')
  $authed->get('/water')->to('Water#schedule')->name('schedule');
  $authed->post('/water')->to('Water#tracking')->name('tracking);#use to track status of water controller 
}

1;
