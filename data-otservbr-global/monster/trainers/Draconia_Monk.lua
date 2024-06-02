local mType = Game.createMonsterType("Draconia Monk")
local monster = {}

monster.description = "a Draconia Monk"
monster.experience = 0
monster.outfit = {
	lookType = 57,
}

monster.health = 1000000
monster.maxHealth = monster.health
monster.race = "blood"
monster.corpse = 0
monster.speed = 0

monster.changeTarget = {
	interval = 1000,
	chance = 0,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	targetDistance = 1,
	staticAttackChance = 100,
}

monster.summons = {}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Feel the dragon's fury, Sir or Ma'am!", yell = false },
	{ text = "Embrace the inferno within, pupil.", yell = false },
	{ text = "Darkness is your ally, unleash the dragon.", yell = false },
	{ text = "Dragons reign in shadows, learn their power.", yell = false },
	{ text = "Channel draconic strength, become unstoppable.", yell = false },
	{ text = "Conquer with the dragon's fury, pupil.", yell = false },
	{ text = "Let the abyss fuel your power, embrace it.", yell = false },
	{ text = "Awaken the dragon within, wield its might.", yell = false },
	{ text = "Command creation and destruction, embrace destiny.", yell = false },
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -2, maxDamage = -7, attack = 130 },
}

monster.defenses = {
	defense = 10,
	armor = 7,
	{ name = "combat", type = COMBAT_HEALING, chance = 15, interval = 2000, minDamage = 10000, maxDamage = 50000, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {}

mType:register(monster)
