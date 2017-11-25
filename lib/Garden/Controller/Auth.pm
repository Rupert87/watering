package Garden::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller';

sub login_form{
	my $self = shift;
	
	$self->render('account/login');
}

#authenticates a user and creates their session cookie
sub login{
	my $self = shift;
	
	my $result = $self->auth->authenticate($self->param('username'),$self->param('password'));
	
	if($result->{'status'}){
		#we logged in successfully
		my $id = $self->account->get_id($self->param('username'));
		$self->_create_session($id);
		$self->redirect_to($self->url_for('menu'));
	}
}

sub check_session {
	my $self = shift;

	if($self->session->{'logged_in'}){
		return 1;
	}
	$self->flash(error => 'You tried to access a resource that requires you to be logged in.  Please login to continue.');
	if($self->tx->req->is_xhr){
		$self->render(json => {status => Mojo::JSON->false}, status => 403);
	} else {
		$self->redirect_to($self->url_for('index'));
	}
	return;
}

sub _create_session{
	my ($self,$id) = @_;
	
	$self->session({
		logged_in => 1,
		user_id => $id 
	});
}
1;