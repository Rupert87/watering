package Garden::Controller::Account;
use Mojo::Base 'Mojolicious::Controller';

sub new_user_form{
	my $self = shift;
}

sub login{
	my $self = shift;
	
	my $rv = $self->account->get_id($self->param('firstname'),$self->param('lastname'),$self->param('password1'),$self->param('username'),0,$self->param('account_type'));

	if($rv->{'status'}){
		$self->redirect_to($self->url_for('menu'));
	} else {
		#failed to login
	}
}
1;