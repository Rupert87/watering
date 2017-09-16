#!/usr/bin/perl
#
# @File Water.pm
# @Author root
# @Created Sep 15, 2017 11:19:24 PM
#

package Garden::Controller::Time
use Mojo::Base 'Mojolicious::Controller';

sub water-check{
 
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