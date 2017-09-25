package Garden::Model::Time;
use Mojo::Base -base;

sub water_check{
 
 my $t = localtime;

while ($t->hour >= 11 && $t->min <= 53) {

    $t = localtime;

    say "hello!"; 
    sleep (6); 
    $t = localtime; 
    say $t = localtime;
}

sleep (6);

return menu();

};

sub list_time{

my $t = localtime; 

say $t = localtime;


print 'View More Info (Run # or M for menu):';
my $choice = <STDIN>;
	chomp($choice);
menu();


### this is where i program opening the water program. ###

}

1;