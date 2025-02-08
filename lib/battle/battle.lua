--MODULES
local PRNG = require("/lib/battle/prng")
--
local Battle = {}
Battle.__index = Battle

function Battle.new() 
    local instance = setmetatable({}, Battle)
    
    instance.format = nil --singles or doubles basically

    instance.prng = PRNG.new()

    instance.turn = 0
    instance.lastMove = nil
    instance.midTurn = false

    instance.effect = nil

    return instance
end

return Battle