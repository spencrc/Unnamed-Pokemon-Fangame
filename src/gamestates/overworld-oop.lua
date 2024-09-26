--MODULES
local Vector2 = require("/modules/vector2")
local TileData = require("/modules/tile-data")
local TM = require("/modules/tween-manager").new()
--UNCHANGING VARS
local TILE_SIZE = 128
local QUAD_SIZE = 32
local screenWidth, screenHeight = love.graphics.getDimensions()
--
local collisionData = love.filesystem.load("maps/collision-data.lua", "b")()
--CLASS
local Overworld = {}
Overworld.__index = Overworld

function Overworld:load(GSM)
    local instance = setmetatable({}, Overworld)

    instance.GSM = GSM
    instance.map_layer1, instance.map_layer2 = love.filesystem.load("maps/test-map.lua", "b")()
    instance.tileset = love.graphics.newImage("images/collision-showcase.png")
    instance.player_tileset = love.graphics.newImage("images/temp-player.png")
    instance.quads = {}
    instance.player = {
        Position = Vector2.new(1, 1);
        AbsolutePosition = Vector2.new(TILE_SIZE/2, TILE_SIZE/2);
        Direction = "down";
    }

    instance:init()

    return instance
end

function Overworld:init()
    self:loadMap() 
end
--INIT HELPERS
function Overworld:loadMap()
    self.Tileset:setFilter("nearest", "nearest")

    local tilesetWidth, tilesetHeight = self.Tileset:getDimensions()
    local mapWidth = #self.map_layer1
    local mapHeight = #self.map_layer1[1]

    for col = 1, mapHeight, 1 do
        for row = 1, mapWidth, 1 do
            local layer1TileAtPosition = TileData[self.map_layer1[col][row]]
            local layer2TileAtPosition = TileData[self.map_layer2[col][row]]

            if not self.quads[self.map_layer1[col][row]] then
                self.quads[self.map_layer1[col][row]] = love.graphics.newQuad(
                    layer1TileAtPosition.Position.X * 32,
                    layer1TileAtPosition.Position.Y * 32,
                    QUAD_SIZE,
                    QUAD_SIZE,
                    tilesetWidth,
                    tilesetHeight
                )
            end
            if not self.quads[self.map_layer2[col][row]] then
                self.quads[self.map_layer2[col][row]] = love.graphics.newQuad(
                    layer2TileAtPosition.Position.X * 32,
                    layer2TileAtPosition.Position.Y * 32,
                    QUAD_SIZE,
                    QUAD_SIZE,
                    tilesetWidth,
                    tilesetHeight
                )
            end
        end
    end
end
--
function Overworld:draw()
    TM:update()

    local tx = math.floor(self.player.AbsolutePosition.X - screenWidth/2)
    local ty = math.floor(self.player.AbsolutePosition.Y - screenHeight/2)

    love.graphics.push()
    love.graphics.translate(-tx, -ty)

    self:drawLayer(self.map_layer1)
    self:drawLayer(self.map_layer2)
    self:drawPlayerSprite()
    --love.graphics.circle("fill", player.AbsolutePosition.X, player.AbsolutePosition.Y, TILE_SIZE/4)
    love.graphics.pop()
end
--DRAW HELPERS
function Overworld:drawPlayer()
    local spriteCol = 0

    if self.player.Direction == "down" then
        spriteCol = 1
    elseif self.player.Direction == "left" then
        spriteCol = 2
    elseif self.player.Direction == "right" then
        spriteCol = 3
    elseif self.player.Direction == "up" then
        spriteCol = 4
    else error(self.player.Direction.." is not a valid direction!")
    end

    local playerSprite = love.graphics.newQuad(
        0,
        (spriteCol-1)*32,
        32,
        32,
        self.player_tileset:getWidth(),
        self.player_tileset:getHeight()
    )

    love.graphics.draw(
        self.player_tileset, --tileset
        playerSprite, --selects quad to use
        self.player.AbsolutePosition.X, --x position
        self.player.AbsolutePosition.Y, --y position
        2*math.pi,--angle in radians
        TILE_SIZE/QUAD_SIZE, --x scale
        TILE_SIZE/QUAD_SIZE --y scale
    )
end

function Overworld:drawLayer(layer)
    local mapWidth = #layer
    local mapHeight = #layer[1]

    for col = 1, mapHeight, 1 do
        for row = 1, mapWidth, 1 do
            local TileId = layer[col][row]

            print(TileId)
            print(self.quads[TileId])

            if TileId ~= "-" then
                love.graphics.draw(
                    self.tileset, --tileset
                    self.quads[TileId],  --quad
                    (row-1) * TILE_SIZE, --x position
                    (col-1) * TILE_SIZE, --y position
                    2*math.pi,
                    TILE_SIZE/QUAD_SIZE,
                    TILE_SIZE/QUAD_SIZE
                )
            end
        end
    end
