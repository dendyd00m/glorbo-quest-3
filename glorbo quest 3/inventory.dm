mob/Stat()
	statpanel("Stats")
	stat("Health", "[health]/[maxhealth]")
	stat("Magic", "[magic]/[maxmagic]")
	stat("Current Armour", "[armour]")
	stat("Wallet", "[wallet]")
	statpanel("Inventory",usr.contents)
    