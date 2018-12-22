package Garden::Controller::Water;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw(decode_json encode_json);

sub connected{

#my $jsonstuff = $self->req->params->to_hash

}

sub water{
    
    my $self = shift;
    
    my $rs = $self->pg->db->query('select data from tax');
    
   
    }
sub status{
    
    
    my $self = shift;
    
    my $jsonstuff = $self ->pg->db->query('select data from tp')->hash;
    
    my $jsonstash = $wheeps->stash($jsonstufs);
    
    return $jsonstash->render(template => '/water/status', json = $jsonstash);
    
    return $self->render(template => '/water/status', json => $jsonstuff);
    
    
  
    }
1;