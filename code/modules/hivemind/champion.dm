////////////////////////////////////////////////////////////////////////////
//////////////////////////////////CHAMPIONS/////////////////////////////////
//////////////////////////Hivemind's will made manifest/////////////////////
/////These mobs are meant to be powerful, this also includes the tyrant////
////////////////////////////////////////////////////////////////////////////

//parent of the new mobs
/mob/living/simple_animal/hostile/hivemind/champion
	name = "Hivemind Champion"
	desc = "A champion of the hivemind, bring in the big guns. You shouldn't be seeing this one however."
	icon = 'icons/mob/hivemind_champion.dmi'
	icon_state = "champion"

	health = 750
	maxHealth = 750
	resistance = RESISTANCE_ARMOURED

	melee_damage_lower = 20
	melee_damage_upper = 25
	attacktext = "acts like an arsehole"
	ability_cooldown = 30 SECONDS

	speak_chance = 10
	malfunction_chance = 0
	spawn_blacklisted = TRUE
	mob_size = MOB_HUGE
	move_to_delay = 8

/mob/living/simple_animal/hostile/hivemind/champion/proc/delhivetech()
	var/otherchamp = 0
	for(var/mob/living/simple_animal/hostile/hivemind/champion/pogchamp in world)
		if(pogchamp != src)
			otherchamp = 1
	if(otherchamp == 0)
		for(var/obj/machinery/hivemind_machine/NODE in world)
			NODE.destruct()

/mob/living/simple_animal/hostile/hivemind/champion/death()
	..()
	delhivetech()
	gibs(loc, null, /obj/effect/gibspawner/robot)
	qdel(src)

/////////////////////////////////////NOBLE///////////////////////////////////
//Basically a kraftwerk on steroids
//////////////////////////////////////////////////////////////////////////////
/mob/living/simple_animal/hostile/hivemind/champion/noble
	name = "Officer"
	desc = "A highly upgraded himan surrounded by a swarm of nanites."
	icon_state = "noble"
	health = 750
	maxHealth = 750
	resistance = RESISTANCE_ARMOURED
	melee_damage_lower = 15
	melee_damage_upper = 20
	attacktext = "stabbed"
	ability_cooldown = 1 MINUTES
	var/list/court = list()
	speak = list(
				"I should get myself a court jester! That would lighten the mood.",
				"I hope there's a good artisan on this vessel."
				)
	target_speak = list(
				"Called upon by the lord to sort out these plebeians? How dissapointing.",
				"Damnable peasant, get out of my sight!",
				"You disgust me! Get out of my sight!",
				"How about becoming a serf underneath my rule?"
				)

/mob/living/simple_animal/hostile/hivemind/champion/noble/Life()
	. = ..()
	//spawn servant
	ability_cooldown = new ability_cooldown()
	if(target_mob && world.time > special_ability_cooldown)
		special_ability()


/mob/living/simple_animal/hostile/hivemind/champion/noble/special_ability()
	court.Add(new /mob/living/simple_animal/hostile/hivemind/servant(get_turf(src), src))
	visible_emote("releases a pulse of energy, causing the swarm of nanites surrounding it to take form!")
	var/msg = pick("Come join the party my servants!", "Look what joining my court has to offer!", "Servants! To arms!")
	say(msg)
	special_ability_cooldown = world.time + ability_cooldown

/mob/living/simple_animal/hostile/hivemind/champion/noble/death()
	..()
	for(var/mob/living/simple_animal/hostile/hivemind/servant/GREATLEADERISDEAD in court)
		court.Remove(GREATLEADERISDEAD)
		new /mob/living/simple_animal/hostile/hivemind/maddenedservant(get_turf(src), src)
	delhivetech()
	gibs(loc, null, /obj/effect/gibspawner/robot)
	qdel(src)

////Noble's servant
/mob/living/simple_animal/hostile/hivemind/servant
	name = "Servant"
	desc = "A modified swarm of nanites that have taken control of a body."
	icon = 'icons/mob/hivemind_champion.dmi'
	icon_state = "servant"
	health = 150
	maxHealth = 150
	resistance = RESISTANCE_FRAGILE
	speak_chance = 0
	melee_damage_lower = 15
	melee_damage_upper = 20
	attacktext = "slashed"
	var/mob/living/simple_animal/hostile/hivemind/servant/gachislave


