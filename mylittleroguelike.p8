pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
	
global = {
	gravity = 0.5,
	onContainer = false,
	containerText = "",
	buyContainer = false,
	pickupSpell = false,
	onPickup = false,
	textPoint = {},
	teleportClockOffset = 0,
	state = 0, -- 0: menu, 1: gameplay, 2: endscreen, [3: help, 4: settings]
	runeScene = false,
	endScreenMessage = "",
	transition = false,
	transition_y = 0,
	transition_number = 0,
	trans = {
		x = 0,
		y = 0
	},
	runeIndicator = 0,
	runePickupEnd = 0,
	regen = 0,
	showRegen = false,
	music = true
}

director = {
	level = 1,
	levelSpawnPoints = {},
	levelType = 0,
	levelCleared = false,
	levelEntered = 0,
	cost = 10,
	ticks = 0,
	secs = 0,
	mins = 0,
	chestOnStage = 0,
	usedCredits = 0,
	maxCredit = 10,	
	enemyCredits = {1,2,4,2,4,4,3,3,4},
	teleporterActivated = false,
	teleporterEnds = 0,
	teleporterPosition = {
		x=0,
		y=0
	},
	telerporterStatus = 0,
	mapName = "",
	difficulty = 0
}

player = {
	x = 25*8,
	y = 13*8,
	ax = 0,
	ay = 0,
	acceleration = 1,
	jumpForce = 5.5,
	maxSpeed = 3,
	isGrounded = false,
	isFlipped = false,
	maxFall = 5,
	spellEquipped = 0,
	equippedCd = 0,
	spellInInventory = 0,
	invCd = 0,
	isCastingSpell = false,
	spellCooldowns = {0,2,2,6,4,3},
	souls = 0,
	life=3,
	maxLife=100,
	kills = 0,
	killedBy = 0,
	damageEnd = 0,
	runes = 10,
	runesForged = {0,0,0,0,0,0},
	nextRegenTick = 0,
	invFramesEnd = 0,
	level = 1
}

crect = {
	x,
	y
}

castedSpells = {}
particles = {}
containers = {}
enemies = {}
enemyProjectiles = {}
foliage = {}
bouncers = {}
pickups = {}

mapNames = {
	"shroom glade",
	"overgrown pillars",
	"castle ruins",
	"tower ruins",
	"burried lab"
}

