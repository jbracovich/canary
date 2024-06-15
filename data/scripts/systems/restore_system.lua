local config = {
    debug = false,
    maxLevel = 2000,  -- Nivel máximo para obtener bonos
    levelBonuses = {
        [100] = {bonus = 1.11},
        [200] = {bonus = 2.22},
        [300] = {bonus = 3.33},
        [400] = {bonus = 4.44},
        [500] = {bonus = 5.56},
        [600] = {bonus = 6.67},
        [700] = {bonus = 7.78},
        [800] = {bonus = 8.89},
        [900] = {bonus = 10},  -- Aquí se alcanza exactamente el 50%
    },
    vocationBonuses = {
       -- [1] = {health = 150, mana = 250, cap = 50},
       -- [2] = {health = 250, mana = 350, cap = 75},
       -- [3] = {health = 295, mana = 150, cap = 75},
	   -- [4] = {health = 295, mana = 150, cap = 75},
        -- Agrega más vocaciones y sus bonos según tus necesidades
    },
    storageBonus = "bonus-level",
    storageLastLevel = "last-level-bonus"
}

function Player:getLevelBonus()
    local playerLevel = self:getLevel()
    local bonus = 0
    for level, config in pairs(config.levelBonuses) do
        if playerLevel >= level then
            bonus = bonus + config.bonus  -- Acumula el bono en lugar de sobrescribir
        end
    end
    return bonus
end

function Player:updateBonuses()
    local bonus = self:getLevelBonus()
    self:kv():set(config.storageBonus, bonus)
    self:updateHealthMana()
end

function Player:updateHealthMana()
    local bonus = self:kv():get(config.storageBonus) or 0
    local lastLevel = self:kv():get(config.storageLastLevel) or 0
    local playerLevel = self:getLevel()
    
    if playerLevel > lastLevel then
        self:kv():set(config.storageLastLevel, playerLevel)
        local vocationBonus = config.vocationBonuses[self:getVocation():getId()] or {health = 0, mana = 0, experience = 0, cap = 0}
		local newHealth = self:getMaxHealth() * (1 + bonus / 100) + vocationBonus.health
		local newMana = self:getMaxMana() * (1 + bonus / 100) + vocationBonus.mana		

        self:setMaxHealth(newHealth)
        self:setMaxMana(newMana)
    end
end

local onLogin = CreatureEvent("onLogin")

function onLogin.onLogin(player)
    player:updateBonuses()
    return true
end

onLogin:register()

local onHealthChange = CreatureEvent("onHealthChange")

function onHealthChange.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if attacker:isPlayer() then
        local bonus = attacker:kv():get(config.storageBonus) or 0
        if bonus > 0 then
            local damageMultiplier = 1 + (bonus / 100)
            primaryDamage = math.ceil(primaryDamage * damageMultiplier)
            secondaryDamage = math.ceil(secondaryDamage * damageMultiplier)
        end
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

onHealthChange:register()

local onManaChange = CreatureEvent("onManaChange")

function onManaChange.onManaChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if attacker:isPlayer() then
        local bonus = attacker:kv():get(config.storageBonus) or 0
        if bonus > 0 then
            local damageMultiplier = 1 + (bonus / 100)
            primaryDamage = math.ceil(primaryDamage * damageMultiplier)
            secondaryDamage = math.ceil(secondaryDamage * damageMultiplier)
        end
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

onManaChange:register()
