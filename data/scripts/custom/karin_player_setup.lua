Karin.PlayerSetup = {
    Test = false,
    Dodge = {
        LimitUpgrade = 500,
        UpgradePerUse = 1,
        Storage = 15000,
        ItemId = 45553,
    },
    Critical = {
        PercentDamage = 60,
        LimitUpgrade = 150,
        UpgradePerUse = 1,
        Storage = 15001,
        ItemId = 45554,
    },
    Reflect = {
        LimitUpgrade = 500,
        UpgradePerUse = 1,
        Storage = 15002,
        ItemId = 45555,
    },
    VocationsBalance = {
        PVP = {
            DAMAGE = {
                KNIGHT = 1.0,
                SORCERER = 1.0,
                DRUID = 1.0,
                PALADIN = 1.0,
            },
            DEFENSE = {
                KNIGHT = 1.0,
                SORCERER = 1.0,
                DRUID = 1.0,
                PALADIN = 1.0,
            },
        },
        PVE = {
            DAMAGE = {
                KNIGHT = 2.5,
                SORCERER = 2.5,
                DRUID = 2.5,
                PALADIN = 2.5,
            },
            DEFENSE = {
                KNIGHT = 1.5,
                SORCERER = 1.5,
                DRUID = 1.5,
                PALADIN = 1.5,
            },
        }
    }
}

