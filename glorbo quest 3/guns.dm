obj/gettable/guns
	var/ammo_count = 0
	var/ammo_maximum = 5
	var/accepted_ammo_type = /obj/gettable/stackable/ammunition/musket_rounds
	verb/reload()
		var/list/reloadables = list()
		var/obj/gettable/stackable/ammunition/ammo
		for(ammo in view(1))
			reloadables += ammo
		var/chosen_ammo = input("Choose an ammo to reload [src]", "reload [src]") as null|obj in reloadables
		if(!chosen_ammo)
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

obj/gettable/guns/flintlock
	accepted_ammo_type = /obj/gettable/stackable/ammunition/musket_rounds
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