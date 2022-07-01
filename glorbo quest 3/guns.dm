sound/environment = 22
mob/var/is_aiming = 0

obj/gettable/guns
	var/ammo_count = 0
	var/ammo_maximum = 5
	var/damage = 5
	var/accepted_ammo_type = /obj/gettable/stackable/ammunition/musket_rounds
	verb/reload()
		var/list/reloadables = list()
		var/obj/gettable/stackable/ammunition/ammo
		for(ammo in view(1))
			reloadables += ammo
		var/chosen_ammo = input("Choose an ammo to reload [src]", "reload [src]") as null|obj in reloadables
		if(!chosen_ammo)
			usr << "You try to reload [src], but you have no ammo."
			return
		Reload(chosen_ammo)

obj/gettable/guns/proc/Reload(obj/gettable/stackable/ammunition/ammo)
	var/ammo_fill_amount = ammo_maximum - ammo_count
	if(ammo.ammo_type == accepted_ammo_type)
		if(ammo_count < ammo_maximum)
			if(ammo.amount >= ammo_fill_amount)
				ammo_count += ammo_fill_amount
				ammo.amount -= ammo_fill_amount
				view() << "[usr] loads [ammo.name] into [src]."
				ammo.name = initial(ammo.name)
				ammo.name = "[ammo.name] x[ammo.amount]"
				ammo.StackZeroCheck(ammo)
			else if(ammo.amount < ammo_fill_amount)
				ammo_fill_amount = ammo.amount
				ammo_count += ammo_fill_amount
				ammo.amount -= ammo_fill_amount
				view() << "[usr] loads [ammo.name] into [src]."
				ammo.name = initial(ammo.name)
				ammo.name = "[ammo.name] x[ammo.amount]"
				ammo.StackZeroCheck(ammo)
		else
			usr << "[src] is already fully loaded!"
	else
		usr << "[ammo] doen't fit into [src]!"

obj/gettable/guns/verb/unload()
	if(ammo_count)
		view() << "[usr] unloads [src]."
		new accepted_ammo_type(src.loc,ammo_count)
		ammo_count = 0
	else
		usr << "[src] is already empty!"

obj/gettable/stackable/ammunition
	var/ammo_type
	desc = "Some ammunition."

obj/gettable/stackable/ammunition/musket_rounds
	ammo_type = /obj/gettable/stackable/ammunition/musket_rounds
	icon = 'musket_rounds.dmi'
	amount = 3

obj/gettable/stackable/ammunition/crossbow_bolts
	ammo_type = /obj/gettable/stackable/ammunition/crossbow_bolts
	icon = 'crossbow_bolts.dmi'
	amount = 1


obj/gettable/guns/flintlock
	accepted_ammo_type = /obj/gettable/stackable/ammunition/musket_rounds
	damage = 20
	icon = 'flintlock.dmi'
	desc = "A flintlock pistol."

obj/gettable/guns/examine()
	. = ..()
	if(!src.ammo_count)
		usr << "[src] is unloaded!"
	else
		usr << "[src] has [src.ammo_count]/[src.ammo_maximum] shots left."

obj/gettable/stackable/ammunition/examine()
	. = ..()
	usr << "There's [src.amount] left."

obj/gettable/guns/var/aimed = 0

obj/gettable/guns/verb/start_aiming()
	if(!usr.wielded)
		view() << "[usr] starts aiming [src]."
		usr.equipped_gun = src
		usr.is_aiming = 1
		src.suffix = "(aiming)"
		usr.wielded = 1
		src.aimed = 1
		usr.currentweapon = "aiming [src]"
	else
		usr << "You are already wielding something!"

obj/gettable/guns/verb/stop_aiming()
	if(src.aimed)
		if(usr.wielded)
			view() << "[usr] stops aiming [src]"
			usr.equipped_gun = initial(usr.equipped_gun)
			usr.is_aiming = 0
			src.suffix = null
			src.aimed = 0
			usr.wielded = 0
			usr.currentweapon = initial(usr.currentweapon)
		else
			usr << "You aren't aiming [src]!"

obj/gettable/guns/Click()
	if(src.loc == usr)
		if(src.ammo_count == 0)
			reload(src)
		else if(!src.aimed)
			start_aiming()
		else
			stop_aiming()
	else
		..()

mob/var/target
mob/var/obj/gettable/guns/equipped_gun

client/Click(destination)
	if(usr.is_aiming)
		if(destination in usr.contents)
			..()
		else
			usr.target = destination
			usr.equipped_gun.shoot()
	else
		..()

obj/gettable/guns/verb/shoot()
	var/destination = usr.target
	var/fire_message = "*POP*"
	var/out_of_ammo_message = "*CLICK*"
	if(usr.is_aiming)
		if(usr.target)
			if(ammo_count > 0)
				LaunchProjectile(destination,damage)
				CreateSmoke(destination)
				view() << "[fire_message]"
				view() << "[usr] shoots [src] at [destination]"
				src.ammo_count -= 1
			else
				view() << "[out_of_ammo_message]"

obj/gettable/guns/proc/LaunchProjectile(destination,damage)
	var/bullet = /obj/projectile
	new bullet(src.loc,destination,damage)

obj/gettable/guns/proc/CreateSmoke(destination)
	var/smoke = /obj/smoke
	new smoke(src.loc,destination)

obj/projectile
	var/power
	icon = 'projectile.dmi'
	density = 1

obj/smoke
	icon = 'smoke.dmi'
	density = 0
	opacity = 1

obj/smoke/New(loc,destination)
	set waitfor = 0
	step_towards(src,destination)
	sleep(10)
	step_towards(src,destination)
	sleep(3)
	del src

obj/projectile/New(loc,destination,damage)
	set waitfor = 0
	power = 10 + roll(1,damage)
	walk_towards(src,destination)
	sleep(10)
	del src

obj/projectile/Bump(atom/target)
	view(target) << "[src] hits [target] for [power]!"
	Hurt(target,power)
	del src