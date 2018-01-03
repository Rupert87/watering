package Garden::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller';

sub login_form{
	my $self = shift;
	
	$self->render('account/login');
}

sub authenticate{
	my $self = shift;
	
	my $session = $self->session->{'id'} // '00000000-0000-0000-0000-000000000000';
	if($self->auth->verifySession($session)){
		#checking what we have in the database vs what is in the cookie if there is one
		#if there is no cookie for this domain, create one
		my $session = $self->auth->retrieveSessionByID($session);
		$self->session($session);
		if($self->session('account_type') eq 'Admin'){
			$self->render('water/status');
		} else {
			$self->render('core/home');
		}
	}
        
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
		$self->redirect_to($self->url_for('menu'));
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