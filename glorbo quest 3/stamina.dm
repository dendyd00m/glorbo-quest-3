/mob/var/stat/stamina = 100
/mob/var/stat/maxstamina = 100
/mob/var/stat/stamina_regain_speed = 6
/mob/var/isresting = 0

/proc/StaminaCost(mob/target,cost)
	target.stamina -= cost
	return target.stamina

/mob/proc/CheckStamina(mob/target,minimum)
	if(target.stamina < minimum)
		return 0
	else
		return 1

/mob/proc/RegainStamina()
	if(!src.isresting)
		src.isresting = 1
		while(src.stamina < src.maxstamina)
			sleep(10)
			src.stamina += src.stamina_regain_speed
			if(src.stamina > src.maxstamina)
				src.stamina = src.maxstamina
		src.isresting = 0
