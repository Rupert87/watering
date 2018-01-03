package Garden::Model::Auth;
use Mojo::Base -base;

has 'pg';
has 'debug';

use constant {
	ALREADY_AUTHED => 2,
	SUCCESSFUL_LOGIN => 1,
	BAD_USERNAME => -1,
	BAD_PASSWORD => -2,
	EXPIRED_PASSWORD => -3,
	ACCOUNT_LOCKED => -4
};

#check to see if the correct username and password have been given
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

#used to check if a username has a session. meant to be used internally to this module in case the module needs to verify sessions in a different way than the controller
sub _hasSession{ 
	my ($self,$username) = @_;
	
	$self->cleanUpSessions;
	return $self->pg->db->query('select count(*) from auth.sessions where login_identifier = ? and active = true',$username)->hash->{'count'};
}

sub cleanUpSessions{
	my $self = shift;
	
	my $ttl = 480;
	$ttl = $ttl . ' minutes';
	$self->pg->db->query('update auth.sessions set active = false where modified < (now() - ?::INTERVAL)',$ttl);
	
	return;
}

sub verifySession{
	my ($self,$session_id) = @_;
	
	#TODO expire sessions at some point
	#doing the following in steps to prevent an error with undefined hash ref being passed into ->hash
	$self->cleanUpSessions; #might be a good idea to invalidate sessions here before we check for a valid one.
	my $rs = $self->pg->db->query('select active from auth.sessions where id = ?::uuid',$session_id);
	if($rs->rows > 0){
		return $rs->hash->{'active'};
	} else {
		return 0;
	}
}

sub _createSession{
	my ($self,$username,$ip) = @_;  #eventually as this thing grows up we'll cache more things in the session

	my $id = $self->pg->db->query('insert into auth.sessions (user_id,login_identifier,ip) values ((select id from auth.users where login_identifier = ?),?,?) returning id',$username,$username,$ip)->hash;
	
	if(defined($id->{'id'})){ #making sure we actually were able to create the session and return the id
		my $account_info = $self->pg->db->query('select u.id,name as account_type from auth.users u join auth.account_types a on u.account_type = a.id where login_identifier = ?',$username)->hash;
		my $session = {
			id => $id->{'id'},
			user_id => $account_info->{'id'},
			status => 1,
			account_type => $account_info->{'account_type'},
			username => $username
		};
		
		return $session;	
	} else {
		return undef;
	}
	
}

sub retrieveSession{
	my ($self,$username) = @_;
	
	my $session_from_db = $self->pg->db->query('select * from auth.sessions where login_identifier = ? order by modified desc limit 1',$username)->hash;
	my $account_type = $self->pg->db->query('select at.name from auth.users u join auth.account_types at on u.account_type = at.id where u.login_identifier = ?',$username)->hash;
	my $session = {
		id => $session_from_db->{'id'},
		user_id => $session_from_db->{'user_id'},
		status => 1,
		username => $username,
		account_type => $account_type->{'name'}
	};
	
	return $session;
}

1;