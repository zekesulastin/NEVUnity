datum/system
	var/name
	var/list/datum/planet/planets // List of planets in orbit
	var/star_number // Binary system?
	var/star_type //Approximate surface temperature of the star
	var/luminosity //Total radiation emitted by star. Luminosity differentiates stars within a class by size
	var/luminosity2 //binary star info
/*
 Types
O, Blue, Over 25,000K (Ionized Helium )
B, Blue, 11,000K-25,000K ( Helium )
A, Blue, 7,500-11,000K (Hydrogen)
F, Blue-White, 6,000-7,500K
G, White-Yellow, 6,000-5,000K
K, Orange-Red, 5,000K-3,500K
M, Red, Under 3,500K
 */

/*
 Luminosity
Ia	Very luminous supergiants
Ib	Less luminous supergiants
II	Luminous giants
III	Giants
IV	Subgiants
V	Main sequence stars (dwarf stars)
VI	Subdwarf
VII	White Dwarf
	*/

datum/system/New()
	name = "TEST TEST TEST" // Need input here from file. Randomize?
	star_type = pick("O","B","A","F","G","K","M") //Star color/temperature
	if(star_type == "O") //white dwarves are always weakest luminosity
		luminosity = "VII"
	else //All other stars vary depending on size!
		luminosity = pick("Ia","Ib","II","III","IV","V","VI")
	if(prob(25)) //25% chance of a binary system
		star_number = 2
		if(luminosity == "V" ||luminosity == "VI" || luminosity == "VII") //if we have a main sequence star
			luminosity2 = luminosity//Its binary star is identical!
		else //if we have a giant star
			luminosity2 = pick("V","VI","VII") //It's an eclipse binary!
	else //If we don't have a binary system, then we only have one star!
		luminosity2 = 0
		star_number = 1

//planet creation! Some of these are not planets, so make up to 20 sites!
	planets = null
	var/pnumber = 0
	switch(luminosity)
		if("VII")
			pnumber = rand(0,3)
		if("VI")
			pnumber = rand(0,7)
		if("V")
			pnumber = rand(0,12)
		if("IV")
			pnumber = rand(0,12)
		if("III")
			pnumber = rand(0,18)
		else
			pnumber = rand(0,23)
	while(pnumber > 0)
		var/seed = rand(0,99)
		switch(star_type)
			if("O")
				seed = seed - 50 // White dwarves are mostly anomolies and balls of gas, with the very occasional Habitable world
			if("B")
				seed = seed - 30 // Blue stars are young and hot, so lots of gas giants and semi-habitable worlds, not so many airless rocks
			if("A")
				seed = seed - 10
			if("F")
				seed = seed
			if("G") //main sequence
				seed = seed + 10
			if("K") //orange/red stars have more debries fields and dead planets
				seed = seed + 30
			if("M") //red giants have tons of burnt-out rocks circling
				seed = seed + 50
		seed = seed - (pnumber * 5) //As you go out, you get more gas giants and anomolies
		var/ptype = "Dead"
		switch(seed)
			if(-100 to 9)
				ptype = "Anom"
			if(10 to 24)
				ptype = "Gas"
			if(25 to 34)
				ptype = "Habit"
			if(35 to 59)
				ptype = "Debris"
			if(60 to 200)
				ptype = "Dead"
		var/datum/planet/x = new /datum/planet(ptype)
		x.orbit_number = pnumber
		planets = planets + x
		pnumber--

datum/planet/
	var/name
	var/orbit_number // How far from the star?
	var/datum/system/system //Who do you orbit?
	var/planet_type //See below. What type of planet is it?
	var/subtype //What flavor of sub-site are you?
	var/datum/probe/probe
//Below vars show up on the scanner
	var/temp // How hot the site is
	var/size // How big the site is
	var/rads //What type of radiation you are getting
	var/intensity //how intense is the radiation
datum/planet/New(var/typein)

datum/planet/New()
/*
  Planets
  Main sequence stars have most "Habitable" planets
  Giants have the most planets overall (Often Dead planets or gas giants)
  Dwarfs have the most  "Asteroids"
  Older/redder stars have the most "Debries"

  Site types
  -Habitable (Expo planet. Food/planets/hostile mobs. Provides O2, N2)
  --High/Low/Mid tech
  --Hot/cold/temperate
  --Arid/Costal/Aquatic

  -Gas Giant (Provides random gas in the probe canisters. Occasionally finds a deep space artifact)
  --Hydrogen
  --Helium
  --Methane
  --Ammonia

  -Dead Planets (Mining maps)
  --Iron
  --Silicates
  --Carbonates

  -Debries (Expo site. Derelict ships. Artifacts?)
  --War (Battle)
  --Temple (Tomb)
  --House (Scuttled)
  --Ark (Overrun)
  --School (Abanoned)

  -Anomoly Fields (Adds special events)
  --Bluespace Field
  --Gravity Field
  --Unstable Wormhole Field
  --Electromagnetic

*/

