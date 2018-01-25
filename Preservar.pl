
#    ____      _       ___                  ____ 
#   / __ \____| |     / (_)___  ____ ______/ __ \
#  / /_/ / ___/ | /| / / /_  / / __ `/ ___/ / / /
# / ____/ /__ | |/ |/ / / / /_/ /_/ / /  / /_/ / 
#/_/    \___/ |__/|__/_/ /___/\__,_/_/  /_____/  
#
#Você é livre para usar, a não ser que seja o OSCAR
#

#Preserve_active #active plugin
#Tele_preserve   #active Teleport on AI:: Attack
#Preserve_skill  #handle Skill
#Intervalo_skill #interval between use PRESERVE

#exemple

#Preserve_active 1
#Tele_preserve 1
#Preserve_skill MO_TRIPLEATTACK
#Intervalo_skill 450

package Preservar;

use Plugins;
use Globals;
use Log qw(message warning error debug);
use Time::HiRes qw(time);
use AI;
use Misc;
use Network;
use Network::Send;
use Utils;
use Commands;
use Actor;



Plugins::register('Preservar', 'esta comigo esta com Deus', \&on_unload);
my $hooks = Plugins::addHooks(
	['AI_pre',\&checkPreserve, undef],
	['Actor::setStatus::change',\&ChangeStatus, undef],
	#['in_game',\&_onGame]
);

my $Skilluse = time;
my $delaySkillUse = time;
my $timetoTele = time;

sub on_unload {
	Plugins::delHooks($hooks);
}

sub ChangeStatus {
	my (undef, $args) = @_;
	if ($args->{handle} eq 'EFST_PRESERVE' && $args->{actor_type}->isa('Actor::You') && $args->{flag} == 1) {
	$Skilluse = time;
	
	}
}


sub checkPreserve {
	return if (!$char || !$net || $net->getState() != Network::IN_GAME || !$config{Preserve_active});
	return if ($char->{muted});
	return if ($char->{casting});
	
	
	my $skill = new Skill(idn => 'ST_PRESERVE');
	if (!$skill->getIDN()) {
	message "você não possui a habilidade Preservar \n","system";
	&unload();}
		elsif ($config{Preserve_active}){
			if (!$char->getSkillLevel(new Skill(handle => $config{Preserve_skill}))) {
			message "você não possui habilidade: ".$config{Preserve_skill}."\n","system";
			configModify("Preserve_active", 0);	return;	} }	
				if(!$char->statusActive('EFST_PRESERVE')){
				useSkill('Status Inactive');}
					elsif($char->statusActive('EFST_PRESERVE') && timeOut($config{Intervalo_skill}, $Skilluse)){
					useSkill('intervalo_skill'); }
				}
				
	
	sub useSkill {
	my ($reason) = @_;
	
	if (checkAI() && timeOut($timetoTele, 0.7) && $config{Tele_preserve}){	
		Misc::useTeleport(1);	
		$timetoTele = time;	return;}
		if(timeOut($delaySkillUse, 2)){
			warning "========Preservar======== \n";
			warning "motivo: ". $reason."\n" if defined($reason);
			$::messageSender->sendSkillUse(475, 1, $::accountID);
			#$Skilluse = time;
			$delaySkillUse = time;	}
		}
	
	
	
	sub checkAI {
		foreach (@::ai_seq)	{
			if ($_ eq "attack") { #implementar mais coisas
				
				return 1;
			}
		}
		return 0;
	}



return 1;
