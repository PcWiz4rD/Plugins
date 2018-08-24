#    ____      _       ___                  ____ 
#   / __ \____| |     / (_)___  ____ ______/ __ \
#  / /_/ / ___/ | /| / / /_  / / __ `/ ___/ / / /
# / ____/ /__ | |/ |/ / / / /_/ /_/ / /  / /_/ / 
#/_/    \___/ |__/|__/_/ /___/\__,_/_/  /_____/  
#
#Você é livre para usar, a não ser que seja o OSCAR
#
package Create;

use strict;
use Globals;
use utf8;
use Log qw(message warning);
use Settings;
use Misc;
use Utils;
use Plugins;

Plugins::register("createCharacter", "Criar personagens automaticamente", \&unload);

my $hooks = Plugins::addHooks( 
	['charSelectScreen', \&create],
	['packet_pre/character_creation_successful', \&selectChar],
	['packet_pre/character_creation_failed', \&createFailed],
);

sub unload {
   Plugins::delHooks($hooks);
   undef $hooks;   
}

my @patente = qw(Sd Cb Sgt St Ten Cap Maj Cel); # coloque aqui primeira parte do nome
my @numero = qw(1 2 3 4 5 6 7 8 9); #coloque aqui segunda parte do nome
my @nomes = readNames(); #Nomes.txt

my $betterSlot;
my $finalName;
my $status = 1;
my $char = $config{char};

sub selectChar {
	$messageSender->sendCharLogin($betterSlot);
	$timeout{'charlogin'}{'time'} = time;
	configModify("char", $betterSlot);
	$status = 0;
}

sub create {
	my ($self, $args) = @_;

	$betterSlot = selectBestSlot();
	$finalName = lettersGroups();

	if ($status == 1 && $config{char} eq "" ) {
		warning "Criando char $finalName Melhor slot $betterSlot \n";
		$messageSender->sendCharCreate($betterSlot, $finalName, 9, 9, 1, 9, 1, 1, 0, 0); 
		$args->{return} = 2;
	}
	
	$args->{return} = 2 if ($status == 0);
}

sub selectBestSlot {
	my $slot;
	
	for (my $i = 0; $i < scalar @chars; $i++){
		if (!$chars[$i] && !$slot){
			$slot = $i;
		}
	}

	return $slot ? $slot : (scalar @chars == 0) ? 0 : scalar @chars;
}

sub createFailed {
	$status = 1;
}

sub lettersGroups {
	my $name = $patente[int(rand(scalar @patente))];
	$name .= " ";
	$name .= $nomes[int(rand(scalar @nomes))];
	
	for (my $i = 0; $i < int(rand(3)+1); $i++) {
		my $randomNumber = int(rand(scalar @numero));
		$name .= $numero[$randomNumber];
	}
	
	return $name;
}

sub readNames {
	my @nameList;
	
	open (NOMES, "<Nomes.txt") or die "Error: file cannot be found: nomes.txt\n";
	
	my $canRead;
	my $i = 0;

	while (<NOMES>) {
		chomp;
		
		$_ =~ s/\r?\n|\r//g; # remove linebreak

		if ($_ =~ /\[Nomes\]/) {
			$canRead = 1;
		} elsif ($canRead) {
			push (@nameList, $_);
		}
	}
	
	close NOMES;
	return @nameList;
}

1;