end
--
function Overworld:update()
    if love.keyboard.isDown("left") then 
        self:movePlayer("left")
    elseif love.keyboard.isDown("right") then
        self:movePlayer("right")
    elseif love.keyboard.isDown("down") then
        self:movePlayer("down")
    elseif love.keyboard.isDown("up") then
        self:movePlayer("up")
    end
end
--UPDATE HELPERS
function Overworld:movePlayer(direction)
    if not DetermineCollision(direction, self.player, self.map_layer1, self.map_layer2) then
        local movementTween

        if direction == "left" then
            self.player.Position.X = self.player.Position.X - 1
            --movementTween = TM:Create(player.Position, 12, "X", player.Position.X - 1)
        elseif direction == "right" then
            self.player.Position.X = self.player.Position.X + 1
            --movementTween = TM:Create(player.Position, 12, "X", player.Position.X + 1)
        elseif direction == "down" then
            self.player.Position.Y = self.player.Position.Y + 1
            --movementTween = TM:Create(player.Position, 12, "Y", player.Position.Y + 1)
        elseif direction == "up" then
            self.player.Position.Y = self.player.Position.Y - 1
            --movementTween = TM:Create(player.Position, 12, "Y", player.Position.Y - 1)
        else return
        end
        if direction == "left" or direction == "right" then
            movementTween = TM:Create(self.player.AbsolutePosition, 10, "X", (self.player.Position.X - 1) * TILE_SIZE)
        else
            movementTween = TM:Create(self.player.AbsolutePosition, 10, "Y", (self.player.Position.Y - 1) * TILE_SIZE)
        end
        movementTween:Play()
    else 
        self.player.Direction = direction
        return
    end

    self.player.Direction = direction
    -- local newX = (player.Position.X - 0.5) * TILE_SIZE
    -- local newY = (player.Position.Y - 0.5) * TILE_SIZE
    -- local movementTween = Tween.new(15, player.AbsolutePosition, {newX, newY}, "linear")
    -- movementTween:update()

    print(self.player.Position)
end

function DetermineCollision(direction, player, map_layer1, map_layer2)
    local associatedDirections = {}
    local tileIds = {}
    local mapWidth = #map_layer1
    local mapHeight = #map_layer1[1]

    if direction == "left" then
        if player.Position.X - 1 <= 0 then return true end
        associatedDirections = {"left","topleft","bottomleft", "leftright"}
        table.insert(tileIds, map_layer1[player.Position.Y][player.Position.X - 1])
        table.insert(tileIds, map_layer2[player.Position.Y][player.Position.X - 1])
    elseif direction == "right" then
        if player.Position.X + 1 > mapWidth then return true end
        associatedDirections = {"right","topright","bottomright", "leftright"}
        table.insert(tileIds, map_layer1[player.Position.Y][player.Position.X + 1])
        table.insert(tileIds, map_layer2[player.Position.Y][player.Position.X + 1])
    elseif direction == "down" then
        if player.Position.Y + 1 > mapHeight then return true end
        associatedDirections = {"bottom","bottomleft","bottomright", "topbottom"}
        table.insert(tileIds, map_layer1[player.Position.Y + 1][player.Position.X])
        table.insert(tileIds, map_layer2[player.Position.Y + 1][player.Position.X])
    elseif direction == "up" then
        if player.Position.Y - 1 <= 0 then return true end
        associatedDirections = {"top","topleft","topright", "topbottom"}
        table.insert(tileIds, map_layer1[player.Position.Y - 1][player.Position.X])
        table.insert(tileIds, map_layer2[player.Position.Y - 1][player.Position.X])
    else
        return false
    end

    for layer, _ in pairs (tileIds) do
        for _, Value in pairs(collisionData.all) do
            if Value == tileIds[layer] then return true end
        end

        for i = 1, 4, 1 do --4 possible directions associated with a singular one. e.x: left is associated w/ true left, top left, bottom left & left right
            for _, Value in pairs(collisionData[associatedDirections[i]]) do
                if Value == tileIds[layer] then return true end --if the value matches the tileId, then there will be a collision
            end
        end
    end

    return false
end

function Overworld:keypressed(key, scanCode, isRepeat)
    if key == "escape" then 
        self.GSM:switch("mainmenu")
    end
end