
#!/usr/local/bin/perl
use v5.18.2;
use Time::Piece qw(localtime);
#use Win32;
#use Win32::Daemon;
use warnings;
#my $Context = "{last_state} = SERVICE_RUNNING;"
#Device::BCM2835::gpio_fsel(&Device::BCM2835::RPI_GPIO_P1_3, 
                            #&Device::BCM2835::BCM2835_GPIO_FSEL_OUTP);
							
#$Context->{last_state} = SERVICE_RUNNING;
#Win32::Daemon::StartService();
#Win32::Daemon::State( SERVICE_RUNNING );

###globals###
#my $t = localtime;

my $user_input = menu();
dispatcher($user_input);

#use feature qw(say);

my $t = localtime;

 

 sub menu{
 
 say 'Menu';
 
 say '(S)hedule time to start water';
 
 say '(r)listtime';
 
 print 'Choice: ';
 my $user_input= <STDIN>;
 chomp($user_input);
 return ($user_input);
 
 }

sub dispatcher{
	my $what_to_do = shift;
	
	given(lc($what_to_do)){
		when ('o') {
			one_time();
		}
		when ('r'){
			list_time();
		}
		when ('p'){
			push_follow_up_boss();
		}
		when ('q'){
			exit;
		}
		when ('s'){
            one_time();
        }
        
        default {
			say "You didn't pick something I understand, try again. (Press enter to continue)";
			<STDIN>; #pausing for the user to press enter
			menu();
		}
	}
	
}


 
 sub one_time{
 
 $t = localtime;

while ($t->hour >= 11 && $t->min <= 53) {

$t = localtime;

say 'hello!'; sleep (6); $t = localtime; say $t = localtime;
}

sleep (6);

return menu();

sub list_time{

say $t = localtime;

}

sub list_time{

say $t = localtime;


print 'View More Info (Run # or M for menu):';
my $choice = <STDIN>;
	chomp($choice);
menu();
}

### this is where i program opening the water program. ###

}

1;

