/mob/Stat()
	statpanel("Stats")
	stat("Health", "[health]/[maxhealth]")
	stat("Magic", "[magic]/[maxmagic]")
	stat("Current Armour", "[armour]")
	stat("Effective Damage", "[weapondamage]")
	stat("Current Weapon", usr.currentweapon)
	stat("Wallet", "[wallet]")
	statpanel("Inventory",usr.contents)