/mob/living/simple_animal/hostile/hivemind/servant/Life()
	var/greatleader = /mob/living/simple_animal/hostile/hivemind/champion/noble
	var/greatleader_location = locate(greatleader)
	Move(greatleader_location, 0)

/mob/living/simple_animal/hostile/hivemind/maddenedservant
	var/mob/living/simple_animal/hostile/hivemind/servant/mad
	New()
		. = ..()
		name = "Maddened Servant"
		desc = mad.desc + " This one has become even more dangerous after the death of its leader."
		icon = 'icons/mob/hivemind_champion.dmi'
		icon_state = "madservant"
		health = mad.health * 2 
		maxHealth = mad.maxHealth * 2
		resistance = mad.resistance * 2
		melee_damage_lower = mad.melee_damage_lower * 2
		melee_damage_upper = mad.melee_damage_upper * 1.5
		speak_chance = 0
		attacktext = "slashed"
		for (var/obj/structure/burrow/B in find_nearby_burrows())
			B.evacuate()

/mob/living/simple_animal/hostile/hivemind/servant/death()
	..()
	visible_emote("disperses into the air as the nanites fail to maintain cohesion!")
	qdel(src)

/mob/living/simple_animal/hostile/hivemind/maddenedservant/death()
	..()
	visible_emote("disperses into the air as the nanites fail to maintain cohesion!")
	qdel(src)
/////////////////////////////////////GLADIATOR///////////////////////////////////
//the tank of the party, meant to take punishing damage and give it back
//////////////////////////////////////////////////////////////////////////////
/mob/living/simple_animal/hostile/hivemind/champion/gladiator
	name = "Gladiator"
	desc = "A hulking mass of bulging muscles and overengineered machine."
	icon_state = "gladiator"
	health = 950
	maxHealth = 950
	resistance = RESISTANCE_ARMOURED
	melee_damage_lower = 20
	melee_damage_upper = 25
	attacktext = "slashed"

	speak = list(
				"There's blood to be spilled, let us fight already.",
				"I sense warriors on this vessel, good."
				)
	target_speak = list(
				"Let us fight to the death!",
				"A fighter! Good! Let us battle!",
				"For the glory of the hive!",
				"Unsheathe your blade! We shall duel."
				)

/mob/living/simple_animal/hostile/hivemind/champion/noble/Life()
	. = ..()
	//Berserk, no weeb references except this one
	var/special_spent = FALSE
	if(target_mob && world.time > special_ability_cooldown && health < maxHealth * 0.2)
		if(!special_spent)
			special_ability()
			special_spent = TRUE
		else
			return

var/mob/living/simple_animal/hostile/hivemind/champion/gladiator

/mob/living/simple_animal/hostile/hivemind/champion/gladiator/special_ability()
	melee_damage_lower = 30
	melee_damage_upper = 35
	resistance = RESISTANCE_HEAVILY_ARMOURED
	adjustBruteLoss((maxHealth-health) * 0.8)
	desc = gladiator.desc + " It also appears to have gone into an overdrive mode, its flesh is pulsating and the machinery is glowing red hot!"
	name = "Berserk " + gladiator.name
	visible_message(SPAN_DANGER("<b>[name]</b> releases a roar, its body suddenly reassembling itself!"))
	speak = list(
		"KILL! MAIM! BURN!",
		"RIP AND TEAR!"
	)
	target_speak = list(
		"YOU'VE GOT GUTS!!",
		"BLOOD! MORE BLOOD!!",
		"THE HIVE DEMANDS YOUR CORPSE!!",
		"YOUR SKULL SHALL DO!!"
	)


/////////////////////////////////////SORCERER///////////////////////////////////
//Ranged mob with a variety of tricks and abilities
//////////////////////////////////////////////////////////////////////////////
/mob/living/simple_animal/hostile/hivemind/champion/sorcerer
	name = "Sorcerer"
	desc = "A champion of the hivemind, bring in the big guns."
	icon_state = "sorcerer"
	health = 700
	maxHealth = 700
	resistance = RESISTANCE_TOUGH
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = "scratched"
	ability_cooldown = 30 SECONDS
	