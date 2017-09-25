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
    
	my ($self,$firstname,$lastname,$password,$username,$activate,$login_identifier) = @_;
        
	my $rs = $self->pg->db->query('set search_path to watering,auth','select * from auth.users(?,?,?,?,?)','insert into auth.users',$firstname,$lastname,$password,$username,$login_identifier)->hash;
        
        
        #my $rp = $self->pg->query('select * from watering.users(?,?,?,?)',$firstname,$lastname,$password,$username)->hash;

	if($rs->{'status'} == SUCCESS){
            
		
                my $result = $self->redirect_to('water');
            
           }
       
        
        }
         
1;