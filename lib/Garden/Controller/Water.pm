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
    my $jsonstuff = $self ->pg->db->query('select info::json from ord order BY genesis desc limit 10;')->hash->{'info'};
    $jsonstuff =~ s/\\"/"/g;
    warn $self->dumper($jsonstuff);
    $jsonstuff = Mojo::JSON->from_json($jsonstuff);
    #my $jsonstuff = $self ->pg->db->query('select info from ord order BY genesis desc limit 10;')->hash;
    #my $jsonstuff = $self ->pg->db->query('select ?::json as info', {json => {temperature => 'temp'}});
    #$self->stash( json => $jsonstuff);
    
    #$self->stash(json => $jsonstuff);

    
    #my $->stash(json => $jsonstuff);
    
    #$jsonstuff->stash(json => {info => 'temerature'});
    
    #my $json = $jsonstuff->stash;
    return $self->render(json_data => $jsonstuff);
    
    
  
    }
1;
