/mob/var/stat/stamina = 100
/mob/var/stat/maxstamina = 100
/mob/var/stat/stamina_regain_speed = 10
/mob/var/isresting = 0

/proc/StaminaCost(mob/target,cost)
	target.stamina -= cost
	return target.stamina

/mob/proc/CheckStamina(mob/target,minimum)
	if(target.stamina < minimum)
		return 0
	else
		return 1

/mob/proc/RegainStamina(mob/target)
	set waitfor = 0
	if(!target.isresting)
		set background = 1
		target.isresting = 1
		while(target.stamina < target.maxstamina)
			sleep(30 * world.tick_lag)
			target.stamina += roll(1,target.stamina_regain_speed)
			if(target.stamina > target.maxstamina)
				target.stamina = target.maxstamina
		target.isresting = 0
