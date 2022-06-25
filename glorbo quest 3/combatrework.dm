/mob/var/stat/weapondamage = 2
/mob/var/stat/wielded = 0

/obj/gettable/melee_weapon/proc/WeaponCanDropCheck(obj/gettable/melee_weapon/item)
	if(item.is_wielded)
		usr << ("You need to unequip [item] before you can drop it!")
		return 0
	else
		return 1

/obj/gettable/melee_weapon/MouseDrop()
	if(WeaponCanDropCheck(src,usr))
		..()

/obj/gettable/melee_weapon
	var/is_wielded = 0
/obj/gettable/melee_weapon/verb/wield()
	if(!usr.wielded)
		view() << "[usr] wields [src]."
		src.suffix = "(wielded)"
		usr.weapondamage = src.weapondamage
		usr.wielded = 1
		src.is_wielded = 1
	else
		usr << "You are already wielding something!"

/obj/gettable/melee_weapon/verb/remove()
	if(src.is_wielded)
		if(usr.wielded)
			view() << "[usr] stops wielding [src]."
			src.suffix = null
			src.is_wielded = 0
			usr.wielded = 0
			usr.weapondamage = 2
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
		usr.equip = 1
	else
		usr << "You are already wearing something!"
/obj/gettable/armour/verb/remove_armour()
	if(usr.equip)
		view () << "[usr] doffs [src]."
		src.suffix = null
		usr.armour = usr.armour - armour
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
// /mob/Click()