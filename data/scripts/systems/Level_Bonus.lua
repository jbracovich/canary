local config = {
    debug = true,
    maxLevel = 2000,  -- Nivel máximo para obtener bonos
    levelBonuses = {
        [500] = {bonus = 25},
        [1000] = {bonus = 25},
    },
    vocationBonuses = {
        [5] = {health = 150, mana = 250, cap = 50},
        [6] = {health = 250, mana = 350, cap = 75},
        [7] = {health = 295, mana = 150, cap = 75},
        [8] = {health = 295, mana = 150, cap = 75},
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
    
    -- Solo actualiza si el nivel actual está en levelBonuses y no se ha actualizado antes
    if config.levelBonuses[playerLevel] and playerLevel > lastLevel then
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

local bonusOnHealthChange = CreatureEvent("bonusOnHealthChange")

function bonusOnHealthChange.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)

    if not creature or not attacker or primaryType == COMBAT_HEALING then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    if primaryDamage ~= 0 and attacker:isPlayer() then
        local bonusDamage = attacker:kv():get(config.storageBonus) or 0
        if bonusDamage > 0 then
            bonusDamage = 1 + (bonusDamage / 100)
            if config.debug then
                logger.info("0 bonus damage onHealthChange: primaryDamage {} y secondaryDamage {}", primaryDamage, secondaryDamage)
            end
            primaryDamage = math.ceil(primaryDamage * bonusDamage)
            secondaryDamage = math.ceil(secondaryDamage * bonusDamage)
            if config.debug then
                logger.info("{}% bonus damage onHealthChange: primaryDamage {} y secondaryDamage {}", ((bonusDamage - 1) * 100), primaryDamage, secondaryDamage)
            end
        end
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

bonusOnHealthChange:register()

local bonusOnManaChange = CreatureEvent("bonusOnManaChange")

function bonusOnManaChange.onManaChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)

    if not creature or not attacker then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    if primaryDamage ~= 0 and attacker:isPlayer() then
        local bonusDamage = attacker:kv():get(config.storageBonus) or 0
        if bonusDamage > 0 then
            bonusDamage = 1 + (bonusDamage / 100)
            if config.debug then
                logger.info("0 bonus damage onManaChange: primaryDamage {} y secondaryDamage {}", primaryDamage, secondaryDamage)
            end
            primaryDamage = math.ceil(primaryDamage * bonusDamage)
            secondaryDamage = math.ceil(secondaryDamage * bonusDamage)
            if config.debug then
                logger.info("{}% bonus damage onManaChange: primaryDamage {} y secondaryDamage {}", ((bonusDamage - 1) * 100), primaryDamage, secondaryDamage)
            end
        end
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end

bonusOnManaChange:register()