mapContainer = {
	-- forest 1
	"19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,161,2,0,0,0,0,178,1,33,32,0,0,0,145,49,0,0,2,0,0,0,0,162,2,34,0,0,0,0,146,50,16,16,2,0,0,0,0,177,2,34,0,0,0,0,0,51,32,95,2,0,0,0,0,95,3,35,32,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,49,0,0,0,0,144,2,0,0,0,0,0,0,49,0,161,50,0,0,0,0,145,2,0,0,0,0,0,177,50,16,16,50,16,16,16,16,16,2,0,0,0,0,0,130,51,0,0,50,0,0,0,0,146,2,0,0,0,0,0,0,0,0,162,50,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,50,32,0,0,0,0,2,0,0,0,0,0,0,0,0,95,50,0,0,0,0,0,2,0,0,0,0,0,0,0,0,162,50,0,0,0,0,0,2,0,0,0,0,0,49,0,0,0,50,16,16,16,16,16,2,0,0,0,0,128,50,16,16,16,50,0,0,0,0,0,2,0,0,0,0,0,50,0,0,128,51,0,0,0,0,0,2,0,0,0,0,145,50,0,0,0,0,0,0,0,0,0,2,0,0,0,0,144,50,32,0,0,0,0,0,0,95,1,0,0,0,0,0,145,50,0,0,0,0,0,0,0,0,2,0,0,0,0,0,146,2,17,17,17,17,33,0,0,146,2,0,0,0,0,0,95,2,18,0,0,18,34,0,0,0,2,0,0,0,0,0,128,3,19,19,19,0,34,16,16,16,2,18,0,0,0,0,0,0,0,0,3,2,34,0,0,0,2,0,0,0,0,0,0,0,0,0,129,2,34,0,0,0,2,0,0,0,49,0,0,0,0,0,128,2,34,32,0,144,3,0,0,145,50,0,0,0,0,0,95,2,34,0,0,0,0,2,0,130,50,0,0,0,0,0,145,2,34,0,0,0,0,2,0,0,50,0,0,0,0,0,130,2,34,0,0,0,146,2,0,145,50,0,0,0,0,1,17,17,17,17,33,0,0,2,0,130,51,0,0,105,121,2,0,0,0,0,34,0,177,2,0,0,0,0,0,116,0,2,18,0,0,18,34,0,0,2,0,0,0,0,0,107,123,2,0,0,0,0,34,16,16,2,0,0,0,0,0,0,144,2,0,0,18,0,34,32,0,2,0,0,0,0,0,0,0,3,19,19,19,19,35,0,95,2,0,0,0,0,0,0,0,0,0,95,50,0,0,0,177,2,0,0,0,0,0,0,0,0,0,0,51,0,0,0,144,2,0,0,0,49,0,0,0,0,0,0,0,0,0,0,0,2,0,0,95,50,0,0,0,49,0,0,0,0,0,0,162,2,0,0,0,50,0,0,0,50,16,16,16,16,16,16,16,2,0,0,0,51,0,0,162,50,0,0,0,0,145,1,17,0,0,0,0,0,0,0,0,50,32,0,0,0,178,2,0,0,0,0,0,0,0,0,146,50,0,0,0,1,17,0,0,18,0,0,0,0,0,0,144,50,16,16,16,2,0,0,0,0,0,0,0,0,0,0,145,50,0,0,177,2,0,0,0,0,0,0,0,0,0,0,144,51,32,0,145,2,18,0,18,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,19,19,0,0,0,49,0,0,95,49,0,0,0,0,0,0,0,0,2,0,0,50,16,16,16,50,16,16,16,16,16,16,16,16,2,0,0,50,0,0,0,51,0,0,0,0,0,0,0,0,2,0,0,50,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,50,0,0,0,0,0,146,1,33,0,0,95,2,0,0,95,50,16,16,16,16,16,16,2,34,0,0,177,2,0,0,0,51,0,0,0,0,0,144,2,34,0,0,178,2,0,0,0,0,0,0,0,0,0,0,2,34,0,0,0,3,0,0,0,0,0,0,0,1,17,17,0,0,33,0,0,0,2,0,0,0,0,0,146,2,0,0,0,0,34,0,0,129,2,0,0,0,0,0,129,2,0,0,0,0,34,0,0,146,2,0,0,0,49,0,0,3,0,0,0,0,34,0,0,0,2,0,0,0,50,0,0,129,3,19,19,19,35,0,0,129,2,0,0,0,50,0,0,0,0,0,0,0,0,0,0,95,2,17,17,17,0,17,17,17,17,17,17,17,17,17,17,17,0,",
	-- forest 2
	"19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,0,0,0,0,0,0,2,0,0,0,0,34,0,0,0,0,2,0,0,0,0,144,2,0,0,0,0,34,0,0,0,145,2,0,0,0,0,95,2,0,18,0,0,34,16,32,0,95,2,0,0,0,0,128,2,0,0,0,18,34,0,0,0,160,2,0,0,0,0,129,2,0,0,0,0,34,0,0,0,176,2,0,0,0,0,161,3,19,19,19,0,34,16,32,0,146,2,0,0,0,0,0,0,0,0,79,1,17,33,0,0,144,2,0,0,0,0,0,0,0,0,129,2,0,34,0,0,145,2,0,0,0,0,0,0,0,0,144,2,18,34,16,16,16,2,0,0,49,32,0,0,0,0,0,3,19,35,0,0,0,2,0,176,50,0,0,0,0,0,0,0,0,0,0,0,145,2,0,146,2,33,32,0,0,0,0,0,0,0,0,0,79,2,0,95,2,34,0,0,0,0,0,0,0,0,0,0,0,2,0,176,2,35,0,0,0,0,0,176,1,33,32,0,128,2,0,178,50,0,0,0,0,0,0,161,2,34,0,0,0,2,0,0,51,32,0,0,0,0,0,145,2,34,16,16,16,2,0,0,0,0,0,0,0,0,0,144,2,0,33,0,0,2,0,0,0,0,0,0,0,0,176,1,0,0,34,32,0,2,0,0,0,0,0,0,0,0,0,2,0,18,35,0,128,2,0,0,0,129,1,33,0,0,95,2,0,34,0,0,145,2,0,0,0,0,3,35,32,0,161,3,18,0,33,0,0,2,0,0,0,0,0,0,0,0,0,145,3,19,35,16,16,2,0,0,0,0,0,0,0,0,0,0,0,0,50,0,0,2,0,0,0,0,0,0,0,0,0,0,0,176,50,0,0,2,0,0,0,0,0,0,0,52,0,0,0,144,50,0,0,2,0,0,0,0,0,0,0,53,15,15,15,15,51,0,0,2,0,0,0,0,0,0,0,53,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,53,15,15,15,15,15,15,15,2,144,1,33,0,0,0,0,54,0,0,0,0,0,0,0,2,145,3,35,32,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,105,121,2,0,0,0,0,0,0,0,0,0,0,0,0,0,116,0,2,0,0,0,0,0,0,162,1,33,16,32,0,0,107,123,2,0,0,0,0,0,0,161,2,0,33,0,0,0,0,0,3,0,0,0,0,0,0,95,2,0,35,0,0,0,0,0,0,2,0,0,0,0,0,129,3,34,0,0,0,0,0,0,144,2,0,0,0,1,17,17,17,34,16,32,0,49,0,0,162,2,0,0,178,2,0,18,0,34,0,0,145,50,16,16,16,2,0,0,145,2,0,0,0,34,32,0,0,51,0,0,0,2,0,0,129,3,19,19,19,35,0,0,0,0,0,0,144,2,0,0,0,0,0,95,50,0,0,0,0,0,0,0,162,2,0,0,0,0,0,161,50,0,0,0,128,4,15,15,15,2,0,0,0,0,0,178,50,32,0,0,95,6,15,15,15,2,0,0,0,0,0,145,51,0,0,0,0,0,0,0,128,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,162,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,176,1,17,33,32,0,0,0,145,4,20,20,15,15,15,2,162,2,0,0,33,0,0,0,128,6,22,22,15,15,15,2,95,2,18,0,35,0,0,0,0,0,0,0,0,0,0,2,177,2,0,34,0,0,0,0,0,0,0,0,0,0,79,2,0,3,0,34,32,0,0,0,0,0,49,0,0,0,162,2,0,162,3,35,0,0,0,1,17,17,17,33,0,0,146,2,0,0,0,0,0,0,128,2,0,0,0,34,32,0,129,2,0,0,0,0,0,0,162,2,0,18,0,34,0,0,177,2,0,0,0,0,0,0,0,2,0,0,19,35,0,0,1,0,0,0,0,0,1,17,17,0,0,34,0,0,0,130,2,0,0,0,0,128,2,18,0,0,0,35,32,0,0,162,2,0,0,0,0,162,2,0,0,0,34,0,0,0,0,1,0,0,0,0,0,0,2,0,0,0,34,0,0,0,128,2,0,0,0,0,0,95,2,0,18,0,34,16,32,0,95,2,18,0,0,0,0,0,2,0,0,0,35,0,0,0,129,2,0,0,0,0,0,162,2,18,0,34,0,0,0,0,0,2,18,0,17,17,17,17,0,0,0,0,17,17,17,17,17,0,0,0,",
	--castle 1
	"19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,0,0,0,0,0,53,15,15,131,15,131,54,15,15,0,0,2,0,0,0,95,53,15,132,148,15,148,0,132,15,0,0,2,0,0,0,0,15,148,0,0,15,0,0,0,53,0,145,2,0,0,0,0,15,0,0,0,53,147,0,0,53,0,0,2,0,0,0,0,15,147,0,21,53,131,0,95,53,0,161,2,0,0,0,0,53,147,147,0,53,15,15,132,53,0,0,2,0,0,0,0,53,15,132,0,53,15,15,15,53,0,129,2,0,0,0,4,21,20,20,20,21,36,148,132,50,0,95,2,0,0,0,6,21,22,22,22,22,38,0,0,50,0,161,2,0,0,0,0,54,0,0,0,0,0,0,0,50,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,50,0,144,2,0,0,0,0,0,0,0,0,0,0,0,0,50,0,0,2,0,0,0,0,0,0,0,52,147,0,0,0,2,33,32,2,0,0,0,0,0,0,0,53,15,15,15,15,3,35,32,2,0,0,0,0,0,0,0,53,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,53,15,15,15,15,15,15,15,2,0,0,0,0,0,0,0,54,148,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,52,147,131,2,0,0,0,0,0,0,0,15,4,20,20,20,37,15,15,52,0,0,0,0,0,0,0,0,5,21,0,0,37,15,15,53,0,52,0,0,0,0,0,0,5,0,0,0,37,15,15,53,0,53,20,20,20,36,147,131,5,0,0,21,37,15,15,53,95,53,0,0,0,37,15,15,5,22,22,22,37,147,132,53,0,53,22,22,22,38,15,132,53,180,15,15,54,132,147,53,0,54,0,132,15,15,147,131,54,0,132,15,147,0,132,53,0,0,0,0,15,15,15,15,148,0,0,0,147,131,79,53,0,0,0,147,132,132,147,15,147,0,0,0,132,15,147,53,0,0,52,15,15,0,132,148,131,147,52,131,0,132,15,53,0,0,53,147,147,0,53,0,147,15,53,15,147,0,4,38,0,0,54,15,15,148,53,131,15,15,53,15,148,0,53,0,0,0,0,132,148,131,53,15,15,15,53,15,0,95,53,0,0,0,0,0,131,15,53,15,148,0,53,15,147,0,53,0,0,105,121,52,131,15,53,148,0,131,53,15,15,147,53,0,0,116,0,53,15,15,53,0,131,15,53,148,15,148,6,36,0,107,123,54,132,15,53,15,15,15,15,147,0,0,21,53,0,0,0,0,0,132,53,132,148,15,15,148,0,21,21,53,0,0,0,0,0,0,53,0,0,148,0,0,0,0,21,53,0,0,0,0,0,0,53,147,147,0,0,0,0,131,147,53,0,0,0,0,0,0,53,15,15,15,53,148,0,132,15,53,0,0,0,0,147,0,53,0,132,15,53,147,0,0,15,53,0,0,0,21,15,147,0,0,147,132,53,15,15,15,15,53,0,95,5,21,132,15,0,0,132,21,53,148,0,0,15,53,0,0,5,21,131,15,0,0,21,21,53,147,0,0,15,53,0,0,0,21,15,148,0,0,147,21,53,15,15,15,15,53,0,0,0,0,15,0,0,0,148,131,53,148,0,0,15,53,0,0,0,0,0,0,53,132,0,148,53,147,0,0,132,53,0,0,0,0,0,0,53,15,15,0,53,15,15,0,0,53,0,0,0,0,0,0,53,148,0,0,53,148,0,0,131,53,0,0,0,0,0,0,0,0,0,0,53,147,0,0,15,53,0,0,0,0,0,0,0,0,0,0,54,15,15,15,15,53,0,0,0,0,0,0,0,0,0,0,0,132,132,15,131,53,0,0,0,0,0,0,52,0,0,0,0,0,0,132,0,53,0,0,0,0,0,0,53,0,0,0,0,0,0,0,0,53,0,0,0,0,0,79,53,179,0,0,0,0,0,131,21,53,0,0,0,0,0,0,54,20,20,20,20,15,147,0,21,53,0,0,0,0,0,0,0,148,15,148,15,132,15,15,147,53,0,0,0,0,0,0,0,15,148,131,15,131,15,132,79,53,0,0,0,0,0,0,0,15,15,52,15,0,131,15,132,53,0,0,52,0,0,0,52,22,22,22,22,22,15,15,15,53,0,0,53,0,0,0,53,180,0,0,0,132,148,15,148,53,0,95,53,0,0,0,54,0,0,0,0,0,0,0,0,2,0,0,53,0,0,0,0,0,0,0,0,0,0,95,1,0,17,17,17,17,17,17,17,17,17,17,17,17,17,17,0,0,",
	--castle 2
	"19,19,19,19,0,19,19,19,19,0,0,0,0,0,0,0,0,0,0,95,50,0,0,0,145,3,19,19,0,0,0,0,0,0,0,0,51,0,0,0,0,0,0,161,3,19,19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,95,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,149,4,0,0,0,0,0,0,52,32,0,0,0,0,0,0,0,5,4,20,20,36,133,0,5,20,20,20,20,20,36,147,131,5,0,5,148,53,148,131,5,133,133,133,147,165,53,148,15,5,0,148,131,53,131,148,5,133,133,148,0,95,53,132,148,5,0,15,133,54,148,0,5,148,0,0,0,0,53,15,132,5,0,15,133,133,0,131,5,0,147,5,147,0,132,15,15,5,95,5,132,133,131,132,15,0,133,5,133,133,147,148,15,5,0,5,0,132,133,147,15,131,133,5,133,147,0,15,132,5,6,6,22,38,133,148,5,22,22,22,22,22,38,148,0,5,0,0,0,0,0,0,54,32,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,79,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,165,2,0,0,0,0,0,0,0,0,0,52,0,0,0,0,0,2,0,95,1,17,33,32,0,0,95,53,15,15,15,15,15,2,0,165,2,0,35,0,0,0,0,53,32,0,0,0,129,2,0,0,3,35,0,0,0,0,165,53,15,15,15,15,15,2,0,0,0,0,0,0,0,0,0,54,32,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,2,0,0,0,52,0,0,0,0,0,0,0,0,0,0,129,2,0,0,165,53,32,0,0,0,0,0,0,0,128,1,17,0,0,0,128,54,0,0,0,52,0,0,0,149,1,0,0,0,0,0,0,0,0,0,95,53,15,15,15,15,2,0,0,0,0,0,0,0,0,0,0,53,0,0,0,165,3,19,19,0,0,0,0,0,0,0,0,53,0,0,0,0,0,0,95,2,0,0,0,161,49,0,0,53,0,0,0,0,0,0,79,2,0,0,0,129,51,0,0,53,15,15,15,15,1,17,17,0,0,0,0,0,0,0,0,53,0,0,0,128,3,19,19,0,0,0,0,0,0,0,165,54,0,0,0,0,0,0,79,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,129,52,32,0,0,2,0,0,0,0,0,0,0,0,0,0,0,53,15,15,15,2,0,0,0,0,0,0,0,0,0,0,95,53,0,0,144,2,0,0,0,0,176,1,17,33,32,0,0,53,0,0,0,2,0,0,0,0,4,0,0,35,0,0,129,53,15,15,15,2,4,20,147,147,5,18,34,32,0,0,0,54,32,0,0,2,5,133,147,133,5,0,35,0,0,0,0,0,0,0,0,2,5,148,0,0,5,34,0,0,0,0,0,0,0,0,79,2,5,147,105,121,5,34,16,32,0,0,0,1,17,17,17,0,5,133,116,0,5,0,33,32,0,0,128,2,0,18,0,0,5,148,107,123,5,0,0,33,0,0,0,3,19,0,0,0,5,147,0,0,5,0,0,34,0,0,0,0,0,2,0,0,5,133,132,133,5,0,18,34,0,0,0,0,0,2,18,0,6,22,148,148,5,0,0,35,32,0,0,0,128,2,0,0,0,0,0,0,6,0,35,0,0,0,0,0,0,3,0,0,0,0,0,0,149,51,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,52,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,53,147,0,0,0,0,162,2,0,0,0,0,0,0,0,95,53,132,147,0,0,0,0,2,0,0,0,0,0,0,0,149,53,0,132,147,0,0,0,2,0,0,52,0,0,0,0,129,53,32,0,132,147,0,0,4,0,0,53,20,20,20,147,131,53,20,20,20,20,147,131,5,0,149,53,148,0,0,15,132,53,148,131,15,147,148,132,5,0,95,53,147,0,0,15,131,53,15,15,15,147,147,131,5,0,0,53,15,15,53,148,148,53,148,0,95,53,133,133,5,0,0,148,131,131,53,15,0,15,147,0,0,53,15,15,5,0,0,15,131,15,53,131,147,148,15,15,15,53,15,132,5,0,0,53,148,0,0,15,15,15,148,0,131,15,147,131,5,0,149,53,147,0,0,15,131,15,0,52,131,15,15,148,5,17,17,21,21,21,21,21,21,21,21,21,21,21,21,21,21,",
	-- lab 1
	"0,25,25,0,0,0,0,0,0,0,0,0,0,25,25,0,40,0,0,9,25,25,0,0,0,0,0,0,40,0,0,8,40,0,0,0,0,0,9,25,25,0,0,0,40,0,0,8,40,0,0,0,0,0,0,135,0,8,0,0,40,0,95,8,40,0,0,55,0,152,0,135,95,8,0,0,40,152,0,8,40,0,0,57,0,135,0,134,0,8,25,25,41,0,0,8,40,0,153,169,55,168,136,167,136,56,0,0,134,0,0,8,40,0,0,95,56,0,0,134,0,56,0,0,135,0,0,8,40,0,153,169,57,0,0,135,0,56,0,0,134,0,0,8,40,0,0,55,136,136,136,152,0,57,0,0,168,136,136,8,40,0,0,56,0,0,0,0,0,0,0,0,0,0,79,8,40,0,0,57,0,0,0,0,0,0,0,79,55,0,0,8,40,0,0,0,0,0,7,39,0,0,0,0,56,136,136,8,40,0,0,0,0,0,8,0,23,39,0,0,56,0,0,8,40,0,0,0,0,137,8,0,0,40,0,95,56,136,136,8,40,0,0,0,0,95,8,0,25,41,0,0,57,0,0,8,40,0,0,0,0,0,8,40,0,135,0,0,0,0,0,8,40,0,0,0,0,0,9,41,0,168,136,167,183,152,0,8,40,0,0,0,0,0,0,134,0,0,0,135,0,0,0,8,40,0,0,0,0,0,0,135,0,0,0,151,0,0,0,8,40,0,0,0,0,0,0,135,0,79,7,23,39,0,0,8,40,0,0,0,0,55,0,134,0,0,8,0,41,0,0,8,40,136,152,136,136,56,136,167,0,0,8,40,135,0,95,8,40,0,0,0,95,57,0,135,0,137,8,40,135,0,0,8,40,0,0,0,0,0,0,135,0,0,8,0,39,0,0,8,40,0,0,0,7,39,0,135,0,0,9,25,41,0,0,8,40,0,0,0,8,40,0,135,0,0,135,0,0,0,79,8,40,0,0,95,8,0,39,184,0,0,134,0,152,0,0,8,40,0,0,0,9,25,41,0,0,0,135,0,135,0,0,8,40,0,0,0,0,0,0,0,0,0,134,0,134,0,0,8,40,0,0,0,0,0,0,0,0,0,135,0,135,0,0,8,40,0,0,0,0,0,0,0,55,0,168,136,135,136,136,8,40,0,0,55,0,0,0,95,56,0,0,0,134,0,0,8,40,136,136,56,0,0,0,0,56,136,136,136,152,0,0,8,40,0,0,56,0,0,185,169,56,0,0,0,0,0,0,8,40,0,95,56,0,0,0,0,57,0,0,0,0,0,7,8,40,136,136,56,0,0,0,0,0,0,0,0,7,23,23,0,40,0,0,57,0,0,0,0,0,0,0,79,8,0,0,0,40,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,40,0,0,0,0,137,7,39,0,0,0,0,9,25,25,0,40,0,0,0,0,0,8,0,39,0,0,0,0,135,9,8,40,0,0,0,0,137,8,0,40,0,0,0,0,134,0,8,40,0,0,0,0,95,8,0,41,0,0,0,0,134,0,8,40,0,0,0,0,137,9,41,0,0,152,136,136,167,136,8,40,0,0,0,0,0,0,135,0,0,0,0,0,135,0,8,40,0,0,0,0,0,0,152,0,0,0,0,7,39,0,8,40,0,0,0,0,0,0,135,0,0,0,79,8,40,0,8,40,0,0,7,39,0,153,169,55,0,185,169,8,41,0,8,40,0,95,8,40,0,0,95,56,0,0,95,56,0,0,8,40,0,0,8,40,0,185,169,56,0,153,169,56,136,136,8,40,0,0,8,40,0,0,0,57,0,0,0,57,0,0,8,40,0,95,8,0,39,0,0,0,0,0,0,0,0,0,8,40,0,0,9,25,0,39,0,0,0,0,0,0,0,0,8,40,0,0,0,0,9,41,0,0,0,7,23,39,0,0,8,40,0,0,0,0,0,0,0,137,7,0,25,41,0,0,8,40,0,0,0,0,0,0,0,0,8,40,0,0,0,95,8,40,152,136,166,136,136,136,167,136,8,40,136,136,153,169,8,40,0,0,134,0,0,0,134,0,8,40,0,0,0,0,8,40,0,0,135,0,0,0,135,79,8,40,0,0,105,121,8,40,0,0,135,0,55,0,134,0,8,40,0,0,116,0,8,40,136,136,184,137,56,136,167,136,8,40,0,0,107,123,8,40,0,0,0,0,56,0,151,95,9,40,0,0,0,0,8,40,0,0,0,95,56,0,0,0,0,57,136,183,185,169,8,40,0,0,0,137,56,0,0,0,0,0,0,0,0,79,8,0,23,23,23,23,0,23,23,23,23,23,23,23,23,23,0,",
	-- lab 2
	"0,25,25,25,25,25,25,0,0,0,0,0,0,0,0,0,40,0,0,134,0,0,0,9,25,25,0,0,0,0,0,0,40,0,0,135,0,0,0,0,0,95,2,18,0,0,0,0,40,0,0,134,0,0,0,0,0,129,3,19,0,0,18,0,40,136,136,167,136,7,39,0,0,0,0,0,3,19,19,0,40,0,0,135,95,8,40,0,0,0,0,135,0,185,169,2,40,0,0,135,0,9,41,0,0,0,0,135,0,0,79,2,40,0,0,135,0,0,0,0,0,0,0,135,0,0,129,2,40,0,0,168,136,136,152,136,136,55,0,167,136,136,136,8,40,0,0,0,0,0,0,0,0,56,0,135,0,0,178,2,40,0,0,0,55,0,0,0,0,56,0,134,0,185,169,2,40,0,0,0,57,0,0,0,95,56,0,134,0,0,0,8,40,0,0,0,0,0,0,0,79,57,0,135,0,0,0,8,40,0,0,0,0,0,0,152,136,136,136,167,183,0,0,8,40,0,0,7,39,0,0,0,0,0,0,135,0,0,0,8,40,0,137,8,40,0,0,0,0,0,0,134,0,0,0,8,40,0,0,8,0,39,0,0,0,0,1,23,39,0,0,8,40,0,137,9,0,0,39,0,0,129,2,18,40,0,0,8,40,0,0,0,8,0,41,0,0,178,2,0,40,0,0,8,40,0,0,95,8,40,0,0,0,95,2,0,40,0,0,8,40,0,0,0,8,40,136,136,152,136,9,25,41,0,0,8,40,0,0,137,9,41,0,0,0,0,0,135,0,0,0,8,40,0,0,0,0,134,0,0,0,0,0,152,0,0,0,8,40,0,0,0,0,134,0,0,0,0,0,0,0,0,0,8,40,0,0,0,0,55,0,0,0,0,0,0,0,0,79,8,40,0,0,0,0,57,0,0,0,0,0,0,0,0,0,8,40,0,0,0,0,135,0,0,95,55,0,0,0,7,23,0,40,0,0,0,0,134,0,137,137,56,137,137,7,0,0,0,40,0,0,0,0,134,0,0,137,57,0,137,8,0,0,0,40,0,0,0,0,135,55,0,0,0,0,0,8,0,0,0,40,0,0,0,0,168,56,0,0,0,105,121,8,0,0,0,40,0,0,0,153,169,56,136,152,0,116,0,8,0,0,0,40,136,182,0,0,95,56,0,0,0,107,123,8,0,0,0,40,0,135,0,185,169,57,0,0,0,0,0,8,0,0,0,40,0,135,0,0,0,0,0,95,55,0,137,8,0,0,0,40,0,167,136,152,182,0,0,137,56,137,137,9,0,0,0,40,0,135,0,0,135,0,0,137,57,0,0,0,9,25,0,40,136,184,0,0,135,0,0,0,0,0,0,0,134,0,8,40,0,0,0,0,55,0,0,0,0,0,0,0,135,79,8,40,0,0,0,0,56,0,0,0,166,136,136,136,152,0,8,40,0,128,1,17,40,0,0,0,134,0,0,0,135,0,8,40,0,145,2,18,0,39,0,0,152,0,0,0,135,0,8,40,136,136,2,0,0,40,182,0,0,0,0,0,7,23,0,40,0,144,2,0,0,41,135,0,0,0,0,7,0,0,0,40,0,0,2,0,41,0,135,0,0,0,95,8,0,0,0,40,0,95,9,40,0,0,134,0,0,0,0,9,0,0,0,40,0,0,0,56,0,0,135,0,0,0,0,0,9,0,0,40,136,136,136,56,0,0,135,0,0,0,0,0,0,9,0,40,0,0,95,56,136,136,167,136,183,0,0,0,0,0,8,40,0,0,0,57,0,0,135,0,0,0,0,0,0,0,8,40,0,0,0,0,0,0,168,136,136,136,136,182,0,0,8,40,0,0,0,0,0,0,0,0,0,0,0,135,0,79,8,40,0,0,0,0,0,0,0,0,0,0,7,23,23,23,0,40,0,0,0,95,7,39,0,0,0,0,8,0,0,0,0,40,0,0,0,0,8,40,0,0,0,95,8,0,0,0,0,40,136,182,0,0,8,41,136,152,136,136,8,0,18,0,0,40,0,168,136,7,40,0,0,0,0,0,9,19,19,19,0,40,0,0,0,8,0,39,0,0,0,0,0,0,0,0,2,40,0,0,95,8,0,41,0,0,0,0,0,0,0,79,8,40,0,0,0,9,41,0,0,0,0,0,0,0,0,137,2,40,0,0,0,0,135,0,0,0,0,55,16,32,0,137,2,40,0,0,0,0,134,0,0,0,79,56,0,0,0,128,2,40,0,152,136,136,167,136,136,136,136,56,32,0,137,137,8,40,0,0,0,0,135,0,0,95,7,40,0,0,0,144,2,40,0,0,0,0,135,0,0,0,8,40,16,32,0,95,8,",
}

