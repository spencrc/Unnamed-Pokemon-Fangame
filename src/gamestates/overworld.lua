--MODULES
local Vector2 = require("/modules/vector2")
local TM = require("/modules/tween-manager").new()
--IMPORTANT SYSTEM VARIABLES
local TILE_SIZE = 128
local screenWidth, screenHeight = love.graphics.getDimensions()
--MAP DATA
local map_layer1, map_layer2, objects = love.filesystem.load("maps/test-map.lua", "b")()
local mapWidth = #map_layer1
local mapHeight = #map_layer1[1]
local collisionData = love.filesystem.load("maps/collision-data.lua", "b")()
--TILESETS & QUADS
local Tileset_Layer1 
local Tileset_Layer2
local PlayerTileset = love.graphics.newImage("images/temp-player.png")
local Quads_Layer1 = {}
local Quads_Layer2 = {}
--TO BE ORGANIZED
local player = {
    Position = Vector2.new(1, 1);
    AbsolutePosition = Vector2.new(0, 0);
    Direction = "down";
}

--FUNCTIONS
local Overworld = {}

local function loadTileset()
    Tileset_Layer1 = love.graphics.newImage("images/collision-showcase.png")
    Tileset_Layer1:setFilter("nearest", "nearest")
    Tileset_Layer2 = love.graphics.newImage("images/objects.png")
    Tileset_Layer2:setFilter("nearest", "nearest")

    local tilesetWidth, tilesetHeight = Tileset_Layer1:getDimensions()

    for i = 1, tilesetWidth/64, 1 do
        Quads_Layer1[i] = love.graphics.newQuad(
            (i-1)*64, --starting x position
            0, --starting y position
            64, --tile width
            64, --tile height
            tilesetWidth, --tileset width
            tilesetHeight --tileset height
        )
    end

    tilesetWidth, tilesetHeight = Tileset_Layer2:getDimensions()

    for i = 1, tilesetWidth/32, 1 do
        Quads_Layer2[i] = love.graphics.newQuad(
            (i-1)*32, --starting x position
            0, --starting y position
            32, --tile width
            32, --tile height
            tilesetWidth, --tileset width
            tilesetHeight --tileset height
        )
    end
end

function Overworld.onStateBegin()
    loadTileset()
    PlayerTileset:setFilter("nearest", "nearest")
end

local function drawPlayerSprite()
    local spriteCol = 0

    if player.Direction == "down" then
        spriteCol = 1
    elseif player.Direction == "left" then
        spriteCol = 2
    elseif player.Direction == "right" then
        spriteCol = 3
    elseif player.Direction == "up" then
        spriteCol = 4
    else error(player.Direction.." is not a valid direction!")
    end

    local playerSprite = love.graphics.newQuad(
        0,
        (spriteCol-1)*32,
        32,
        32,
        PlayerTileset:getWidth(),
        PlayerTileset:getHeight()
    )

    love.graphics.draw(
        PlayerTileset, --tileset
        playerSprite, --selects quad to use
        player.AbsolutePosition.X, --x position
        player.AbsolutePosition.Y, --y position
        2*math.pi,--angle in radians
        TILE_SIZE/32, --x scale
        TILE_SIZE/32 --y scale
    )
end

local function drawLayer(layer)
    for col = 1, mapHeight, 1 do
        for row = 1, mapWidth, 1 do
            local Tileset = Tileset_Layer1
            local TileId = layer[col][row]
            local Quads
            local multi = 64

            if layer == map_layer1 then --temporary !!!!!!!! REMOVE THIS EVENTUALLY PLEASE
                Quads = Quads_Layer1
            else
                Tileset = Tileset_Layer2
                Quads = Quads_Layer2
                multi = 32
            end

            if TileId > 0 then
                love.graphics.draw(
                    Tileset, --tileset
                    Quads[TileId],  --quad
                    (row-1) * TILE_SIZE, --x position
                    (col-1) * TILE_SIZE, --y position
                    2*math.pi,
                    TILE_SIZE/multi,
                    TILE_SIZE/multi
                )
            end
        end
    end
end

function Overworld.draw()
    TM:update()
    --player.AbsolutePosition.X = (player.Position.X - 1) * TILE_SIZE
    --player.AbsolutePosition.Y = (player.Position.Y - 1) * TILE_SIZE

    local tx = math.floor(player.AbsolutePosition.X - screenWidth/2)
    local ty = math.floor(player.AbsolutePosition.Y - screenHeight/2)

    love.graphics.push()
    love.graphics.translate(-tx, -ty)

    drawLayer(map_layer1)
    drawLayer(map_layer2)
    drawPlayerSprite()
    --love.graphics.circle("fill", player.AbsolutePosition.X, player.AbsolutePosition.Y, TILE_SIZE/4)
    love.graphics.pop()
    
end

function Overworld.keypressed(key, scanCode, isRepeat)
    movePlayer(key)
    if key == "escape" then 
        GSM:switch("mainmenu")
    end
end

function movePlayer(direction)
    if not DetermineCollision(direction) then
        local movementTween

        if direction == "left" then
            player.Position.X = player.Position.X - 1
            --movementTween = TM:Create(player.Position, 12, "X", player.Position.X - 1)
        elseif direction == "right" then
            player.Position.X = player.Position.X + 1
            --movementTween = TM:Create(player.Position, 12, "X", player.Position.X + 1)
        elseif direction == "down" then
            player.Position.Y = player.Position.Y + 1
            --movementTween = TM:Create(player.Position, 12, "Y", player.Position.Y + 1)
        elseif direction == "up" then
            player.Position.Y = player.Position.Y - 1
            --movementTween = TM:Create(player.Position, 12, "Y", player.Position.Y - 1)
        else return
        end
        if direction == "left" or direction == "right" then
            movementTween = TM:Create(player.AbsolutePosition, 10, "X", (player.Position.X - 1) * TILE_SIZE)
        else
            movementTween = TM:Create(player.AbsolutePosition, 10, "Y", (player.Position.Y - 1) * TILE_SIZE)
        end
        movementTween:Play()
    else 
        player.Direction = direction
        return
    end

    player.Direction = direction
    -- local newX = (player.Position.X - 0.5) * TILE_SIZE
    -- local newY = (player.Position.Y - 0.5) * TILE_SIZE
    -- local movementTween = Tween.new(15, player.AbsolutePosition, {newX, newY}, "linear")
    -- movementTween:update()

    print(player.Position)
end

function DetermineCollision(direction)
    local associatedDirections = {}
    local tileIds = {}

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

return Overworld