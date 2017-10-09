____      _       ___                  ____ 
#   / __ \____| |     / (_)___  ____ ______/ __ \
#  / /_/ / ___/ | /| / / /_  / / __ `/ ___/ / / /
# / ____/ /__ | |/ |/ / / / /_/ /_/ / /  / /_/ / 
#/_/    \___/ |__/|__/_/ /___/\__,_/_/  /_____/  
#
#Você é livre para usar, a não ser que seja o OSCAR
#

use strict;
use warnings;
use utf8;
use Log qw(message warning);
use File::Fetch;
use File::Copy;
use LWP::Simple;

Plugins::register("AutoUpDate", "Automatizar atualização", \&unload);

my $hooks = Plugins::addHooks(
["start2", \&update]
); 

sub unload {
	Plugins::delHooks($hooks);
}	



my %links = (
             './tables/bRO/recvpackets.txt' => 'https://raw.githubusercontent.com/OpenKore/openkore/master/tables/bRO/recvpackets.txt',
					   './tables/bRO/shuffle.txt' => 'https://raw.githubusercontent.com/OpenKore/openkore/master/tables/bRO/shuffle.txt',					   
					   './tables/bRO/sync.txt' => 'https://raw.githubusercontent.com/OpenKore/openkore/master/tables/bRO/sync.txt',
					   './tables/servers.txt' => 'https://raw.githubusercontent.com/OpenKore/openkore/master/tables/servers.txt',
					   './src/Network/Receive/bRO.pm' => 'https://raw.githubusercontent.com/OpenKore/openkore/master/src/Network/Receive/bRO.pm',
					   './src/Network/Send/bRO.pm' => 'https://raw.githubusercontent.com/OpenKore/openkore/master/src/Network/Send/bRO.pm',
					   
					   
);



sub update {

		for my $items (keys %links) {

	my $content = get($links{$items});
	defined $content or die "Cannot read '$links{$items}";
	open(my $rtf, '>', $items) or die "não foi possível abrir o arquivo";

	print $rtf $content;
	warning "$items Atualizado \n";
	close $rtf or die "não foi possível fechar o arquivo : $!";

									}


}



1;
