package Garden::Controller::Water;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw(to_json);

sub connected{

#my $jsonstuff = $self->req->params->to_hash

}

sub water{
    
    my $self = shift;
    
    my $rs = $self->pg->db->query('select data from tax');
    
   
    }
sub status{
    
    
    my $self = shift;
    
    my $jsonstuff = $self ->pg->db->query('select info from ord order BY id desc limit 1;')->hash;
    #my $jsonstuff = $self ->pg->db->query('select ?::json as info', {json => {temperature => 'temp'}});
    #$self->stash( json => $jsonstuff);
    
    #$self->stash(json => $jsonstuff);

    
    #my $->stash(json => $jsonstuff);
    
    #$jsonstuff->stash(json => {info => 'temerature'});
    
    #my $json = $jsonstuff->stash;
    return $self->render(template => 'water/status', json_data => $jsonstuff);
    
    
  
    }
1;