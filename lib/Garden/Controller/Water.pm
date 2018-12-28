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
    
    $self->stash(json => $jsonstuff);

    
    #my $->stash(json => $jsonstuff);
    
    #$jsonstuff->stash(json => {info => 'temerature'});
    
    #my $json = $jsonstuff->stash;
   return $self->render(template => '/water/status', json => $jsonstuff->('fields'{'temperature'}));
    
    
    
    
  
    }
1;