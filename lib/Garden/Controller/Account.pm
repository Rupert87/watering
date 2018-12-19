package Garden::Controller::Account;
use Mojo::Base 'Mojolicious::Controller';


sub new_user_form{
	my $self = shift;
}

sub new_user{
	my $self = shift;
	
	my $rv = $self->account->create($self->param('firstname'),$self->param('lastname'),$self->param('password1'),$self->param('username'),0,$self->param('account_type'));

	if($rv->{'status'}){
		$self->redirect_to($self->url_for('login_form'));
	} else {
		#failed to login
	}
}
1;