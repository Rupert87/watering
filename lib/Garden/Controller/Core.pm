package Garden::Controller::Core;
use Mojo::Base 'Mojolicious::Controller';

sub home {
    my $self = shift;
    
   #$self->auth->verifysession();
    
    return $self;
    }

#sub home { 
 #  my $self->session->'id' // '00000000-0000-0000-0000-000000000000';
  #  if($self->auth-verifysession($session)){
   #     $self->redirect_to($self->flash('destination')) and return if defined $self->flash('destination');
    #    $self->redirect_to($self->config('landingpageforhome')) and return;
        
     #   }
    
    
    
    
    #}
1;