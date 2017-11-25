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
1;