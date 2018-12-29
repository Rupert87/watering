package Garden::Controller::Core;
use Mojo::Base 'Mojolicious::Controller';

#sub home {
#    my $self = shift;
    
 #   my $session = $self->session->{'id'} // '00000000-0000-0000-0000-000000000000';
    
   # return $self;
  #  }

sub home {
my $self = shift;

}

sub signup_form {
    
my $self = shift;

}

In Menu

sub menu{
 
 say 'Menu';
 
 say '(S)hedule time to start water';
 
 say '(r)listtime';
 
 print 'Choice: ';
 my $user_input= <STDIN>;
 chomp($user_input);
 return ($user_input);
 
 }



1;