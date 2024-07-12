local sqmId = 10145 -- ID del cuadro específico donde deseas deshabilitar el push

function onPlayerStep(player, sqm)
    if sqm:getId() == sqmId then
        -- El jugador está sobre el cuadro específico, deshabilitar el push
        player:isPushable(false)
    else
        -- Habilitar el push si no está sobre el cuadro específico
        player:isPushable(true)
    end
end

-- Hook para el evento de cuando un jugador se mueve
function onPlayerMove(player, fromPos, toPos)
    local sqm = Tile(toPos):getTopUseThing()
    onPlayerStep(player, sqm)
end

