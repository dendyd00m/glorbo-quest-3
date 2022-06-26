#define DAM_TYPE_BLUNT "bashes"
#define DAM_TYPE_SLASHING "slashes"

/mob/var/stat/weapondamage = 2
/mob/var/wielded = 0
/mob/var/attackmode = 0
/mob/var/currentweapon = "fists"
/mob/var/currentdamagetype = DAM_TYPE_BLUNT

/obj/gettable/melee_weapon/sword
	damagetype = DAM_TYPE_SLASHING

/obj/gettable/melee_weapon/proc/WeaponCanDropCheck(obj/gettable/melee_weapon/item)
	if(item.is_wielded)
		usr << ("You need to unequip [item] before you can drop it!")
		return 0
	else
		return 1

/obj/gettable/armour/proc/ArmourCanDropCheck(obj/gettable/armour/item)
	if(item.is_equipped)
		usr << ("You need to unequip [item] before you can drop it!")
		return 0
	else
		return  1

/obj/gettable/melee_weapon/MouseDrop()
	if(WeaponCanDropCheck(src,usr))
		..()

/obj/gettable/armour/MouseDrop()
	if(ArmourCanDropCheck(src))
		..()

/obj/gettable/melee_weapon/Move()
	if(src.is_wielded)
		src.is_wielded = initial(src.is_wielded)
		src.suffix = initial(src.suffix)
		..()
	else
		..()

/obj/gettable/armour/Move()
	if(src.is_equipped)
		src.is_equipped = initial(src.is_equipped)
		src.suffix = initial(src.is_equipped)
		..()
	else
		..()

/obj/gettable/melee_weapon
	var/is_wielded = 0
	var/damagetype = DAM_TYPE_BLUNT

/obj/gettable/melee_weapon/verb/wield()
	if(!usr.wielded)
		view() << "[usr] wields [src]."
		src.suffix = "(wielded)"
		usr.weapondamage = src.weapondamage
		usr.wielded = 1
		src.is_wielded = 1
		usr.currentweapon = src.name
		usr.currentdamagetype = src.damagetype
	else
		usr << "You are already wielding something!"

/obj/gettable/melee_weapon/verb/remove()
	if(src.is_wielded)
		if(usr.wielded)
			view() << "[usr] stops wielding [src]."
			src.suffix = null
			src.is_wielded = 0
			usr.wielded = 0
			usr.weapondamage = initial(usr.weapondamage)
			usr.currentweapon = initial(usr.currentweapon)
			usr.currentdamagetype = initial(usr.currentdamagetype)
	else
		usr << "You aren't wielding [src]!"	

/obj/gettable/melee_weapon/Click()
	if(src.loc == usr)
		if(!src.is_wielded)
			wield()
		else
			remove()
	else
		..()

/obj/gettable/armour/verb/equip_armour()
	if(!usr.equip)
		view() << "[usr] dons [src]."
		src.suffix = "(worn)"
		usr.armour = usr.armour + armour
		src.is_equipped = 1
		usr.equip = 1
	else
		usr << "You are already wearing something!"

/obj/gettable/armour/verb/remove_armour()
	if(usr.equip)
		view () << "[usr] doffs [src]."
		src.suffix = null
		usr.armour = usr.armour - armour
		src.is_equipped = 0
		usr.equip = 0
	else
		usr << "You aren't wearing anything!"

/obj/gettable/armour/Click()
	if(src.loc == usr)
		if(!usr.equip)
			equip_armour()
		else
			remove_armour()
	else
		..()

/mob/verb/attack_mode()
	if(!usr.attackmode)
		usr << "You will now attack upon clicking other people."
		usr.attackmode = 1
	else
		usr << "You will no longer attack when clicking other people."
		usr.attackmode = 0

/mob/proc/AttackModeCheck(mob/target)
	if(target.attackmode)
		return 1
	else
		return 0

/mob/Click()
	if(AttackModeCheck(usr))
		src.health = WeaponAttack(src.health,usr.weapondamage,src.armour)
		view() << "[usr] [usr.currentdamagetype] [src] with their [usr.currentweapon]!"
		DeathCheck(src)
	else if(src == usr)
		view() << "[usr] pats themselves on the back."
	else
		view() << "[usr] pats [src] on the head."