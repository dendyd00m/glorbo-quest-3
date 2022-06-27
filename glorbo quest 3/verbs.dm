/*proc example*/
var
	const
		true = 1
		false = 0
var
	daytime = 1

mob
	verb
		check_time()
			if(Day())
				usr << "It is day time."
			else
				usr << "It is night time."
	DM
		verb
			dmclap(area/target in view(0))
				target.luminosity = 1
			change_time(D=1 as num)
				daytime = D
				if(Day())
					usr << "[usr] sets the time to day."
				else
					usr << "[usr] sets the time to night."


proc
	Day()
		if(daytime)
			return true
		else
			return false
/*proc example*/

var
	weather = "The sun is shining!"

mob
	icon = 'player.dmi'
	Login()
		usr << "Welcome to Glorbo's Quest 3!"
		world << "[usr] has logged in."
		loc = locate(/turf/floor/start)
		..()
	verb
		inventory()
			var
				obj
					carried_item
			usr << "You are currently carrying:"
			for(carried_item in usr.contents)
				usr << carried_item.name
		smile(target as mob|null)
			if(!target)
				view() << "[usr] smiles."
			else if(target == usr)
				view() << "[usr] smiles to \himself."
			else
				view() << "[usr] smiles at [target]"
		cry()
			view() << "[usr] cries \his heart out!"
		laugh()
			view() << "[usr] laughs out loud!"
		wink()
			set src in view()
			view() << "[usr] winks at [src]."
		look_up()
			usr << weather
		say(message as text)
			world << "[usr] says, '[message]'"
		telepathic_message(mob/M in world,msg as text)
			view() << "[usr] looks like \he's in deep concentration for a moment."
			usr << "You commune to [M], '[msg]'"
			M << "[usr] communes to you, '[msg]'"
		whisper(msg as text)
			view() << "[usr] whispers something."
			view(3) << "[usr] whispers, '[msg]'"
		set_name(icname=usr.key as text)
			set desc = "(\"new name\") Change your name."
			name = icname || usr.key
			usr << "Your IC name is now [icname]."
/*		attack(mob/target in view(1))
			view() << "[usr] attacks [target]!"
			target.Hurt(10)
*/

mob
	guard
		icon = 'guard.dmi'
		desc = "A stern looking guard."
		wink()
			..()
			usr << "[src] whispers, 'yeet'"
	doppelganger
		var
			const
				init_icon = 'doppel.dmi'
		icon = init_icon
		verb
			clone()
				set src in view()
				src.icon = usr.icon
			revert()
				set src in view()
				src.icon = init_icon

/*!!!!!!!!!!!!!!!!!!!!!!PROCS!!!!!!!!!!!!!!!!!!!*/
//all mobs have hp
mob
	var
		life = 100

//damaging a mob and checking for death (on death, relocates mob to morgue area)
/*	proc
		Hurt(D)
			life = life - D
			usr << "Ouch! You take [D] damage and have [life] hit points left!"
			if(life <= 0)
				view() << "[src] has died."
				src.loc = locate(/turf/floor/start)
				life = 100
*/

mob
	DM
