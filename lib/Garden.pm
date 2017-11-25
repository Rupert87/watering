package Garden;
use Mojo::Base 'Mojolicious';

use Mojo::Pg;
use Garden::Model::Account;
use Garden::Model::Menu;
use Garden::Model::Time;
use Garden::Model::Water;
use Garden::Model::Auth;

# This method will run once at server start
sub startup {
 
 my $self = shift;
 
 $self->secrets(['password']);
  $self->session(expiration => 28800);
 
 $self->plugin('Config');
  
  $self->helper(t => sub {state $t = localtime});
  
  $self->helper(pg => sub { state $pg = Mojo::Pg->new( shift->config('pg'))});
  
  $self->pg->search_path(['watering','auth','public']);
  
  $self->helper(account => sub {
          my $app = shift;
          state $account = Garden::Model::Account->new(pg => $app->pg, debug => $app->app->mode eq 'development' ? 1 : 0)
  });
  $self->helper(menu => sub {
          my $app = shift;
          state $menu = Garden::Model::Menu->new(pg => $app->pg, debug => $app->app->mode eq 'development' ? 1 : 0)
  });
  
  $self->helper(time => sub {
          my $app = shift;
          state $time = Garden::Model::Time->new(pg => $app->pg, debug => $app->app->mode eq 'development' ? 1 : 0)
  });
  
  $self->helper(water => sub {
          my $app = shift;
          state $water = Garden::Model::Water->new(pg => $app->pg, debug => $app->app->mode eq 'development' ? 1 : 0)
  });
  
  $self->helper(auth => sub {
          my $app = shift;
          state $auth = Garden::Model::Auth->new(pg => $app->pg, debug => $app->app->mode eq 'development' ? 1 : 0)
  });
  

  # Load configuration from hash returned by "my_app.conf"
  my $config = $self->plugin('Config');

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer') if $config->{perldoc};

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('core#home');
  $r->get('/auth')->to('auth#login_form')->name('login_form');
  $r->post('/auth')->to('auth#login')->name('login');
  
  # Authed routes, must have account to access
  my $authed = $r->under()->to('auth#check_session');
  $authed->get('/water')->to('water#menu')->name('menu');
  $authed->get('/water/status')->to('water#status')->name('status');
  $authed->post('/water')->to('water#tracking')->name('tracking');#use to track status of water controller 
}
1;