__PlayerSetupFunctions = {
    onCombat = function(self, creature, target, primaryDamage, primaryType, secondaryDamage, secondaryType)
        if primaryType == COMBAT_HEALING or secondaryType == COMBAT_HEALING then
            return primaryDamage, secondaryDamage
        end

        local player = creature:getPlayer()
        local critical = player:getStorageValue(self.Critical.Storage)
        if critical and critical > 0 then
            local criticalChance = math.random(1, 1000)
            if self.Test then
                player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, 'Critical: ' .. critical .. " Critical Chance: " .. criticalChance)
            end
            if criticalChance <= critical then
                primaryDamage = primaryDamage + (primaryDamage * (self.Critical.PercentDamage / 100))
                player:getPosition():sendMagicEffect(CONST_ME_CRITICAL_DAMAGE)
            end
        end

        if creature:isPaladin() then
            primaryDamage = math.floor(primaryDamage * ((target:isPlayer() and self.VocationsBalance.PVP.DAMAGE.PALADIN or self.VocationsBalance.PVE.DAMAGE.PALADIN)))
            secondaryDamage = math.floor(secondaryDamage * ((target:isPlayer() and self.VocationsBalance.PVP.DAMAGE.PALADIN or self.VocationsBalance.PVE.DAMAGE.PALADIN)))
        elseif creature:isSorcerer() then
            primaryDamage = math.floor(primaryDamage * ((target:isPlayer() and self.VocationsBalance.PVP.DAMAGE.SORCERER or self.VocationsBalance.PVE.DAMAGE.SORCERER)))
            secondaryDamage = math.floor(secondaryDamage * ((target:isPlayer() and self.VocationsBalance.PVP.DAMAGE.SORCERER or self.VocationsBalance.PVE.DAMAGE.SORCERER)))
        elseif creature:isDruid() then
            primaryDamage = math.floor(primaryDamage * ((target:isPlayer() and self.VocationsBalance.PVP.DAMAGE.DRUID or self.VocationsBalance.PVE.DAMAGE.DRUID)))
            secondaryDamage = math.floor(secondaryDamage * ((target:isPlayer() and self.VocationsBalance.PVP.DAMAGE.DRUID or self.VocationsBalance.PVE.DAMAGE.DRUID)))
        elseif creature:isKnight() then
            primaryDamage = math.floor(primaryDamage * ((target:isPlayer() and self.VocationsBalance.PVP.DAMAGE.KNIGHT or self.VocationsBalance.PVE.DAMAGE.KNIGHT)))
            secondaryDamage = math.floor(secondaryDamage * ((target:isPlayer() and self.VocationsBalance.PVP.DAMAGE.KNIGHT or self.VocationsBalance.PVE.DAMAGE.KNIGHT)))
        end

        
        return primaryDamage, secondaryDamage
    end,
    onReceiveDamage = function(self, creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
        local player = creature:getPlayer()
        local dodge = player:getStorageValue(self.Dodge.Storage)
        if dodge and dodge > 0 then
            local dodgeChance = math.random(1, 1000)
            if dodgeChance <= dodge then
                primaryDamage = 0
                secondaryDamage = 0
                player:getPosition():sendMagicEffect(CONST_ME_DODGE)
            end
        end

        local reflect = player:getStorageValue(self.Reflect.Storage)
        if reflect and reflect > 0 then
            local reflectChance = math.random(1, 1000)
            if self.Test then
                player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, 'Reflect: ' .. reflect .. " Reflect Chance: " .. reflectChance)
            end

            if reflectChance <= reflect then
                doAreaCombatHealth(0, primaryType, attacker:getPosition(), 0, -primaryDamage, -primaryDamage, CONST_ME_MAGIC_BLUE)
                player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
            end
        end

        if creature:isPaladin() then
            primaryDamage = math.floor(primaryDamage * ((attacker:isPlayer() and self.VocationsBalance.PVP.DEFENSE.PALADIN or self.VocationsBalance.PVE.DEFENSE.PALADIN)))
            secondaryDamage = math.floor(secondaryDamage * ((attacker:isPlayer() and self.VocationsBalance.PVP.DEFENSE.PALADIN or self.VocationsBalance.PVE.DEFENSE.PALADIN)))
        elseif creature:isSorcerer() then
            primaryDamage = math.floor(primaryDamage * ((attacker:isPlayer() and self.VocationsBalance.PVP.DEFENSE.SORCERER or self.VocationsBalance.PVE.DEFENSE.SORCERER)))
            secondaryDamage = math.floor(secondaryDamage * ((attacker:isPlayer() and self.VocationsBalance.PVP.DEFENSE.SORCERER or self.VocationsBalance.PVE.DEFENSE.SORCERER)))
        elseif creature:isDruid() then
            primaryDamage = math.floor(primaryDamage * ((attacker:isPlayer() and self.VocationsBalance.PVP.DEFENSE.DRUID or self.VocationsBalance.PVE.DEFENSE.DRUID)))
            secondaryDamage = math.floor(secondaryDamage * ((attacker:isPlayer() and self.VocationsBalance.PVP.DEFENSE.DRUID or self.VocationsBalance.PVE.DEFENSE.DRUID)))
        elseif creature:isKnight() then
            primaryDamage = math.floor(primaryDamage * ((attacker:isPlayer() and self.VocationsBalance.PVP.DEFENSE.KNIGHT or self.VocationsBalance.PVE.DEFENSE.KNIGHT)))
            secondaryDamage = math.floor(secondaryDamage * ((attacker:isPlayer() and self.VocationsBalance.PVP.DEFENSE.KNIGHT or self.VocationsBalance.PVE.DEFENSE.KNIGHT)))
        end

        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end,
    onLogin = function (self, player)
        player:registerEvent('KarinHealth')
        player:registerEvent('KarinMana')
    end,
	onGainExperience = function(self, player, exp, monster)
        return exp
	end,
    calculateLootFactor = function(self, player, monster, factor, suffix)
        return factor, suffix
    end
}


Karin.PlayerSetup = setmetatable(
    Karin.PlayerSetup,
    { __index = __PlayerSetupFunctions }
)


local KarinLogin = CreatureEvent("KarinLogin")

function KarinLogin.onLogin(player)
    Karin.PlayerSetup:onLogin(player)
	return true
end

KarinLogin:register()


local Karin_HealthChange = CreatureEvent("KarinHealth")

