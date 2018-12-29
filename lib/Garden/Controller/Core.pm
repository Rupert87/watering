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

sub dispatcher{
	my $what_to_do = shift;
	
	given(lc($what_to_do)){
		when ('o') {
			one_time();
		}
		when ('r'){
			list_time();
		}
		when ('p'){
			push_follow_up_boss();
		}
		when ('q'){
			exit;
		}
		when ('s'){
            one_time();
        }
        
        default {
			say "You didn't pick something I understand, try again. (Press enter to continue)";
			<STDIN>; #pausing for the user to press enter
			menu();
		}
	}
	
}

1;