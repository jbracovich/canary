local oldAutolootStorage = 30063
local flasksStorage = "talkaction.potions.flask"

local function migrate(player)
    local isAutoLoot = player:getStorageValue(oldAutolootStorage)
    if isAutoLoot > 0 then
        player:setFeature(Features.AutoLoot, 1)
        player:setStorageValue(oldAutolootStorage, -1)
    end

    -- Usamos el sistema KV en lugar de player:getStorageValueByName
    local getOldFlasksStorage = player:kv():get(flasksStorage)  -- Obtenemos el valor del KV
    if getOldFlasksStorage then  -- Verificamos si el valor existe y es true
        player:kv():set(flasksStorage, true)  -- Seteamos el valor en el KV
        player:setStorageValueByName(flasksStorage, -1)  -- Establecemos el valor antiguo a -1 (opcional)
    end
end

local migration = Migration("20241708485868_move_some_storages_to_kv")

function migration:onExecute()
    self:forEachPlayer(migrate)
end

migration:register()