lightning = {}

foregroundFoliage = {128,130,144,146,160,161,177,178}
endScreenMessages = {"get rekt!","git gud!","next time","is it too difficult?","are you gonna cry","it was the lag!"}
menuitem(1, "forge runes", function() toggle_rune_scene() sfx(10) end)
menuitem(2, "toggle music", function() toggle_music() sfx(10) end)

function toggle_rune_scene()

	global.runeScene = not global.runeScene
end
function toggle_music()
	global.music = not global.music
	if global.music then
		music(0)
	else
		music(-1,300)
	end
end



function parseMap(_mapString)
	local mapString = _mapString
	local actualMap = {}
	local actualToken = ""
	while #mapString > 0 do
		local firstToken = sub(mapString,1,1)
		local cut = 2
		if (firstToken != ",") then
			local workString = sub(mapString,2)
			local secondToken = sub(workString,1,1)
			if (secondToken != ",") then
				local workString = sub(mapString,3)
				local thirdToken = sub(workString,1,1)
				if (thirdToken != ",") then
					local actualToken = firstToken..secondToken..thirdToken
					add(actualMap,actualToken)
					cut = 4
				else
					local actualToken = firstToken..secondToken
					add(actualMap,actualToken)
					cut = 3
				end
			else
				add(actualMap,firstToken)
				cut = 2
			end
		end
		mapString = sub(mapString,cut)
	end
	return actualMap
end

