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
	my ($self,$username,$password) = @_;

	my $authed = $self->pg->db->query('select * from authenticate(?,?)',$username,$password)->hash;
	return $authed;
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
sub cleanUpSessions{
	my $self = shift;
	
	my $ttl = 480;
	$ttl = $ttl . ' minutes';
	$self->pg->db->query('update auth.sessions set active = false where modified < (now() - ?::INTERVAL)',$ttl);
	
	return;
}
1;