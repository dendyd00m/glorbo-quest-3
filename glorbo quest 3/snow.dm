particles/snow
    width = 500     // 500 x 500 image to cover a moderately sized map
    height = 500
    count = 2500    // 2500 particles
    spawning = 12    // 12 new particles per 0.1s
    bound1 = list(-1000, -300, -1000)   // end particles at Y=-300
    lifespan = 600  // live for 60s max
    fade = 50       // fade out over the last 5s if still on screen
    // spawn within a certain x,y,z space
    position = generator("box", list(-300,250,0), list(300,300,50))
    // control how the snow falls
    gravity = list(0, -1)
    friction = 0.3  // shed 30% of velocity and drift every 0.1s
    drift = generator("sphere", 0, 2)
obj/snow
    screen_loc = "CENTER"
    particles = new/particles/snow

mob
	proc/CreateSnow()
		client?.screen += new/obj/snow
	verb
		make_snow()
			CreateSnow()