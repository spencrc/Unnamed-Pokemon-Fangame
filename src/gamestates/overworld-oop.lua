--MODULES
local Vector2 = require("/modules/vector2")
--UNCHANGING VARS
local TILE_SIZE = 64
local screenWidth, screenHeight = love.graphics.getDimensions()
local collisionData = love.filesystem.load("maps/collision-data.lua", "b")()
--CLASS
local Overworld = {}
Overworld.__index = Overworld

local function loadTileset(tileset)
    local quads = {}
    local tilesetWidth, tilesetHeight = tileset:getDimensions()

    for i = 1, 12, 1 do
        quads[i] = love.graphics.newQuad(
            (i-1)*64, --starting x position
            0, --starting y position
            TILE_SIZE, --tile width
            TILE_SIZE, --tile height
            tilesetWidth, --tileset width
            tilesetHeight --tileset height
        )
    end

    return quads
end

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

function Overworld:draw()
    local mapWidth = #self.map
    local mapHeight = #self.map[1]
    local tx = math.floor(self.player.AbsolutePosition.X - screenWidth/2)
    local ty = math.floor(self.player.AbsolutePosition.Y - screenHeight/2)

    love.graphics.push()
    love.graphics.translate(-tx, -ty)

    for col = 1, mapHeight, 1 do
        for row = 1, mapWidth, 1 do
            local tileId = self.map[col][row]
            love.graphics.draw(
                self.tileset, --tileset
                self.quads[tileId],  --quad
                (row-1) * TILE_SIZE, --x position
                (col-1) * TILE_SIZE --y position
            )
        end
    end

    love.graphics.circle("fill", self.player.AbsolutePosition.X, self.player.AbsolutePosition.Y, TILE_SIZE/4)
    love.graphics.pop()
end

local function DetermineCollision(direction, overworld)
    local mapWidth = #overworld.map
    local mapHeight = #overworld.map[1]
    local associatedDirections = {}
    local tileId

    if direction == "left" then
        if overworld.player.Position.X - 1 <= 0 then return true end
        associatedDirections = {"left","topleft","bottomleft", "leftright"}
        tileId = overworld.map[overworld.player.Position.Y][overworld.player.Position.X - 1]
    elseif direction == "right" then
        if overworld.player.Position.X + 1 > mapWidth then return true end
        associatedDirections = {"right","topright","bottomright", "leftright"}
        tileId = overworld.map[overworld.player.Position.Y][overworld.player.Position.X + 1]
    elseif direction == "down" then
        if overworld.player.Position.Y + 1 > mapHeight then return true end
        associatedDirections = {"bottom","bottomleft","bottomright", "topbottom"}
        tileId = overworld.map[overworld.player.Position.Y + 1][overworld.player.Position.X]
    elseif direction == "up" then
        if overworld.player.Position.Y - 1 <= 0 then return true end
        associatedDirections = {"top","topleft","topright", "topbottom"}
        tileId = overworld.map[overworld.player.Position.Y - 1][overworld.player.Position.X]
    else
        return false
    end

    for _, Value in pairs(collisionData.all) do
        if Value == tileId then return true end
    end

    for i = 1, 4, 1 do --4 possible directions associated with a singular one. e.x: left is associated w/ true left, top left, bottom left & left right
        for _, Value in pairs(collisionData[associatedDirections[i]]) do
            if Value == tileId then return true end --if the value matches the tileId, then there will be a collision
        end
    end

    return false
end

local function movePlayer(direction, overworld)
    if not DetermineCollision(direction) then
        if direction == "left" then
            overworld.player.Position.X = overworld.player.Position.X - 1
        elseif direction == "right" then
            overworld.player.Position.X = overworld.player.Position.X + 1
        elseif direction == "down" then
            overworld.player.Position.Y = overworld.player.Position.Y + 1
        elseif direction == "up" then
            overworld.player.Position.Y = overworld.player.Position.Y - 1
        else return
        end
    else return
    end

    overworld.player.AbsolutePosition.X = (overworld.player.Position.X - 0.5) * TILE_SIZE
    overworld.player.AbsolutePosition.Y = (overworld.player.Position.Y - 0.5) * TILE_SIZE
    -- local newX = (player.Position.X - 0.5) * TILE_SIZE
    -- local newY = (player.Position.Y - 0.5) * TILE_SIZE
    -- local movementTween = Tween.new(15, player.AbsolutePosition, {newX, newY}, "linear")
    -- movementTween:update()

    print(overworld.player.Position)
end

function Overworld:keypressed(key, scanCode, isRepeat)
    movePlayer(key, self)
    if key == "escape" then 
        self.manager:switch("/gamestates/mainmenu")
    end
end

return Overworld

