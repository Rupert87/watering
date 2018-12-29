package Garden::Controller::Menu;
use Mojo::Base 'Mojolicious::Controller';
use RPi::DHT11;
    
        



sub gun{
    
    
    my $pin = 14;
    
        my $env = RPi::DHT11->new($pin);
    
        my $temp     = $env->temp;
        my $humidity = $env->humidity;
        
        return $temp;
    
    
    }
    
    1;