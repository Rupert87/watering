package Garden::Model::Auth;
use Mojo::Base -base;

sub authenticate{
	my ($self,$username,$password,$address) = @_;

	unless($self->_hasSession($username)){
		my $bad_logins = $self->pg->db->query('select count(*) from audit.auth where login_successful = false and login_identifier = ? and genesis between now()::timestamp - (interval \'10 minutes\') AND now()::timestamp',$username)->hash->{'count'};
		if($bad_logins < 3){ #we allow 3 failed login attempts per 10 minutes.  this checks for that.
			my $login_data = {
				username => $username,
				client_ip => $address
			};

			my $authed = $self->pg->db->query('select * from auth.authenticate(?,?)',$username,$password)->hash;

			if($authed->{'status'} == SUCCESSFUL_LOGIN){
				$self->{'session'} = $self->_createSession($username,$address);
				$login_data->{'status'} = SUCCESSFUL_LOGIN;
				return {session => $self->{'session'}, status => SUCCESSFUL_LOGIN};
			} else {
				#failed login, now we need to know why
				my $ghost = $self->pg->db->query('select * from auth.does_user_exist(?)',$username)->hash->{'user_exists'};
				if($ghost){
					#maybe expired password, but we don't do that yet, so future?
					#maybe bad password, yeah yeah, bad password we'll say that for now
					return {session => undef, status => BAD_PASSWORD};
				} else {
					return {session => undef, status => BAD_USERNAME};
				}
				$login_data->{'status'} = 0;
			}
		} else {
			return {session => undef, status => ACCOUNT_LOCKED};
		}
	} else {
		return {session => $self->retrieveSession($username), status => ALREADY_AUTHED};
	}
}