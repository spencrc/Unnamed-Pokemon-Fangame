--MODULES
local Vector2 = require("/modules/vector2")
--
local Tile = {}
Tile.__index = Tile

function Tile.new(x, y, CollisionValue)
    local instance = setmetatable({}, Tile)

    instance.PositionInTileset = Vector2.new(x or 0, y or 0)
    instance.CollisionValue = CollisionValue

    return instance
end

return Tile