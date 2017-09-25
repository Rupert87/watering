package Garden::Controller::Account;
use Mojo::Base 'Mojolicious::Controller';


sub login{
    my $self = shift;
    
    my $rv = $self->auth->authenticate($self->param('firstname'),$self->param('lastname'),$self->param('password1'),$self->param('username'),0,$self->param('account_type'));
    
    if($rv->{'status'} == 1){
			$self->redirect_to('/water');
		}
	#TODO add error messages to the front end and handle error cases
	$self->redirect_to($self->url_for('menu'));
}
1;
