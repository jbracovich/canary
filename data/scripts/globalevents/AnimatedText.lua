local effects = {

    --Posiones
    {position = Position(32357, 32231, 7), text = 'Buff Power', delay = 1 },
    {position = Position(32357, 32232, 7), text = 'Dodge', delay = 1 },
    {position = Position(32357, 32233, 7), text = 'Critical', delay = 1 },
    {position = Position(32357, 32234, 7), text = 'Reflect', delay = 1 },

    --Teleports
    {position = Position(32350, 32223, 7), text = 'Teleports', delay = 1 },

    -- Zona de Hunts Easy
    {position = Position(1058, 740, 5), text = 'Easy', delay = 1 },

    --Zona de Hunts Medium
    {position = Position(1060, 740, 5), text = 'Medium', delay = 1 },

    -- Zona de Hunts Hard
    {position = Position(1062, 740, 5), text = 'Hard', delay = 1 },

    --Bosses
    {position = Position(1053, 745, 5), text = 'Bosses', delay = 1 },

    --Quest
    {position = Position(1053, 747, 5), text = 'Quests', delay = 1 },

    --Cassino
    {position = Position(1067, 746, 5), text = 'Cassino', delay = 1 },

    --Trainers
    {position = Position(1059, 752, 5), text = 'Trainers', delay = 1 },

    --Dummys
    {position = Position(1061, 752, 5), text = 'Dummys', delay = 1 },

}

local animatedText = GlobalEvent("AnimatedText") 
function animatedText.onThink(interval)
    for i = 1, #effects do
        local settings = effects[i]
        local spectators = Game.getSpectators(settings.position, false, true, 7, 7, 5, 5)
        if #spectators > 0 then
            if settings.text then
                for i = 1, #spectators do
                    spectators[i]:say(settings.text, TALKTYPE_MONSTER_SAY, false, spectators[i], settings.position)
                end
            end
            if settings.effect then
                settings.position:sendMagicEffect(settings.effect)
            end
        end
    end
   return true
end

animatedText:interval(4000)
animatedText:register()