obj/gettable/guns
    var/ammo_count = 0
    var/ammo_maximum = 5
    verb/reload(obj/gettable/stackable/ammunition/ammo in view(1))
        var/ammo_fill_amount = ammo_maximum - ammo_count
        if(ammo_count < ammo_maximum)
            if(ammo.amount >= ammo_fill_amount)
                ammo_count += ammo_fill_amount
                ammo.amount -= ammo_fill_amount
                view() << "[usr] loads [ammo_fill_amount] [ammo.name] into [src]"
            else if(ammo.amount < ammo_fill_amount)
                ammo_fill_amount = ammo.amount
                ammo.amount -= ammo_fill_amount
                view() << "[usr] loads [ammo_fill_amount] [ammo.name] into [src]"

obj/gettable/stackable/ammunition
    var/amount = 1

obj/gettable/stackable/ammunition/musket_rounds
    icon = 'musket_rounds.dmi'
    amount = 3

obj/gettable/guns/flintlock
    icon = 'flintlock.dmi'