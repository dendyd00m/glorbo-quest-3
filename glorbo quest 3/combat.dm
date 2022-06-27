stat

proc
	WeaponAttack(health,weapondamage,armour)
		var
			real_damage
		real_damage = roll(1,weapondamage) - armour
		if(real_damage > 0)
			health = health - real_damage
		return health
	DeathCheck(mob/target)
		var
			obj
				carried_item
		if(target.health <= 0)
			view() << "[target] has died."
			target.weapondamage = initial(target.weapondamage)
			target.currentweapon = initial(target.currentweapon)
			target.attackmode = initial(target.attackmode)
			target.equip = initial(target.equip)
			target.wielded = initial(target.wielded)
			target.armour = initial(target.armour)
			for(carried_item in target.contents)
				view() << "[carried_item] worth [carried_item.value] Glorbcoins falls to the ground."
				carried_item.Move(target.loc)
			target.loc = locate(/turf/floor/start)
			target.health = target.maxhealth

obj/gettable/melee_weapon
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

obj/gettable/armour
	var
		stat
			is_equipped = 0
			armour = 0
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
