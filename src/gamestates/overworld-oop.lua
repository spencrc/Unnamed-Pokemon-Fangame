--MODULES
local Vector2 = require("/modules/vector2")
--UNCHANGING VARS
local TILE_SIZE = 64
local screenWidth, screenHeight = love.graphics.getDimensions()
local collisionData = love.filesystem.load("maps/collision-data.lua", "b")()
--CLASS
local Overworld = {}
Overworld.__index = Overworld

function Overworld:load(container)
    local instance = setmetatable({}, self)

    instance.container = container
    instance.map, instance.tileset = love.filesystem.load("maps/test-map.lua", "b")()
    instance.quads = loadTileset(instance.Tileset)
    instance.player = {
        Position = Vector2.new(1, 1);
        AbsolutePosition = Vector2.new(TILE_SIZE/2, TILE_SIZE/2);
    }

    return instance
end