function load_map(_index)
	director.levelType += 1
	if director.levelType > 3 then
		director.levelType = 0
	end

	director.difficulty += 1
	director.difficulty = director.difficulty * 1 + (flr(director.level/2))
	director.cost *= director.difficulty

	director.levelSpawnPoints = {}
	director.teleporterActivated = false
	director.telerporterStatus = 0
	director.levelCleared = false

	for x=0,64 do
		for y=0,15 do
			mset(x,y,0)
		end
	end
	mapString = parseMap(mapContainer[_index])
	x = 0
	y = 0
	for id in all(mapString) do
		id = tonum(id)
		
		--walls
		if ((0<=id) and (id <= 64)) then
			if ((1<=id) and (id<=12)) then
				local point = {
					xPos = y,
					yPos = x-1
				}
 				add(director.levelSpawnPoints,point)
 			end
			mset(y,x,id)
		end

		-- containers
		if (id == 95) then
			repeat
				rng = rnd()
				rngOfSpawn = rnd()
				if rngOfSpawn > 0.7 then
					if rng > 0.9 then
						-- large chest
						add_container(y,x,director.cost*2,2)
						director.chestOnStage = 1
					elseif ( 0.6 < rng) and (rng <= 0.9) then
						local rng2 = rnd()
						if rng2 > 0.5 then
							--shiren
							add_container(y,x,flr(director.cost/5),3)
							director.chestOnStage = 1
						else
							-- small chest
							add_container(y,x,director.cost,1)
							director.chestOnStage = 1
						end
					else
						-- vase
						add_container(y,x,flr(-director.cost/5),0)
						director.chestOnStage = 1
					end
				end
			until (director.chestOnStage != 0)
		end


		if id == 116 then
			-- portal
			add_container(y,x,0,4)
			director.teleporterPosition = {
				x = y*8,
				y = x*8
			}
		end


		for foliageID in all(foregroundFoliage) do
			if id == foliageID then
				add_foliage(y,x,id)
			elseif (id != 0) then
				mset(y,x,id)
			end
		end

		if (id == 95) then
			mset(y,x,0)
		end

		if (id == 79) then
			mset(y,x,0)
			add_bouncer(y,x)
		end

		x+=1
		if (x > 15) then
			x = 0
			y+=1
		end
	end
	local rndPoint = director.levelSpawnPoints[(flr(rnd(#director.levelSpawnPoints)+1))]
	player.x = rndPoint.xPos*8
	player.y = rndPoint.yPos*8
	-- 3 seconds to finish transition
	-- so for 3 seconds we need to add 6
	levelEntered = time() + 5
end

function _init()
	--code()
	music(0)
end

function unload_map()
	for x=0,64 do
		for y=0,15 do
			mset(x,y,0)
		end
	end

	castedSpells = {}
	particles = {}
	containers = {}
	enemies = {}
	enemyProjectiles = {}
	foliage = {}
	bouncers = {}

	player.ax = 0
	player.ay = 0
	player.life = player.maxLife
	player.souls = 0
	player.isGrounded = false
	player.isFlipped = false

	director.usedCredits = 0

end

function init_game()
	-- FIXME change on balance update
	player.maxLife = 100
	player.life = player.maxLife
	player.ax = 0
	player.ay = 0
	player.isGrounded = false
	player.isFlipped = false

	player.isCastingSpell = false
	player.souls = 0
	player.runesForged = {0,0,0,0,0,0}
	player.runes = 0
	player.equippedCd = 0
	player.invCd = 0
	player.level = 1
	player.spellEquipped = 0
	player.spellInInventory = 0

	castedSpells = {}
	particles = {}
	containers = {}
	enemies = {}
	enemyProjectiles = {}
	foliage = {}
	bouncers = {}

 	-- FIXME change on balance update
 	director.level = 1
	director.levelSpawnPoints = {}
	director.levelCleared = false
	director.levelType = 0
	director.cost = 10
	director.chestOnStage = 0
	director.usedCredits = 0
	director.maxCredit = 20

	director.ticks = 0
	director.secs = 0
	director.mins = 0
	levelIndex = flr(rnd(director.level+1) + 1 + 2*(director.level-1)) 
	director.mapName = mapNames[levelIndex]
	load_map(levelIndex)

end

function add_spell(_x,_y,_dir,_maxAge,_type,_playerSpeed)
	-- 0 fireball, 1 firelance, 2 wall, 3 heal, 4 speed
	local dmg = 0
	local speed = 0
	local spell = {
		x = _x,
		y = _y,
		lifeTime = _maxAge,
		maxAge = _maxAge,
		tpe = _type,
		damage = 0,
		speed = 0,
		pierced = 0,
	}

	if spell.tpe == 0 then
		--basic shoot
		dmg = 3
		speed = (2 * _dir) + _playerSpeed 
	elseif spell.tpe == 1 then
		-- firelance
		dmg = 5
		speed = (2 * _dir) + _playerSpeed 
	end

	spell.damage = dmg
	spell.speed = speed
	if (spell.tpe == 5) or (spell.tpe == 2) or (spell.tpe == 4) then
		spell.speed = 0
		spell.lifeTime = 300
	end
	add(castedSpells,spell)
end 

function add_particle(_x,_y,_maxAge,_color,_type,_goal)
	local goal = _goal
	if goal == nil then
		goal = {
			x = 0,
			y = 0
		}
	end

	local part = {
		x = _x,
		y = _y,
		lifeTime = 0,
		maxAge = _maxAge,
		tpe = _type,
		color_range = _color,
		clr = _color[1],
		dest = {
			x = goal.x,
			y = goal.y
		}
	}
	add(particles,part)
end

function add_container(_x,_y,_cost,_tpe)
	local sprite = 0
	local container = {
		x = _x *8,
		y = _y*8,
		cost = _cost,
		tpe = _tpe,
		isOpened = false,
	 	spr = 0,
	 	drops = 1
	}
	if _tpe == 0 then
		-- vase
		sprite = 111
	elseif _tpe == 1 then
		-- small chest
		sprite = 110
	elseif _tpe == 2 then
		--big chest
		sprite = 109		
	elseif _tpe == 3 then
		-- shrine
		sprite = 92
		container.drops = 2
	elseif _tpe == 4 then
		-- portal
		sprite = 116
	end
	container.spr = sprite
	add(containers,container)
end

function add_foliage(_x,_y,_spr)
	local fol = {
		x = _x*8,
		y = _y*8,
		spr = _spr
	}
	add(foliage,fol)
end

--[[
0 - slime
1 - shroom
2 - Treant
3 - Guard
4 - Skeleton
5 - Ghost
6 - Test Subject
7 - Tank
8 - Drone
]]--


function add_enemy(_x,_y,_tpe,_warp)
	local _spawnedIn = time()
	local stats = {
		maxHp = {20,40,80,100,50,40,40,120,40},
		speed = {0.5,0.5,0.25,0.25,0.5,0.5,1,0.25,0.5},
		maxSpeed = {2,2,1.6,1.6,2.5,2,5,1.6,2.5},
		aggroRange = {80,80,80,80,90,80,60,80,90},
		attackRange = {0,60,0,0,50,0,0,40,60},
		attackSpeed = {1.5,1.5,0.8,0.8,1.5,1.5,0.8,2,1.5},
		damage = {5,1,10,10,2,8,20,5,4},
		souls = {1,2,3,4,5,4,4,6,4},
		spr = {192,194,224,197,199,201,204,206,222}
	}

	local enemy = {
		x = _x*8,
		y = _y*8,
		ax = 0,
		ay = 0,
		tpe = _tpe,
		warp = _warp,
		maxHp = stats.maxHp[_tpe+1] + (2*director.difficulty),
		hp = stats.maxHp[_tpe+1],
		speed = stats.speed[_tpe+1],
		maxSpeed = stats.maxSpeed[_tpe+1],
		aggroRange = stats.aggroRange[_tpe+1],
		attackRange = stats.attackRange[_tpe+1],
		attackSpeed = stats.attackSpeed[_tpe+1],
		nextAttack = 0,
		damage = stats.damage[_tpe+1] + (2*director.difficulty),
		souls = stats.souls[_tpe+1] + (2*director.difficulty),
		spr = stats.spr[_tpe+1],
		isGrounded = false,
		maxFall = 5,
		spawnedIn = _spawnedIn,
		pierced = false,
		--ja, mert screen cap, nem csak pico-8
		nextPossiblePierce = 0,
		burningStart = 0,
		nextBurnTick = 0,
		isBurning = false,
		damageEnd = 0,
		stunEnd = 0,
		inSaw = false,
		nextSawTick = 0,
		sawStart = 0,
		lightning = false
	}
	add(enemies,enemy)
end

function add_enemy_projectile(_x,_y,_damage,_speed,_goal,_tpe,_spr)
	local point = {
		x = 0,
		y = 0
	}
	if not (_goal == nil) then
		point = _goal
	end

	local proj = {
		x = _x,
		y = _y,
		damage = _damage,
		goal = point,
		tpe = _tpe,
		speed = _speed,
		lifeTime = abs(_speed)*300,
		spr = _spr
	}

	if (_tpe == 2) or (_tpe == 3) then
		proj.lifeTime = 90
	end
	add(enemyProjectiles,proj)
end

function add_bouncer(_x,_y)
	local bounce = {
		x = _x*8,
		y = _y*8+7
	}
	add(bouncers,bounce)
end


function add_pickup(_x,_y,_tpe)
	--[[
	0 - fireball
	1 - lance
	2 - spark
	3 - lighning
	4 - sawblade
	5 - mines
	6 - walls
	7 - health
	8 - speed
	9 - runeShard
	]]--
	local pickup = {
		x = _x,
		y = _y,
		tpe = _tpe,
		pickupCooldown = time() + 1.5
	}
	add(pickups,pickup)
end


function spawn_enemy()
	local spawnRng = rnd()
	if spawnRng > 0.8 then
		local spawn = rnd()
		local cost = 0
		local typeID
		-- level 1 -> enemies 0,1,2
		-- level 2 -> enemies 3,4,5
		-- level 3 -> enemies 6,7,8
		-- level 4 -> enemies dunno yet
		-- choose what to spawn
		if spawn > 0.8 then
			typeID = 2 + ((director.levelType-1)*3)
		elseif (0.4 < spawn) and (spawn <= 0.8) then
			typeID = 1 + ((director.levelType-1)*3)
		else
			typeID = 0 + ((director.levelType-1)*3)
		end

		--set the price
		cost = director.enemyCredits[typeID+1]
		-- try to spawn
		if not (director.usedCredits+cost > director.maxCredit) then
			local spawnPoint = director.levelSpawnPoints[flr(rnd(#director.levelSpawnPoints)+1)]
			add_particle(spawnPoint.xPos*8+4,spawnPoint.yPos*8+4,60,{8,2},5)
			add_particle(spawnPoint.xPos*8+4,spawnPoint.yPos*8+4,30,{8,2},5)
			add_enemy(spawnPoint.xPos,spawnPoint.yPos,typeID,false)
			director.usedCredits += cost
		end
	end
end


function line_of_sight(x0,y0,x1,y1)

  local sx,sy,dx,dy

  x0 = flr(x0/8)
  x1 = flr(x1/8)
  y0 = flr(y0/8)
  y1 = flr(y1/8)



  if x0 < x1 then
    sx = 1
    dx = x1 - x0
  else
    sx = -1
    dx = x0 - x1
  end

  if y0 < y1 then
    sy = 1
    dy = y1 - y0
  else
    sy = -1
    dy = y0 - y1
  end

  local err, e2 = dx-dy, nil


  if (fget(mget(flr(x0), flr(y0)),0)) then return false end

  while not(x0 == x1 and y0 == y1) do
    e2 = err + err
    if e2 > -dy then
      err = err - dy
      x0  = x0 + sx
    end
    if e2 < dx then
      err = err + dx
      y0  = y0 + sy
    end

    if (fget(mget(flr(x0), flr(y0)),0)) then return false end
  end


  return true
end

function animate(object,starterFrame,frameCount,animSpeed,flipped)
	if(not object.tickCount) then
		object.tickCount=0
	end
	if(not object.spriteOffset) then
		object.spriteOffset=0
	end

	object.tickCount+=1

	if(object.tickCount%(30/animSpeed)==0) then
		object.spriteOffset+=1
		if (object.spriteOffset>=frameCount) then
		 	object.spriteOffset=0
		end
	end

	object.actualframe=starterFrame+object.spriteOffset

	if object.actualframe >= starterFrame+frameCount then
		object.actualframe = starterFrame
	end

	--printh(object.tpe)
	-- 3 is treant
	if (not (object.tpe == nil)) and (object.tpe == 2) then
		spr(object.actualframe,object.x,object.y,1,1,flipped)
		--printh("object.actualframe-16")
		spr(object.actualframe-16,object.x,object.y-8,1,1,flipped)
	else
		--("wabalabadubdub")
		spr(object.actualframe,object.x,object.y,1,1,flipped)
	end
end

function collide_rect(r1,r2)
	if ( (r1.x1 > r2.x2) or
		 (r2.x1 > r1.x2) or
		 (r1.y1 > r2.y2) or
		 (r2.y1 > r1.y2)) then
			return false
		end
		return true
end

function to_rect(x,y,h,w)
	local r = {
		x1 = x,
		x2 = x + w - 1,
		y1 = y,
		y2 = y + h - 1
	}
	return r
end

function collide_map(obj,width,heigth,dir,flag,speed)
	local x = obj.x
	local y = obj.y
	local w = width
	local h = heigth

	local x1 = 0
	local x2 = 0
	local y1 = 0
	local y2 = 0

	if dir==0 then --left
	   x1=x-1  y1=y+1
	   x2=x    y2=y+h-1

	elseif dir==1 then --rigth
	   x1=x+w    y1=y+1
	   x2=x+w  y2=y+h-1

	elseif dir==2 then --up
		x1=x+1    y1=y-1
		x2=x+w-2  y2=y

	elseif dir==3 then --down
		x1=x+1    y1=y+h
		x2=x+w-2    y2=y+h
	end


	crect.x1 = x1
	crect.x2 = x2
	crect.y1 = y1
	crect.y2 = y2

	x1/=8
	x2/=8
	y1/=8
	y2/=8

	if fget(mget(x1,y1), flag)
	or fget(mget(x1,y2), flag)
	or fget(mget(x2,y1), flag)
	or fget(mget(x2,y2), flag) then
	    return true
	else
	    return false
	end
end


function control_player()
	player.isCastingSpell = false
	global.pickupSpell = false
	global.buyContainer = false
	if btn(0) then
		player.ax -= player.acceleration
		player.isFlipped = true
	elseif btn(1) then 
		player.ax += player.acceleration
		player.isFlipped = false
	else
		player.ax = 0
	end
	if btn(2) and (player.isGrounded) then
		player.ay -= player.jumpForce
		sfx(1)
	end
	if btnp(4) then
		if player.equippedCd <= 0 then
			player.isCastingSpell = true
			local direction = 1
			--function add_spell(_x,_y,_dir,_maxAge,_type,_playerSpeed)
			if player.isFlipped then
				direction = -1
			end
			if not (player.spellEquipped == 3) then
				add_spell(player.x+(direction*16),player.y,sgn(direction),30,player.spellEquipped,player.ax)	
			else
				for enemy in all(enemies) do
					if abs(enemy.x - player.x < 60) then
						enemy.hp -= 5 + player.runesForged[4]
						sfx(3)
						enemy.stunEnd = time() + 2
						enemy.damageEnd = enemy.stunEnd
						enemy.lightning = true
					end
				end
			end
			player.equippedCd = player.spellCooldowns[player.spellEquipped+1] 
		end
	end
	if btnp(3) and global.onContainer then
		if global.onPickup then
			global.pickupSpell = true
		else
			global.buyContainer = true
		end
	end
	if btnp(5) then
		local switchero = player.spellEquipped
		local switcheroCd = player.equippedCd
		player.spellEquipped = player.spellInInventory
		player.spellInInventory = switchero
		player.equippedCd = player.invCd
		player.invCd = switcheroCd
	end

	-- check horizontal collision
	if player.ax > 0 then
		if collide_map(player,8,8,1,0) then
			player.ax = 0
		else
		--noramlize speed
			if player.ax > player.maxSpeed then
				player.ax = player.maxSpeed
			end
		end
	elseif player.ax < 0 then
		if collide_map(player,8,8,0,0) then
			player.ax = 0
		else
			if player.ax < -player.maxSpeed then
				player.ax = -player.maxSpeed
			end
		end
	end

	-- check vertical collision
	if player.ay >= 0 then
		player.isGrounded = false
		if collide_map(player,8,8,3,0) then
			player.isGrounded = true
			--player.spr = player.walk_spr
			player.ay = 0
			player.y-=(player.y+8)%8
		end
	elseif player.ay < 0 then
		--player.spr = player.jump_spr
		player.isGrounded = false
		if collide_map(player,8,8,2,0) then
			if not (collide_map(player,8,8,2,1)) then
				player.ay = 0
			end
		end
	end

	--normalize vertical speed
	if not (player.isGrounded) then
			player.ay += global.gravity
		if player.ay > player.maxFall then
			player.ay = player.maxFall
		end
	end

	player.x += player.ax
	player.y += player.ay



end

-- 0: menu, 1: gameplay, 2: endscreen, [3: help, 4: settings]
function _update ()
	if not (global.transition == true) then
		if global.state == 0 then
			update_menu()
		elseif global.state == 1 then
			update_game()
		elseif global.state == 2 then
			camera(0,0)
			update_end_screen()
		end
	end
end

function update_menu()
	if btnp(5) then
		print(control,64-(#control*2),40,9)
		-- enter the game
		global.state = 1
		global.transition = true
		global.trans.x = 0
		global.trans.y = 0
		sfx(0)
		init_game()
	end
end

function update_game()
	if not global.runeScene then
		director.ticks += 1
		if (director.ticks == 30) then
			director.secs += 1
			director.ticks = 0
			player.equippedCd -= 1
			player.invCd -= 1
		end

		if (director.secs == 60) then
			director.mins += 1
			director.secs = 0
		end

		-- TODO: Optimize this shit
		--printh("max: "..director.maxCredit.." min: "..director.usedCredits)
		if (director.maxCredit > director.usedCredits) then
			--printh("sanya")
			spawn_enemy()
		end

		if (player.nextRegenTick < time()) then
			if not (player.damageEnd > time()) then
				if player.life < player.maxLife then
					player.life += 1 + flr(0.5 * player.runesForged[2])
					if player.life > player.maxLife then
						player.life = player.maxLife
					end
					global.regen = time() + 0.8
					global.showRegen = true
				end
				player.nextRegenTick = time() + 2
			end
		end

		control_player()
		update_spells()
		update_particles()
		update_containers()
		update_enemies()
		update_enemy_projectiles()
		update_bouncers()
		update_pickup()

		if player.life <= 0 then
			-- set our state to endscreen

			global.state = 2
			global.endScreenMessage = endScreenMessages[flr(rnd(#endScreenMessages)+1)]
			global.transition = true
			global.trans.x = player.x-64
			global.trans.y = player.y-64
			--camera(0,0)
		end


		if director.teleporterActivated then
			local tm = director.teleporterEnds - time()
			if tm >= 45 then
				director.telerporterStatus = 0
			elseif (30 <= tm) and (tm < 45) then
				director.telerporterStatus = 1
			elseif (15 <= tm)  and (tm < 30) then	
				director.telerporterStatus = 2
			elseif tm == 0 then
				director.telerporterStatus = 3
			end
			printh(director.telerporterStatus)
		end
		if director.telerporterStatus >= 3 then
			player.runes += 4
			director.teleporterEnds = 0
			director.teleporterActivated = false
			director.levelCleared = true
			unload_map()
			director.level += 1
			local levelIndex = flr(rnd(director.level+1) + 1 + 2*(director.level-1))
			director.mapName = mapNames[levelIndex]
			global.transition = true
			global.trans.x = player.x-64
			global.trans.y = player.y-64
			load_map(levelIndex)
		end

	else
		if btnp(5) then
			global.runeScene = false
		end
		if btnp(3) then
			global.runeIndicator += 1
			if global.runeIndicator > 5 then
				global.runeIndicator = 0
			end
		end
		if btnp(2) then
			global.runeIndicator -= 1
			if global.runeIndicator < 0 then
				global.runeIndicator = 5
			end
		end
		if (btnp(4)) and (player.runes > 0) then
			player.runes -= 1
			player.runesForged[global.runeIndicator+1] = player.runesForged[global.runeIndicator+1]+1
			if global.runeIndicator == 0 then
				player.maxLife += flr(player.maxLife/15)
			elseif (global.runeIndicator == 3) then
				player.maxSpeed += 0.2
			end
		end
	end
end

function damage_player(damage,id)
	if (damage - player.runesForged[3] < 0) then
		damage = 0
	end
	if player.invFramesEnd < time() then
		player.life -= damage - player.runesForged[3]
		player.damageEnd = 0.2 + time()
		player.invFramesEnd = 0.2 + time()
		player.nextRegenTick = 1 + time()
		sfx(4)
	end
	if player.life <= 0 then
		player.killedBy = id
	end
end

function update_end_screen()
	if btnp(5) then
		-- enter the game
		global.state = 0
	end
end


function update_spells()
	for spell in all(castedSpells) do
		--printh(spell.pierced)
		spell.lifeTime -= 1
		if spell.lifeTime < 0 then
			del(castedSpells,spell)
		end
		local offset = -2
		-- add_particle(_x,_y,_maxAge,_color,_tpe)
		if spell.speed < 0 then
			offset = 10
		end
		if (spell.tpe == 0) or (spell.tpe == 1) then
			spell.x += spell.speed
			add_particle(spell.x+offset*(2*spell.tpe),spell.y+4-spell.tpe,5,{9,5},0)
			add_particle(spell.x+offset*(2*spell.tpe),spell.y+4+spell.tpe,5,{9,5},0)
		elseif (spell.tpe == 2) then
			local lifeOffset
			if abs(spell.x -player.x) < 64 then		
				for i=0,3 do
					if (i == 1 or i == 2) then lifeOffset = 0 else lifeOffset = 10 end
					if (rnd() > 0.7) then
						add_particle(spell.x+i*2+sin(rnd()),spell.y+8,flr(rnd(15)+5)-lifeOffset,{9,5},4)
					end
				end
			end
		end
		if (spell.speed > 0) and (not (spell.tpe == 1)) then
			if collide_map(spell,8,8,1,0) then
				del(castedSpells,spell)
			end
		else
			if collide_map(spell,8,8,0,0) then
				del(castedSpells,spell)
			end
		end
	end
end

function update_particles()
	for part in all(particles) do
		part.lifeTime += 1
		if part.lifeTime > part.maxAge then
			del(particles,part)
		end

		if part.tpe == 0 then
			-- tail particle
			part.y += cos(rnd(1))
		elseif part.tpe == 1 then
			-- aimed particle
			speedPerTick = 7
			deltaX = part.dest.x - part.x
			deltaY = part.dest.y - part.y
			goal = sqrt( (deltaX*deltaX) + (deltaY*deltaY))
			if goal > speedPerTick then
				ratio = speedPerTick / goal
			    xMove = ratio * deltaX  
			    yMove = ratio * deltaY
			    newXPos = xMove + part.x  
			    newYPos = yMove + part.y
			else
				player.souls += 1
				del(particles,part)
			end
			part.x = newXPos+sin(rnd(1))
			part.y = newYPos+cos(rnd(1))
		elseif part.tpe == 2 then
			-- explosion pixel
			part.x = part.x + sin(rnd())
			part.y = part.y + sin(rnd())
		elseif (part.tpe == 4)  then
			part.y -= abs(sin(rnd()))
		end
		if not (part.tpe == 1) then
			local idx = part.lifeTime / part.maxAge
			idx = 1 + flr(idx*#part.color_range)
			part.clr = part.color_range[idx]
		end
	end
end

function update_containers()
	local steppedOn = false
	for container in all(containers) do
		local offset = 0
		if (container.tpe == 4) then
			offset = 8
		end
		if collide_rect(to_rect(player.x,player.y,8,8),
			to_rect(container.x,container.y+offset,8,8)) then
			steppedOn = true
			if global.buyContainer == true then
				if container.tpe == 0 then
					-- add souls
					-- add_particle(_x,_y,_maxAge,_color,_type,_goal)
					local goal = {
						x = player.x-60,
						y = player.y-60
					}
					for i=1,abs(container.cost) do
						add_particle(container.x,container.y,1000,{9},1,goal)
					end
					global.buyContainer = false
					mset(container.x/8,container.y/8,container.spr+16)
					del(containers,container)
				elseif (container.tpe == 4) and (not teleporterActivated) then
					director.teleporterActivated = true
					director.teleporterEnds = time() + 60
					director.maxCredit = director.maxCredit*2
					global.buyContainer = false
					director.teleporterPosition = {
						x = container.x,
						y = container.y
					}
					mset(container.x/8,container.y/8,0)
					del(containers,container)
				elseif player.souls >= container.cost then
					container.drops -= 1
					global.buyContainer = false
					player.souls -= container.cost
					if container.drops <= 0 then
						add_pickup(container.x,container.y,flr(rnd(6)+1))
						mset(container.x/8,container.y/8,container.spr+16)
						del(containers,container)
						global.buyContainer = false
					else
						container.cost *= 2
						container.spr += 16
						global.buyContainer = false
						if rnd(1) > 0.5 then
							add_pickup(container.x,container.y,flr(rnd(6)+1)) 
						end
					end
				end
			end

			
			global.containerText = tostr(container.cost)
			global.textPoint = {
				x = container.x+4,
				y = container.y - 8
			}
			if container.cost < 0 then
				global.containerText = "break"
			end
			if container.tpe == 4 then
				global.containerText = "initiate time rift"
			end
		end
	end
	global.onContainer = steppedOn
	--printh(steppedOn)
end

function update_enemies()
	local t = time()
	local goal = {
		x = player.x-60,
		y = player.y-60
	}

	local delta = 0.1
	for enemy in all(enemies) do
		if enemy.nextPossiblePierce < t then
			enemy.pierced = false
		end

		if enemy.spawnedIn < t then
			--printh(enemy.hp)
			if enemy.hp <= 0 then
				for i=1,abs(enemy.souls) do
					add_particle(enemy.x,enemy.y,1000,{9},1,goal)
					if (rnd() < 0.005) then
						add_pickup(enemy.x,enemy.y,6)
					end
				end
				local cost = enemy.tpe
				director.usedCredits-=director.enemyCredits[enemy.tpe+1]
				
				if (rnd(1) > 0.7) and (director.teleporterActivated) then
					local gear = {
						x = enemy.x,
						y = enemy.y
					}
					if (rnd() < 0.01) then
						add_pickup(enemy.x,enemy.y,6)
					end
				end
				
				player.kills += 1
				del(enemies,enemy)
			end
			if (abs(player.x - enemy.x) < enemy.aggroRange) then
				if (enemy.tpe == 0) or (enemy.tpe == 1) or (enemy.tpe == 2) 
									or (enemy.tpe == 3) or (enemy.tpe == 4)
									or (enemy.tpe == 6) or (enemy.tpe == 7) then
					-- bascic movement
					if (enemy.tpe == 1) or (enemy.tpe == 4) or (enemy.tpe == 7) then
					-- ranged attack
						local projID = 196
						local projType = 1
						local speed = abs(flr(enemy.maxSpeed*1.2))
						if (enemy.tpe == 4) or (enemy.tpe == 7) then 
							projID = 203;
							if (enemy.tpe == 7) then projID = 221; projType = 3; end
							projType = 2; 
							speed = enemy.maxSpeed*1.2*sgn(enemy.ax) 
						end
						deltaX = player.x - enemy.x
						deltaY = player.y - enemy.y

						if ((enemy.attackRange > sqrt( (deltaX*deltaX) + (deltaY*deltaY)) and 
									( line_of_sight(player.x,player.y,enemy.x,enemy.y)))) then
							
							if (time() > enemy.nextAttack) and (not (enemy.stunEnd > time()))  then
								local goal = {
									x = player.x,
									y = player.y
								}
								--add_enemy_projectile(_x,_y,_damage,_speed,_goal,_tpe)
								add_enemy_projectile(enemy.x,enemy.y,enemy.damage,speed,goal,projType,projID)
								enemy.nextAttack = time() + enemy.attackSpeed
							end
						end
					end
					enemy.ax = 0
					if player.x < enemy.x then
						if player.x > enemy.x - enemy.aggroRange then
							enemy.ax -= enemy.speed
							if collide_map(enemy,8,8,0,0) then
								enemy.ax = 0
								if enemy.isGrounded then
									enemy.ay -= 4.5
									enemy.isGrounded = false
								end
							end
							if enemy.tpe == 2 then
								local upperPart = {
									x = enemy.x,
									y = enemy.y - 8
								}
								if collide_map(upperPart,8,8,0,0) then
									enemy.ax = 0
									if enemy.isGrounded then
										enemy.ay -= 4.5
										enemy.isGrounded = false
									end
								end
							end
						end
					elseif player.x > enemy.x then
						if player.x < enemy.x + enemy.aggroRange then
							enemy.ax += enemy.speed
							if collide_map(enemy,8,8,1,0) then
								enemy.ax = 0
								if enemy.isGrounded then
									enemy.ay -= 4.5
									enemy.isGrounded = false
								end
							end
							if enemy.tpe == 2 then
							-- 2 tall enemy code
								local upperPart = {
									x = enemy.x,
									y = enemy.y - 8
								}
								if collide_map(upperPart,8,8,1,0) then
									enemy.ax = 0
									if enemy.isGrounded then
										enemy.ay -= 4.5
										enemy.isGrounded = false
									end
								end
							end
						end
					else
						enemy.ax = 0
					end
					-- melee attack damage
					if (enemy.tpe == 0) or (enemy.tpe == 2) or 
						(enemy.tpe == 3) or (enemy.tpe == 6) then
						if collide_rect(to_rect(enemy.x,enemy.y,8,8),to_rect(player.x,player.y,8,8)) and (time() > enemy.nextAttack) and (not (enemy.stunEnd > time())) then
							damage_player(enemy.damage,enemy.tpe)
							enemy.nextAttack = time() + enemy.attackSpeed
							-- destroy test-subject after explosion
							
							if (enemy.tpe == 6) then
								for i=1,10 do
									add_particle(enemy.x+4,enemy.y+4,40,{8,5},2)
								end
								sfx(3)
								del(enemies,enemy)
							end
						end
					end

				end
				-- ghost
				if (enemy.tpe == 5) or (enemy.tpe == 8) then
					if not (((player.x > enemy.x) and (player.isFlipped)) or
						((player.x < enemy.x) and (not player.isFlipped))) then
						-- movement code
						-- moce only when player faces other direction
						deltaX = player.x - enemy.x
						deltaY = player.y - enemy.y
					
						goal = sqrt( (deltaX*deltaX) + (deltaY*deltaY))

						if goal > enemy.speed then
							ratio = enemy.speed / goal
						    xMove = ratio * deltaX  
						    yMove = ratio * deltaY
						    newXPos = xMove + enemy.x  
						    newYPos = yMove + enemy.y

							enemy.x = newXPos
							enemy.y = newYPos
						end
						if (enemy.tpe == 8) then
							-- drone
							local projID = 221
							local projType = 4
							local speed = enemy.maxSpeed*1.2*sgn(enemy.ax)
							-- if the player is to the left of the enemy
							-- if so set the speed to negative
							speed = speed * sgn(player.x - enemy.x)
					
							deltaX = player.x - enemy.x
							deltaY = player.y - enemy.y
							if ((enemy.attackRange > sqrt( (deltaX*deltaX) + (deltaY*deltaY)) and 
										( line_of_sight(player.x,player.y,enemy.x,enemy.y)))) then
								if (time() > enemy.nextAttack) and (not enemy.stunEnd > time())  then
									local goal = {
										x = player.x,
										y = player.y
									}
									--add_enemy_projectile(_x,_y,_damage,_speed,_goal,_tpe)
									add_enemy_projectile(enemy.x,enemy.y,enemy.damage,speed,goal,projType,projID)
									enemy.nextAttack = time() + enemy.attackSpeed
								end
							end
						end
					end
					if (enemy.tpe == 5) then
						if collide_rect(to_rect(enemy.x,enemy.y,8,8),to_rect(player.x,player.y,8,8)) and (time() > enemy.nextAttack) and (not (enemy.stunEnd > time())) then
							enemy.nextAttack = time() + enemy.attackSpeed
							damage_player(enemy.damage,enemy.tpe)
						end
					end
				end

				-- check vertical collision if not ghost
				if not ((enemy.tpe == 5) or (enemy.tpe == 8)) then
					if enemy.ay >= 0 then
						enemy.isGrounded = false
						if collide_map(enemy,8,8,3,0) then
							enemy.isGrounded = true
							--enemy.spr = enemy.walk_spr
							enemy.ay = 0
							enemy.y-=(enemy.y+8)%8
						end
					elseif enemy.ay < 0 then
						--enemy.spr = enemy.jump_spr
						enemy.isGrounded = false
						if collide_map(enemy,8,8,2,0) then
							if not (collide_map(enemy,8,8,2,1)) then
								enemy.ay = 0
							end
						end
					end

					--normalize vertical speed
					if not (enemy.isGrounded) then
							enemy.ay += global.gravity
						if enemy.ay > enemy.maxFall then
							enemy.ay = enemy.maxFall
						end
					end
				end

				if (enemy.ax < 0) and (enemy.x - enemy.ax < player.x) then
					enemy.ax = 0
				elseif (enemy.ax > 0) and (enemy.x + enemy.ax > player.x+8) then
					enemy.ax = 0
				end

				-- bouncers
				if not (#bouncers == 0) then
					local force = 6
					for bouncer in all(bouncers) do
						if collide_rect(to_rect(enemy.x,enemy.y,8,8),
										to_rect(bouncer.x,bouncer.y,8,8)) then
							-- upward momemntum check
							if not (enemy.ay < 0) then
								enemy.ay = 0
								enemy.ay -= force
							end
						end
					end
				end

				--spell collision 
				if not (#castedSpells == 0) then
					for spell in all(castedSpells) do
						if collide_rect(to_rect(enemy.x,enemy.y,8,8),to_rect(spell.x,spell.y,8,8)) then
							if (spell.tpe == 0) or (spell.tpe == 1) or (spell.tpe == 5) then
							 	for i=1,10 do
							 		add_particle(spell.x+4,spell.y+4,40,{9,5},2)
							 	end

							 	if (spell.tpe == 1) and (not enemy.pierced) then
							 		enemy.pierced = true
							 		enemy.nextPossiblePierce = t + 1
							 		spell.pierced += 1
							 		enemy.hp -= spell.damage
							 		sfx(2)
							 		if spell.pierced >= 5 then
							 			del(castedSpells,spell)
							 		end

							 	elseif (spell.tpe == 0)  or (spell.tpe == 5) then
									enemy.hp -= spell.damage
									sfx(2)
									del(castedSpells,spell)
								end
								enemy.stunEnd = time() + 0.2
								enemy.damageEnd = enemy.stunEnd
							elseif (spell.tpe == 2) then
								enemy.isBurning = true
								enemy.burningStart = t + 3
								enemy.nextBurnTick = 15
							elseif (spell.tpe == 4) then
								enemy.inSaw = true
								enemy.sawStart = t + 0.5
								enemy.nextSawTick = 0
							end
						end 
					end
				end


				if ((enemy.isBurning) or (enemy.inSaw)) then
					enemy.ax = enemy.speed * 0.8 * sgn(enemy.ax)
					if enemy.isBurning then
						enemy.nextBurnTick -= 1
						local lifeOffset
						if abs(enemy.x -player.x) < 64 then		
							for i=0,3 do
								if (i == 1 or i == 2) then lifeOffset = 0 else lifeOffset = 10 end
								if (rnd() > 0.7) then
									add_particle(enemy.x+i*2+sin(rnd()),enemy.y-1,flr(rnd(15)+5)-lifeOffset,{9,5},4)
								end
							end
						end
						if enemy.nextBurnTick < 0 then
							enemy.hp -= 4 + player.runesForged[4]
							sfx(2)
							enemy.nextBurnTick = 15
							enemy.stunEnd = time() + 0.1
							enemy.damageEnd = enemy.stunEnd
						end
					end
					if enemy.inSaw then
						enemy.nextSawTick -= 1
						if enemy.nextSawTick < 0 then
							enemy.hp -= 1 + player.runesForged[4]
							sfx(2)
							enemy.nextSawTick = 7
							enemy.damageEnd = time() + 0.5
						end
					end
					
				end

				if enemy.burningStart < time() then
					enemy.isBurning = false
				end
				if enemy.sawStart < time() then
					enemy.inSaw = false
				end
				-- out of type move 

				if (enemy.stunEnd) < time() then
					enemy.x += enemy.ax
					enemy.y += enemy.ay
					enemy.lightning = false
				end
			end
		end
	end
end

function update_enemy_projectiles()
	for proj in all(enemyProjectiles) do
	
		proj.lifeTime -= 1
		if proj.lifeTime < 0 then
			del(enemyProjectiles,proj)
		end
		if proj.tpe == 1 then
			-- goal seeking
			deltaX = proj.goal.x - proj.x
			deltaY = proj.goal.y - proj.y
		
			goal = sqrt( (deltaX*deltaX) + (deltaY*deltaY))

			if goal > proj.speed then
				ratio = proj.speed / goal
			    xMove = ratio * deltaX  
			    yMove = ratio * deltaY
			    newXPos = xMove + proj.x  
			    newYPos = yMove + proj.y

				proj.x = newXPos
				proj.y = newYPos
			else
				del(enemyProjectiles,proj)
			end
		else
			proj.x += proj.speed
			if (proj.speed > 0) and collide_map(proj,8,8,1,0) then
				del(enemyProjectiles,proj)
			elseif  collide_map(proj,8,8,0,0) then
				del(enemyProjectiles,proj)
			end
		end
		if collide_rect(to_rect(proj.x,proj.y,8,8),to_rect(player.x,player.y,8,8)) then		
			local tpe
			if proj.tpe == 2 then
				tpe = 4
			elseif proj.tpe == 3 then
				tpe = 7
			else
				tpe = 8
			end
			damage_player(proj.damage,tpe)
			del(enemyProjectiles,proj)
		end
	end
end

function update_bouncers()
	local force = 8
	for bouncer in all(bouncers) do
		-- player collision
		if collide_rect(to_rect(player.x,player.y,8,8),
						to_rect(bouncer.x,bouncer.y,8,8)) then
			--check if we already have some upward momentum
			if not (player.ay < 0) then
				player.ay = 0
				player.ay -= force
			end
		end
		local lifeOffset

		if abs(bouncer.x -player.x) < 64 then		
			for i=0,3 do
				if (i == 1 or i == 2) then lifeOffset = 0 else lifeOffset = 10 end
				if (rnd() > 0.7) then
					add_particle(bouncer.x+i*2+1,bouncer.y,flr(rnd(25)+5)-lifeOffset,{6,5},4)
				end
			end
		end
	end
end

function update_pickup()
	local steppedOn = false
	for pickup in all(pickups) do
		if time() >= pickup.pickupCooldown + 10 then del(pickups,pickup) end
		if collide_rect(to_rect(pickup.x,pickup.y,8,8),
			to_rect(player.x,player.y,8,8)) then
			global.textPoint = {
					x = pickup.x,
					y = pickup.y-8
				}
			local texts = {"fireball","flamelance","spark","lighning","buzzsaw","arcane mine","rune shard"}
			global.containerText = texts[pickup.tpe+1]
			if pickup.tpe == 6 then
				player.runes += 1
				global.runePickupEnd = time() + 2
				del(pickups,pickup)
			else
				steppedOn = true
				if pickup.pickupCooldown < time() then
					global.onContainer = true
					if global.pickupSpell then
						if (pickup.tpe != 72) then
							player.spellEquipped = pickup.tpe
							del(pickups,pickup)
						elseif player.life < player.maxLife then
							del(pickups,pickup)
							player.life += 5
							if player.life > player.maxLife then
								player.life = player.maxLife
							end
						end
					end
				end
			end
		end
		global.pickupSpell = false
	end
	global.onPickup = steppedOn
end

-- 0: menu, 1: gameplay, 2: endscreen, [3: help, 4: settings]
function _draw()
	if not (global.transition) then
		if global.state == 0 then
			draw_menu()
		elseif global.state == 1 then
			draw_game()
		elseif global.state == 2 then
			draw_end_screen()
		end
	else
		draw_transition(global.trans.x,global.trans.y)
	end
end

function draw_menu()
	cls()
	map()
	title = "cLOCK mAGE"
	control = "press x to play"
	print(title,64-(#title*2),20,9)

	if (time()%1 > 0.5) then
		print(control,64-(#control*2),40,6)
	end
end

function draw_game()
	if not global.runeScene then
		cls()
		map()
		--[[
		
		]]--
		draw_spells()
		draw_particles()
		draw_containters()
		draw_enemies()
		draw_pickups()
		--draw_lightning()
		if player.damageEnd > time() then
			for i=1,100 do
				o1 = flr(rnd(0x1F00)) + 0x6040
				o2 = o1 + flr(rnd(0x4)-0x2)
				len = flr(rnd(0x40))

				memcpy(o1,o2,len)
			end
			pal(9,4)
		else
			pal()
		end

		if (player.ax == 0) then
			animate(player,65,4,10,player.isFlipped)
		else
			animate(player,69,2,15,player.isFlipped)
		end

		if player.isCastingSpell then
			spr(96,player.x+8,player.y,1,1,not player.isFlipped,false)
			if player.spellEquipped == 83 then
				rectfill(0,0,999,999,5)
			end
		end

		draw_enemy_projectile()
		draw_foliage()

		camera(player.x-64,player.y-64)
		draw_ui()
	else
		-- outer layer
		rectfill(player.x-45,player.y-45,player.x+45,player.y+45,9)
		rectfill(player.x-44,player.y-44,player.x+44,player.y+44,0)
		-- headline
		rectfill(player.x-45,player.y-35,player.x+45,player.y-35,9)
		print("rune shards: "..player.runes,player.x-42,player.y-42,6)

		--health
		print("blood rune:",player.x-32,player.y-32,6)
		spr(143,player.x-42,player.y-33)
		print(player.runesForged[1],player.x+30,player.y-32,9)
		--regen
		print("water rune:",player.x-32,player.y-24,6)
		spr(159,player.x-42,player.y-25)
		print(player.runesForged[2],player.x+30,player.y-24,9)
		--defense
		print("earth rune:",player.x-32,player.y-16,6)
		spr(175,player.x-42,player.y-17)
		print(player.runesForged[3],player.x+30,player.y-16,9)
		--speedBoost
		print("wind rune:",player.x-32,player.y-8,6)
		spr(191,player.x-42,player.y-9)
		print(player.runesForged[4],player.x+30,player.y-8,9)
		--damage
		print("thunder rune:",player.x-32,player.y,6)
		spr(142,player.x-42,player.y-1)
		print(player.runesForged[5],player.x+30,player.y,9)
		--attackspeed
		print("wave rune:",player.x-32,player.y+8,6)
		spr(158,player.x-42,player.y+7)
		print(player.runesForged[6],player.x+30,player.y+8,9)
		-- indicator
		spr(81,player.x+20,player.y-34+(global.runeIndicator*8))

		--instruction
		print("\151-exit",player.x+14,player.y+36,9)
		print("\142-forge",player.x-42,player.y+36,9)


	end
end

function draw_end_screen()
	cls()
	control = "press x to reborn"
	print(global.endScreenMessage,64-(#global.endScreenMessage*2),20,9)
	if ( time()%3 > 1) then
		print(control,64-#(control)*2,100,6)
	end


	print("stats",64-10,30,9)


	print("kill count: ",10,50,6)
	print(player.kills,90-#tostr(player.kills)*2,50,6)
	print("level reached: ",10,58,6)
	print(director.level,90-#tostr(player.kills)*2,58,6)
	print("time elapsed: ",10,66,6)
	print(director.mins..":"..director.secs,90-#tostr(player.kills)*2,66,6)
	print("killed by: ",10,74,6)
	local name = {"slime","shroom","trean","guard","skeleton","ghost","test-subject","security-tank","security-drone"}
	--check monster id
	name = name[player.killedBy+1]
	print(name,90-#tostr(name)*2,74,6)

	--[[
		killcount
		reached level
		time taken
		killed by: <enemy>

		+ damage
		+ vases broken
		+ chests open
		+ spell picked up
	]]--
end

function draw_spells()
	local flip = false
	for spell in all(castedSpells) do
		if spell.speed < 0 then
				flip = true
		end

		if spell.tpe == 0 then
			animate(spell,97,4,15,flip)
		elseif spell.tpe == 1 then
			local offset = -8
			if (flip == true) then offset = 8 end
 			spr(102,spell.x,spell.y,1,1,flip,false)
			spr(101,spell.x+offset,spell.y,1,1,flip,false)
		elseif spell.tpe == 5 then
			if (time()%1 > 0.5) then
				spr(85,spell.x,spell.y+1)
			end
		elseif spell.tpe == 4 then
			animate(spell,74,2,15,false)
		end
	end
end

function draw_particles()
	for part in all(particles) do
		if (part.tpe == 5) then
			circ(part.x,part.y,flr(part.lifeTime/6),part.clr)
		else
			pset(part.x,part.y,part.clr)
		end
	end

end

function draw_containters()
	for container in all(containers) do
		spr(container.spr,container.x, container.y)
	end
end

function draw_enemies()
	local animSpeed = 20
	for enemy in all(enemies) do
		if (enemy.spawnedIn < time()) then
			local flip = true
			-- check facing
			if (player.x < enemy.x) then
				flip = false
			end
				--rectfill(enemy.x,enemy.y,enemy.x+7,enemy.y+7,0)
			if enemy.tpe == 2 then animSpeed = 8 end
			if enemy.tpe == 0 then animSpeed = 20 end

			if (enemy.damageEnd > time()) then pal(8,2) end
			animate(enemy,enemy.spr,2,animSpeed,flip)
			pal()
			if enemy.lightning then
				spr(83,enemy.x,enemy.y-10+sin(rnd()))
			end
		end
	end
end

function draw_ui()

	local elapsedTime = director.mins..":"..director.secs
	-- border
	--rectfill(player.x-64,player.y-64,player.x+80,player.y-52,0)
	--rectfill(player.x-64,player.y-53,player.x+80,player.y-53,6)
	spr(113,player.x-64,player.y-64)
	print(":"..player.life.."/"..player.maxLife,player.x-57,player.y-62,9)
	-- regen
	if (global.regen > time()) then
		print("+"..(1 + flr(0.5 * player.runesForged[2])),player.x-20,player.y-62,9)
	end
	spr(112,player.x-64,player.y-52)
	print(":"..player.souls,player.x-57,player.y-50,9)

	spr(114,player.x+56,player.y-63)
	print(elapsedTime,player.x+46-(#elapsedTime*2),player.y-62,9)

	if global.onContainer then
		print(global.containerText,global.textPoint.x-(#global.containerText*2),
			global.textPoint.y,9)
	end
	--rect(crect.x1,crect.y1,crect.x2,crect.y2,10)

	--print(stat(1),player.x  - 62, player.y - 30, 9)


	-- level name display
	if levelEntered > time() then
		rectfill(player.x-(#director.mapName*2)-4,player.y - 34,player.x+(#director.mapName*2)+2,player.y - 22,6)
		rectfill(player.x-(#director.mapName*2)-3,player.y - 33,player.x+(#director.mapName*2)+1,player.y - 23,0)
		print(director.mapName,player.x-(#director.mapName*2),player.y - 30,9)
	end

	--- initation state display
	if (director.teleporterActivated) and (abs(player.x - director.teleporterPosition.x) < 64) and (abs(player.y - director.teleporterPosition.y) < 64) then
		spr(116 + director.telerporterStatus, director.teleporterPosition.x-(sin(rnd(1))), director.teleporterPosition.y-cos(rnd(1)))
		print(flr(director.teleporterEnds - time()),director.teleporterPosition.x,director.teleporterPosition.y-8)
	elseif (director.teleporterActivated) then
		rectfill(player.x-2,player.y - 64,player.x+9,player.y - 54,9)
		rectfill(player.x-1,player.y - 63,player.x+8,player.y - 55,0)
		print(flr(director.teleporterEnds - time()),player.x+1-sin(rnd()),player.y - 61,9)
	end
	-- spell slot draw
	-- left one
	rectfill(player.x-64,player.y + 52,player.x-53,player.y + 63,9)
	rectfill(player.x-63,player.y + 53,player.x-54,player.y + 62,0)
	spr(80+player.spellEquipped,player.x-62,player.y+54)
	if player.equippedCd > 0 then print(flr(player.equippedCd),player.x-58,player.y+46,9) end
	

	rectfill(player.x-52,player.y + 52,player.x-41,player.y + 63,5)
	rectfill(player.x-51,player.y + 53,player.x-42,player.y + 62,0)
	pal(9,5)
	spr(80+player.spellInInventory,player.x-50,player.y+54)
	if player.invCd > 0  then print(flr(player.invCd),player.x-46,player.y+46,9) end
	pal()

	--runePickupEnd
	if global.runePickupEnd > time() then
		local runeText = "rune shard +1"
		local runeInst = "enter to forge"
		print(runeText,player.x-(#runeText*2),player.y-24,9)
		print(runeInst,player.x-(#runeInst*2),player.y-16,9)
	end

end

function draw_foliage()

	for fol in all(foliage) do
		spr(fol.spr,fol.x,fol.y)
	end
end

function draw_enemy_projectile()
	local flip = false
	for proj in all(enemyProjectiles) do
		if (proj.tpe == 2) or (proj.tpe == 4) then
			if (proj.speed > 0) then
				flip = true
			end
			spr(proj.spr,proj.x,proj.y,1,1,flip,false)
		else
			spr(proj.spr,proj.x,proj.y)
		end
	end

end



function draw_transition(_x,_y)
	local dither = {…,░,▤,█}
	--0b0011001111001100
	--0b0001000100010001
	fillp(dither[global.transition_number+1])
	for i=1,16 do
		rectfill(_x,_y+global.transition_y*8,_x+i*8,_y+(global.transition_y+1)*8,0)	
	end
	global.transition_y+=1
	if (global.transition_y > 16) then
		global.transition_y = 0
		global.transition_number+=1
		if global.transition_number > 4 then
			global.transition = false
			global.transition_y = 0
			global.transition_number = 0
		end
	end
end

function draw_pickups()
	local sajt = {142,143,158,159,175,191}
	local spri = sajt[flr(rnd(6)+1)]
	for pickup in all(pickups) do
		if (pickup.tpe == 6) then
			
			printh(spri)
			printh("gecikura")
			spr(spri,pickup.x,pickup.y+(sin(rnd()))/10)
		else
			spr(80+pickup.tpe,pickup.x,pickup.y+(sin(rnd()))/10)
		end
	end
end

__gfx__
00000000066666666666666666666660666666666666666666666666666666666666666666666666666666666666666666666666000000000000000055050550
00000000606006006000060060006006600000000000000000000006606060606060606060606066600000000000000000000006000000000000000000000000
00700700600000060060000600600060666066060660660606606606660606060606060606060606600000000000000000000006000000000000000005505505
00077000060000000000000000000060600000000000000000000006606000000000000000000066600000000000000000000006000000000000000000000000
00077000060000000000000000000006660606606606066066060666660000000000000000000606600000000000000000000006000000000000000055050550
00700700600000000000000000000006600000000000000000000006606000000000000000000066600000000000000000000006000000000000000000000000
00000000606000000000000000000060666066060660660606606606660000000000000000000606600000000000000000000006000000000000000005505505
00000000600000000000000000000006600000000000000000000006606000000000000000000066600000000000000000000006000000000000000000000000
50000005600000000000000000000006660606606606066066060666660000000000000000000606600000000000000000000006000000000000000050505050
50000005600000000600000000000606600000000000000000000006606000000000000000000066600000000000000000000006000000000000000005050505
50000050606000000000000000000060666066060660660606606606660000000000000000000606600000000000000000000006000000000000000050000050
05000050060000000000006000000060600000000000000000000006606000000000000000000066600000000000000000000006000000000000000005000005
05000005060000000000000000000006660606606606066066060666660000000000000000000606600000000000000000000006000000000000000050000050
05000005060000000060000000000006600000000000000000000006606000000000000000000066600000000000000000000006000000000000000005000005
50000050606000000000000000000060660606060660660606606606660000000000000000000606600000000000000000000006000000000000000050505050
50000005600000000000000000000006600000000000000000000006606000000000000000000066600000000000000000000006000000000000000005050505
05050050600000000000000000000006660606606606066066060666660000000000000000000606600000000000000000000006000000000000000000000000
00505050600000000000000000000606600000000000000000000006606000000000000000000066600000000000000000000006000000000000000000000000
00500500600000000000000000000060666066060660660606606606660000000000000000000606600000000000000000000006000000000000000000000000
05050500060000000000000000000060600000000000000000000006606000000000000000000066600000000000000000000006000000000000000000000000
05005050060000000000000000000006660606606606066066060666660000000000000000000606600000000000000000000006000000000000000000000000
00005050606006006006006006006006600000000000000000000006606060606060606060606066600000000000000000000006000000000000000000000000
00000050600000000000000000000060666066060660660606606606660606060606060606060606600000000000000000000006000000000000000000000000
00000000066666666666666666666600666666666666666666666666666666666666666666666666666666666666666666666666000000000000000000000000
00000000066666666666666666666660666666666666666666666666666666666666666666666666666666666666666666666666000000000000000000000000
00000000606006006000060060006006600000000000000000000006606060606060606060606066600000000000000000000006000000000000000000000000
00000000600000060060000600600060666066060660660606606606660606060606060606060606600000000000000000000006000000000000000000000000
00000000060000000000000000000060600000000000000000000006606000000000000000000066600000000000000000000006000000000000000000000000
00000000060000000000000000000006660606606606066066060666660000000000000000000006600000000000000000000006000000000000000000000000
00000000600600000000060000000606600000000000000000000006606060606060606060606066600000000000000000000006000000000000000000000000
00000000600000000666000000000006666066060660660606606606660606060606060606060606600000000000000000000006000000000000000000000000
00000000066666666000666666666660666666666666666666666666666666666666666666666666666666666666666666666666000000000000000000000000
00000000009900000000000000000000000000000099000000000000000000000009990000000000909090900909090000000000990000999900009999000099
00000000000999000099000000000000009900000009990000000000000000000090009000000000009990009099909000000000900000099000000990099009
00000000009999900009990000999900000999000099999000999900009999000900900900990900990009900900090000000000009999000099990000999900
00000000000000000099999000999990009999900000000000999990009009000909990900000900090909009909099000000000009009000000000009099090
00000000000606000000000000000000000000000006060000000000009009000900900909990990990009900900090000000000009009000009900000099000
00000000000000000006060000060600000606000000000000060600000990000090009000000000009990009099909000000000000990000000000000099000
00000000000000000000000000000000000000000090000000000000000000000009990000000000909090900909090000000000900000099009900990099009
00000000009009000090090000900900009009000000090000099000000000000000000000000000000000000000000000000000990000999900009999000099
00000000000000000090000000000000909090900000000000000000000999000000000000000000000000000000000000000000000000000000000099000099
00000000000000000000900000090000009990009009900900000000009000900000000000000000000000000000000009000090000000000000000090000009
00099000909000900900909000990000990009900900009000999900090090090099090000000000000000000000000000099000000000000000000000099000
00900900090999990009090009999990090909000000000000900900090999090000090000000000000000000000000009099090000000000000000000999900
00909900909000900090090000009900990009900009900000900900090090090999099000000000000000000000000009000090000000000000000000999900
00099000000000000900909000099000009990000090090000099000009000900000000000000000000000000000000099900999000000000000000000099000
00000000000000000909009000090000909090900999999000000000000999000000000000000000000000000000000000000000000000000000000090000009
00000000000000000099090000000000000000000000000000000000000000000000000000000000000000000000000099999999000000000000000099000099
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000990000990000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005000050909999090000000000000000
00000000000990000009900000099000000990009090900000000090000000000000000000000000000000000000000000055000900990090000000000999900
00000000009009000090990000990900009009000909099999999909000000000000000000000990000000000990000009055090900990090990099009000090
00966000009099000090090000900900009909009090900000000090000000000000000000000990000000000990000009000090900000090909909000999900
00000000000990000009900000099000000990000000000000000000000000000000000000000000000000000000000099900999999999990909909009000090
00000000000000000000000000000000000000000000000000000000000000000000000000009900000000000099000000000000000000000000000009000090
00000000000000000000000000000000000000000000000000000000000000000000000000009900000000000099000099999999999999990999999000999900
00000000000000000009990000000000000555000005990000059900000599000000000000000000000000000000000000000000555555550000000000000000
00009900000000000090009009090900005000500050009000500090005000900000000000099990000000000999900005000050500000050000000000000000
00099000099099000900900900999000050050050500900905009009050090090000000000099990000000000999900000055000500000050000000000000000
00999000999990900900990909909900050055050500990905009909090099090000000000099990000000000999900005055050500000050555555000000000
09909900999900900900000900999000050000050500000505000009090000090000000000000000000000000000000005000050500000050500005000000000
09000900099009000090009009090900005000500050005000500090009000900000000009999990000000000999999055500555555555550500005005005000
09090900009090000009990000000000000555000005550000059900000999000000000000000090000000000900000000000000000000000000000005055505
00999000000900000000000000000000000000000000000000000000000000000000000099999990000000000999999955555555555555550555555000555555
00000000000000000000000000000550550000005505055000000000000000000005550055555555000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000050550005050050000000000000000000000000000000000090090009900990
00000000000000000000000000005505055055000550550555505555555555550005550000050050000000000000000000000000000000000000000000900900
00000000000000000000000000000000000000000000000055505555555555550050550000000050000000000000000000000000000000000099990000900900
00000000000000000000000000050550550500005505055005000505050505050005550000000050000000000000000000000000000000000090090000000000
00000000000000000600060000000000000000000000000050505050505050500050550000050050000000000000000000000000000000000090990000099000
00000060000000000000006005505505055055050550550500000000000000000005550050050050000000000000000000000000000000000090090000000000
00606060005005000600006000000000000000000000000000000000000000000055550055555555000000000000000000000000000000000000000000000000
00000000000000000000000055050550550505500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000066000000000000000000000000500005000000000000505555555000000000000000000000000000000000000000000090000009909900
00666000000000000066060005505505055055000000000005555555555555505050505000055000000000000000000000000000000000000090990009000900
06666600000000000000060000000000000000000005550005555555555555505050505000500500000000000000000000000000000000000090090009000900
66666660000550000006060000000550550500000000500005050505050005505050505005000050000000000000000000000000000000000999090009990000
60000060005555000006000000000000000000000000500005505050505050505555555005000050000000000000000000000000000000000090090000090900
00666000050000500006060000005505055000000000500005000000000000500000000005000050000000000000000000000000000000000000000000000000
00666000000550000006060000000000000000000000500000000000000000000000000005000050000000000000000000000000000000000000000000000000
00000000000000000000000000000005505000000000000000000000000000000000000005000050000000000000000000000000000000000000000000000000
00000000000000000000000000000005550500000000000000000000005055000000000005000050000000000000000000000000000000000000000000099000
00000000000000000000550000000050505000000000000000505550055555500555500005000050000000000000000000000000000000000000000000000000
00000000000000000505005000000505050505000000000000055550055555500555550005555550000000000000000000000000000000000000000000999000
00000000000000000050005000005050050550500000000000505550050555000505550050000005000000000000000000000000000000000000000000009000
00666000000060000050050000050505505005005555555000055550005555500050550050505505000000000000000000000000000000000000000000009000
06000600006060000050000000505005500550500505050000505500000555000005550050000005000000000000000000000000000000000000000000009000
00060000006060600005500055050550055005550505050000000000000000000000000055555555000000000000000000000000000000000000000000000000
00000000000000000660000055500550055005550000000000000000000555000000000000000000000000000000000000000000000000000000000000000000
00000000000000000660006005055005500550500000000000555500005055000055550000000000000000000000000000000000000000000000000000009090
05500000000000000000006000500505505005050000000000055550000555000555550000000000000000000000000000000000000000000000000000009090
50000550000000000606600005055050050550500000000000555550005055000555550000000000000000000000000000000000000000000000000000999090
50500005060006000606606000505050050500000000000000050500000555000050550000000000000000000000000000000000000000000000000000009000
00050505060606000600006000000505505050000000000000005050005055000505500000000000000000000000000000000000000000000000000009909000
00005000060006000600606000005055550500000000000000000000055555500000000000505000000000000000000000000000000000000000000000000000
00005000006060000600606000000505500000000000000000000000000000000000000005050550000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000088880008088880000000000000000000000000000000000088000000000000000000000000000
00000000008888000088880000000000000000000008888008008080080008080080888800808000000000000000000000888800000880000008888000088880
00000000080000800800008000000000000880000800808008088880080088880800080808888880008080000000000000088080008888008888088088880880
00000000808080088080800800888800008008000808888088800000888008000800888808080880088888800800080800800880000880800008888000088880
00888800800000088000000808000080008088008880000088088880080088808880080008888880080808808888808000088800008008800088888000888880
08000080088888808808808880808008000880008808888008000000008008000800888008080000088888800800080800000000000888000080808008080800
80808008000000000008800088000088000000000800000008000080000000800080000000000000080800000000000000000080000000008000000880000008
08888880000000000000000000088000000000000800880000008000000080000000088000000000000000000000000000080000000088000808080000808080
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088800008808800
08808800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000888080008000000080000
00000080088008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008008080088800000888000
08008080088000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000888080008800000088000
08080000000080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088800000888000
08080000080800800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000080000
00000000080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000088000000880000
08888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00808000088880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888000008080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00080000088880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08080800000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000080008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08008800008080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08000000008080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0001010101010101010101010101000000010101010101010101010101010000000101010101010101010101010100000001010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000005f00000000000000000000000000000000000000000000000000000000000000000000000000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000034353535360000000000000069746b0000000000005f0000000000000000000000000000000000005f0011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000140016000000343536000079007b00000000000005050000000000000000000000000000003435353511000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000001400168400930f930f840034353600000000001515151500000000000000000000000000000000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000001400160f0f840f930f9483830f8400000000930f84830f0f000000000000000000000000000000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000002425260f0f84000094830f0f0f0f8400000000930f0f940000000000000000004f000000000000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000930f0f930f93843535353535353535353535350000000000353535000000343535360000003435360011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03000000000000000000000000343535353600000f0000830f84830f0f9400830f0f94000f8400930f000000000000840f940000000000b314940f0f16b4000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
130f0f0f343535353536000000930f000f94000004050505053536949383930f0f9400830f9400930f849384159394000f00000000000000140f940f1600000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1383940093830f0f0000000000000f000f0000001415000016b4000000930f0f0f00830f0f0f94000f0f8415151583940000000000000000149483341600000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1336000000000f0f9400000000000f000f00000014000000160f840000343535353535350f0f000035353535353535353535353600000000140f0f0f1600000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
130f84000000840f8400000000000f000f00000014000015160f0f0000830f0f0f0f0f949394000094930f94930f94930f94930f840000000f8483001684000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
130f0f000000003132323232320203000f00003425252525253693938400939400930f0f0000000000000f00000f00000f00000f84000000930f0f830f94000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
130000000000000000000000002123000f0000930f0f0f0f938400830f8400005f0093940015008384000f00000f00000000000f0f840083000f840f0f0f005f11000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1300009100a1008100a10090002020000f0000830f0f0f0f8493844f930f043535353506151515930f0f0f0f0f0f0f8400830f0f8300001515934f840f94000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002020202020202020202020202020202020202343535353535353535352600000000243535353535353535353535353535353535353535353535353535020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001255015550185501c5502055022550235502355004500095003f5002a500255502655026550275002a5002c5002b5002a500295002750026500275000050000500005000050000500005000050000500
0001000003770047700577006770077700a7700d7700f7701277015770197701b7702177000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
00020000000001605000000000000e05000000000000905000000000000000000000000000f050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200000060014650126500e6500d6500a6500865006650046500265001650006500065000650006500065000600006000060000600006001560000600006000060000600006000060000600006000060000600
000200000e0500a05008050070500505001050000500d0500a0500905008050040500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002000008150081500b1500e150111501615003150051500a1500d150101501a1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000e033000330003313003030330303314003000030e033000330003313003030330303314003030330e033000330003313003030330303314003000030e03300033000331300303033030331400303033
011000001a013000001c0131a013246130000000000000001a013246001c013246131a0131c0131a013246001a013000001a0131a013246130000000000000001a013246001a013246131a0131a0131a01324600
01100000200151a0100d0100f0100f01000000200130000019015190101b0151b0101b010000000000000000200151a0100d0100f0100f01000000200130000019015190151b0151b0151b0101b0151b01000000
__music__
03 06070846