function Karin_HealthChange.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
    if not creature or not attacker or creature == attacker then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end
    if primaryType == COMBAT_HEALING or secondaryType == COMBAT_HEALING then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    primaryDamage, primaryType, secondaryDamage, secondaryType = Karin.PlayerSetup:onReceiveDamage(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
 
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

Karin_HealthChange:register()

local karinManaChange = CreatureEvent("KarinMana")

function karinManaChange.onManaChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
    if not creature or not attacker or creature == attacker then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end
    if primaryType == COMBAT_HEALING or secondaryType == COMBAT_HEALING then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    primaryDamage, primaryType, secondaryDamage, secondaryType = Karin.PlayerSetup:onReceiveDamage(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType)
   
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end
karinManaChange:register()


local DodgeItem = Action()

function DodgeItem.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local currentDodge = player:getStorageValue(Karin.PlayerSetup.Dodge.Storage)
    if not currentDodge or currentDodge == -1 then
        currentDodge = 0
    end

    if currentDodge + Karin.PlayerSetup.Dodge.UpgradePerUse > Karin.PlayerSetup.Dodge.LimitUpgrade then
        player:sendCancelMessage("You have reached the maximum dodge upgrade.")
        return true
    end

    if item:remove(1) then
        if Karin.PlayerSetup.Test then
            player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "Dodge: " .. currentDodge + Karin.PlayerSetup.Dodge.UpgradePerUse)
        end
        player:setStorageValue(Karin.PlayerSetup.Dodge.Storage, currentDodge + Karin.PlayerSetup.Dodge.UpgradePerUse)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have upgraded your dodge. [" .. currentDodge + Karin.PlayerSetup.Dodge.UpgradePerUse .. "/".. Karin.PlayerSetup.Dodge.LimitUpgrade.."]")
        player:getPosition():sendMagicEffect(CONST_ME_DODGE)
    end
	return true
end

DodgeItem:id(Karin.PlayerSetup.Dodge.ItemId)
DodgeItem:register()

local CrtiicalItem = Action()

function CrtiicalItem.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local currentCritical = player:getStorageValue(Karin.PlayerSetup.Critical.Storage)
    if not currentCritical or currentCritical == -1 then
        currentCritical = 0
    end

    if currentCritical + Karin.PlayerSetup.Critical.UpgradePerUse > Karin.PlayerSetup.Critical.LimitUpgrade then
        player:sendCancelMessage("You have reached the maximum Critical upgrade.")
        return true
    end

    if item:remove(1) then
        if Karin.PlayerSetup.Test then
            player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "Critical: " .. currentCritical + Karin.PlayerSetup.Critical.UpgradePerUse)
        end
        player:setStorageValue(Karin.PlayerSetup.Critical.Storage, currentCritical + Karin.PlayerSetup.Critical.UpgradePerUse)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have upgraded your critical. [" .. currentCritical + Karin.PlayerSetup.Critical.UpgradePerUse .. "/".. Karin.PlayerSetup.Critical.LimitUpgrade .."]")
        player:getPosition():sendMagicEffect(CONST_ME_CRITICAL_DAMAGE)
    end
	return true
end

CrtiicalItem:id(Karin.PlayerSetup.Critical.ItemId)
CrtiicalItem:register()

local ReflectItem = Action()

function ReflectItem.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local currentReflect = player:getStorageValue(Karin.PlayerSetup.Reflect.Storage)
    if not currentReflect or currentReflect == -1 then
        currentReflect = 0
    end
    
    if currentReflect + Karin.PlayerSetup.Reflect.UpgradePerUse > Karin.PlayerSetup.Reflect.LimitUpgrade then
        player:sendCancelMessage("You have reached the maximum Reflect upgrade.")
        return true
    end
    
    if item:remove(1) then
        if Karin.PlayerSetup.Test then
            player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "Reflect: " .. currentReflect + Karin.PlayerSetup.Reflect.UpgradePerUse)
        end
        player:setStorageValue(Karin.PlayerSetup.Reflect.Storage, currentReflect + Karin.PlayerSetup.Reflect.UpgradePerUse)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have upgraded your reflect. [" .. currentReflect + Karin.PlayerSetup.Reflect.UpgradePerUse .. "/".. Karin.PlayerSetup.Reflect.LimitUpgrade .."]")
        player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
    end
    return true
end

ReflectItem:id(Karin.PlayerSetup.Reflect.ItemId)
ReflectItem:register()