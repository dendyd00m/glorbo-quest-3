/mob/var/stat/wallet = 100

/obj/gettable
	var/getsound
	Click()
		if(src.loc in oview(1))
			view() << "[usr] takes [src]."
			Move(usr.loc)
			view() << sound(src.getsound)
			sleep(3)
			src.loc = usr
	MouseDrop(obj/destination,null,obj/location)
		if(destination in view(1))
			if(istype(destination,/turf))
				if(destination.density == 0)
					Move(destination)
					view() << sound(src.getsound)
//					usr << "[destination.name] [destination.loc] [destination.type]"
//					usr << "[location.name] [location.loc] [location.type]"

/obj/gettable/bowling_ball
	icon = 'bowlingball.dmi'

/obj/gettable/drink
	var/sips = 3
	value = 0
	desc = "A beverage."
	getsound = 'drinkpickup.ogg'

obj/gettable/drink/examine()
	. = ..()
	usr << HowFull(src)

obj/gettable/drink/proc/HowFull(obj/gettable/drink/)
	switch(src.sips)
		if(3) return "It's totally full."
		if(2) return "It's half full."
		if(1) return "There's a little left."
		else return "It's empty."

/obj/gettable/drink/soda_can
	icon = 'soda.dmi'
	Click()
		if(src in usr)
			if(sips > 0)
				view() << "[usr] takes a sip of [src]."
				sips = sips - 1
			else
				usr << "[src] is empty!"
				src.suffix = "(empty)"
				src.value = 2
				desc = "Hey, it could be worth a couple Glorbcoins."
		else
			..()

/obj/vending_machine
	density = 1
	icon = 'vending_machine.dmi'
	var/obj/gettable/drink/soda_can/vendor_item
	var/price = 7
	Click()
		var/obj/item
		if(src.loc in view(1))
			if(usr.wallet < price)
				usr << "Uh oh, you don't have enough money in your wallet for that!"
			else
				view() << "[usr] puts [price] Glorbcoins into [src]."
				view() << "KERTHUNK! something falls out of [src]."
				usr.wallet = usr.wallet - price
				vendor_item = new(src.loc)
		for(item in src.contents)
			usr << "[item]"

/*purchase_item(obj/item in src.contents)
set src in view(1)*/