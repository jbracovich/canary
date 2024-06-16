uplevel = CreatureEvent("UpLevel")

function uplevel.onAdvance(player, skill, oldLevel, newLevel)
    if skill ~= SKILL_LEVEL or newLevel <= oldLevel then
        return true
    end

    local position = player:getPosition()
    local efeito = 263
    local shot = 263

    if newLevel > oldLevel then
        -- Enviar efecto de distancia al jugador
        position:sendDistanceEffect(position, shot)
        -- Enviar efecto mágico al jugador
        position:sendMagicEffect(efeito)
        -- Mensaje de nivel arriba
        player:say("[LEVEL UP]", TALKTYPE_MONSTER_SAY)
        -- Efecto adicional en la posición del jugador
        position:sendMagicEffect(263)
    end

    return true
end

uplevel:register()