/*		Hurt()
			if(vulnerable)
				..()
			else
				view() << "[src] seems invulnerable to damage!" //GOD MODE!!!!!!!
*/
		var
			unpotato_icon
			unpotato_name
			vulnerable = 1
		key = "DendyDoom"
		verb
			set_vulnerability(v=1 as num)
				set category = "admin"
				vulnerable = v
				if(v == 1)
					usr << "You are now vulnerable."
				else
					usr << "God mode active."
			check_health(mob/target in view())
				set category = "admin"
				usr << "[target] has [target.life] hit points left."
			set_weather(o as text)
				set category = "admin"
				weather = o
			set_value_of_object(obj/O in view(),v as num)
				set category = "admin"
				O.value = v
			set_entity_density(mob/target in view(),d=1 as num)
				set category = "admin"
				target.density = d
			intangible()
				set category = "admin"
				usr << "You can now walk through walls."
				view() << "[usr] looks slightly transparent."
				density = 0
			tangible()
				set category = "admin"
				usr << "You can no longer walk through walls."
				view() << "[usr] looks opaque once more."
				density = 1
			make_potato(mob/target in world)
				set category = "admin"
				unpotato_icon = target.icon
				unpotato_name = target.name
				view() << "[usr] turned [target] into a potato!"
				target.name = "potato"
				target.desc = "Uh oh. They've been turned into a tubor!"
				target.icon = 'potato.dmi'
			unmake_potato(mob/target in world)
				set category = "admin"
				target.name = unpotato_name
				target.desc = ""
				target.icon = unpotato_icon
				view() << "[usr] has reverted [target] to their original form! Thank goodness!"
			set_icon(i as icon)
				set category = "admin"
				set name = "set icon"
				icon = i
			set_icon_from_view(I as anything in view())
				set category = "admin"
				icon = I
			teleport_to_entity(entity as anything in world)
				set category = "admin"
				usr.loc = entity
			set_luminosity(mob/O,i as num)
				set category = "admin"
				set name = "set luminosity"
				O.luminosity = i
				usr << "You set the luminosity of [O] to [O.luminosity]."
			banish(target as mob)
				set category = "admin"
				set desc = "Remove someone from the realm. Begone!"
				world << "[target] has been BANISHED from the realm by [usr]!"
				del target
			swap_places(mob/target in world)
				set category = "admin"
				var
					usr_loc = usr.loc
				usr.loc = target.loc
				target.loc = usr_loc
				target << "Zap! You feel yourself carried across the cosmos!"
				usr << "Zap! You swap places with [target]!"


area
	dark
		proc
			ChangeDayNight()
				if(Day())
					luminosity = 1
				else
					luminosity = 0
		luminosity = 0
		verb
			do_day_night()
				ChangeDayNight()

obj
	var
		value = 100
	verb
		get()
			set src in oview(1)
			view() << "[usr] takes [src]."
			loc = usr
		drop()
			set src in usr
			view() << "[usr] drops [src]."
			loc = usr.loc
		examine()
			set src in view()
			usr << desc
		appraise()
			set src in view(1)
			usr << "You estimate the value of [src] to be around [value] Glorbcoins."
	mirror_scroll
		icon = 'mirror_scroll.dmi'
		verb
			cast()
				set src in view(1)
				set name = "use magic scroll"
				var
					init_icon = usr.icon
				usr.icon = icon
				icon = init_icon
				view() << "[usr] touches [src]. FZZZZP!"
	poison_vial
		icon = 'poison.dmi'
		verb
			drink()
				set src in view(1)
				view() << "[usr] guzzles down [src]"
				usr << "AGH! THAT WAS POISON!"
				Hurt(usr,100)
				del src

	torch
		luminosity = 3
		desc = "A length of wood with one end that can be set alight."
		icon = 'torch.dmi'
		verb
			extinguish()
				set src in view(1)
				luminosity = 0
				view() << "The torch is extinguished."
			light()
				set src in view(1)
				if (!luminosity)
					luminosity = 3
					view() << "The torch is lit."
				else
					usr << "[src] is already lit!"
			pray()
				set src = view()
				view() << "[usr] prays to the light."
				view() << "The torch burns brighter!"
				luminosity = 6
	disguise
		icon = 'disguise.dmi'
		desc = "A devious disguise that can be worn to conceal one's identity."
		var
			usr_icon
		verb
			wear()
				set src in view(1)
				usr_icon = usr.icon
				usr.icon = src.icon
				view() << "[usr] dons [src]."
			remove()
				set src in view(1)
				usr.icon = usr_icon
				view() << "[usr] doffs [src]."
	scroll
		icon = 'scroll.dmi'
		desc = "A piece of parchment."
		var
			written
		verb
			write(msg as message)
				set src in view(1)
				written = msg
				view() << "[usr] writes something on [src]."
			read()
				set src in view(1)
				view() << "[usr] reads [src]."
				usr << written
		book
			icon = 'book.dmi'
			desc = "A plain looking book."
		shared_scroll
			var
				global
					shared_message
			write(msg as message)
				set src in view(1)
				shared_message = msg
			read()
				set src in view(1)
				view() << "[usr] reads [src]."
				usr << shared_message

turf
	floor
		icon = 'floor.dmi'
		start
			icon = 'floor.dmi'
	wall
		icon = 'wall.dmi'
		density = 1
		opacity = 1