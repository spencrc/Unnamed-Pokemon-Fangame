local Battle = {}
Battle.__index = Battle

function Battle.new() 
    local instance = setmetatable({}, Battle)
    
    instance.turn = 0
    instance.effect = nil

    instance._lastMove = nil

    return instance
end

return Battle