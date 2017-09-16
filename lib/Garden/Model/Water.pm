
package Garden::Controller::Time
use Mojo::Base 'Mojolicious::Controller';

use v5.18.2;
use Time::Piece qw(localtime);
use Win32;
use Win32::Daemon;
use warnings;
sub start-water{

my $Context = "{last_state} = SERVICE_RUNNING;"
Device::BCM2835::gpio_fsel(&Device::BCM2835::RPI_GPIO_P1_3, 
                            &Device::BCM2835::BCM2835_GPIO_FSEL_OUTP);
							
$Context->{last_state} = SERVICE_RUNNING;
Win32::Daemon::StartService();
Win32::Daemon::State( SERVICE_RUNNING );

}