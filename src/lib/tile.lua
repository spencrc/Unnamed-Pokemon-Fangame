--MODULES
local Vector2 = require("/lib/vector2")
--
local Tile = {}
Tile.__index = Tile

function Tile.new(x, y, collisionType)
    local instance = setmetatable({}, Tile)

    instance.Position = Vector2.new(x or 0, y or 0)
    instance.CollisionType = collisionType

    return instance
end

return Tile