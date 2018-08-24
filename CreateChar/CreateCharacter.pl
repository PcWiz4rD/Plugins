
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


my @Patente = qw (Sd Cb Sgt St Ten Cap Maj Cel); # coloque aqui primeira parte do nome
my @Numero = qw(1 2 3 4 5 6 7 8 9); #coloque aqui segunda parte do nome

my @nomes = ReadNames(); #Nomes.txt
			

my $betterslot;
my $finalname;
my $status = 1;
my $char = $config{char};

			

	
	

	sub selectChar{
	
		
		$messageSender->sendCharLogin($betterslot);
        $timeout{'charlogin'}{'time'} = time;
        configModify("char", $betterslot);
		$status = 0;
	}
	
	
	sub create{
		
	my ($self, $args) = @_;
		
	
	$betterslot = selectBestslot();
	$finalname = lettersGroups();
	
	if($status == 1 && $config{char} eq "" ){
	warning "$config{char} \n";
	warning "Criando char $finalname Melhor slot $betterslot \n";
	$messageSender->sendCharCreate($betterslot,$finalname, 9, 9, 1, 9, 1, 1, 0, 0); 
	$args->{return} = 2;
	}
	$args->{return} = 2 if($status == 0);

	
	
	
	
	
	
		}
	
	
	
	sub selectBestslot {	
	
	my $slot;	
	for (my $i = 0; $i < scalar @chars; $i++){		
		if(!@chars[$i]&& !$slot){
			$slot = $i;	}
												}
												
	return $slot ? $slot : (scalar @chars == 0) ? 0 : scalar @chars;
	}
	
		
		
		
	sub createFailed {
	
	$status = 1;
	
	}
		
	sub lettersGroups {
	
	my $name = @Patente[int(rand(scalar @Patente))];
	$name .= " ";
	$name .= @nomes[int(rand(scalar @nomes))];	
	for(my $i = 0; $i < int(rand(3)+1); $i++) {
		my $random_number = int(rand(scalar @Numero));
		$name .= @Numero[$random_number];
								  }
	return $name;
	}
			

			
	sub ReadNames {
	my @name_list;
	open (NOMES, "<Nomes.txt") or die "Error: file cannot be found: ips.txt\n";
	my $canread;
	my $i = 0;

	while (<NOMES>) {
		chomp;
		
		$_ =~ s/\r?\n|\r//g; # remove linebreak

		if ($_ =~ /\[Nomes\]/) {
			$canread = 1;
		} elsif ($canread) {
			push (@name_list, $_);
		}
		
	}
	close NOMES;
	return @name_list;
}


			
			

1;
