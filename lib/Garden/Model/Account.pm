package Garden::Model::Account;
use Mojo::Base -base;



has 'pg';
has 'debug';

use constant {
	SUCCESS => 1,
	FAILED_CREATE_USER => -1,
	FAILED_PROFILE_DATA => -2,
	FAILED_DELETE_USER => -3
};

sub create{
    
	my ($self,$firstname,$lastname,$password,$username,$activate) = @_;
	
	my $rs = $self->pg->db->query('select * from auth.register(?,?,?,?)',$firstname,$lastname,$password,$username)->hash;

	if($rs->{'status'} == SUCCESS){
		#account created. set type to operator (default type)
		$self->pg->db->query("update users u set account_type = (select id from account_types where lower(name) = 'operator') where u.id = ?", $rs->{'id'});
		if($activate == 1){
			my $result = $self->pg->db->query('select * from platform.create_token(?,?)',$rs->{'id'},'activation')->hash;
			if($result->{'status'} == 1){
				$rs->{'token'} = $result->{'token'};
			}
		} else{
			my $result = $self->pg->db->query('update auth.users set active = true where id = ?',$rs->{'id'});
		}
	}

	return $rs;
}

sub delete{
	
}

sub edit{
	
}

sub set_password{
	my ($self,$user,$password) = @_;

	$self->pg->db->query("update auth.users set password = crypt(?,gen_salt('bf',8)) where id = ?",$password,$user);
	return;
}

sub full_name{
	my ($self,$user_id) = @_;

	my $name = $self->pg->db->query("select first || ' ' || last as name from users where id = ?",$user_id)->hash;
	
	return $name->{'name'};
}

sub get_id{
	my ($self,$username) = @_;
	
	my $id = $self->pg->db->query('select id from auth.users where login_identifier = ?',$username)->hash;
	
	return $id->{'id'};
}
1;
