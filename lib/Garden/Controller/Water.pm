package Garden::Controller::Water;
use Mojo::Base 'Mojolicious::Controller';

sub connected{

#my $jsonstuff = $self->req->params->to_hash

}

sub water{
    
    my $self = shift;
    
    my $rs = $self->pg->db->query('select data from tax';);
    
    
    
    }
1;