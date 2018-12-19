package Garden::Controller::Time;
use Mojo::Base 'Mojolicious::Controller';

use Mojo::Transaction::WebSocket;
 sub connected{
     my $hostname = '10.3.1.104';
     my $username = 'root';
     my $password = 'Hard01Can!!';
     my $cmd = 'python /home/dht/Adafruit_Python_DHT/examples/AdafruitDHT.py 11 4';
     
my $ssh = Net::SSH::Perl->new("$hostname", debug=>0);
$ssh->login("$username","$password");
my ($stdout,$stderr,$exit) = $ssh->cmd("$cmd");
print $stdout;
}



#use v5.18.2;

#NAME

  #  RPi::DHT11 - Fetch the temperature/humidity from the DHT11 hygrometer
 #   sensor on Raspberry Pi

#SYNOPSIS

    #    use RPi::DHT11;
    
   #     my $pin = 4;
    
  #      my $env = RPi::DHT11->new($pin);
    
 #       my $temp     = $env->temp;
#        my $humidity = $env->humidity;


1;