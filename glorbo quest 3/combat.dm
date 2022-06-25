stat

proc
	WeaponAttack(health,weapondamage,armour)
		var
			real_damage
		real_damage = weapondamage - armour
		health = health - real_damage
		return health
	DeathCheck(mob/target)
		var
			obj
				carried_item
		if(target.health <= 0)
			view() << "[target] has died."
			for(carried_item in target.contents)
				view() << "[carried_item] worth [carried_item.value] Glorbcoins falls to the ground."
				carried_item.loc = target.loc
			target.loc = locate(/turf/floor/start)
			target.health = target.maxhealth

obj
	melee_weapon
		var
			stat
				weapondamage = 5
			realdamage = 0
		verb
			strike(mob/target in view(1))
				realdamage = WeaponAttack(target.health,weapondamage,target.armour)
				target.health = realdamage
				if(realdamage > 0)
					view() << "[src.loc] strikes [target] with [src] for [weapondamage - target.armour] damage!"
				else
					view() << "[src.loc] tries to strike [target] with [src], but [src.loc] is unharmed!"
				DeathCheck(target)
		sword
			icon = 'sword.dmi'
			weapondamage = 10
	armour
		var
			stat
				armour = 0
		verb
			equip_armour()
				if(!usr.equip)
					view() << "[usr] dons [src]."
					usr.armour = usr.armour + armour
					usr.equip = 1
				else
					usr << "You are already wearing something!"
			remove_armour()
				if(usr.equip)
					view () << "[usr] doffs [src]."
					usr.armour = usr.armour - armour
					usr.equip = 0
				else
					usr << "You aren't wearing anything!"
		chainmail
			armour = 3
			icon = 'chainmail.dmi'

mob
	var
		stat
			health = 100
			maxhealth = 100
			magic = 50
			maxmagic = 50
			armour = 0
			equip = 0

	Stat()
		if(statpanel("Stats"))
			stat("Health", "[health]/[maxhealth]")
			stat("Magic", "[magic]/[maxmagic]")
			stat("Current Armour", "[armour]")
			stat("Wallet", "[wallet]")