--MODULES
local Vector2 = require("/lib/vector2")
local TileData = require("/lib/tile-data")
local TM = require("/lib/tween-manager").new()
--IMPORTANT SYSTEM VARIABLES
local TILE_SIZE = 128
local QUAD_SIZE = 32
local screenWidth, screenHeight = love.graphics.getDimensions()
--MAP DATA
local map_layer1, map_layer2, objects = love.filesystem.load("maps/test-map.lua", "b")()
local mapWidth = #map_layer1
local mapHeight = #map_layer1[1]
local collisionData = love.filesystem.load("maps/collision-data.lua", "b")()
--TILESETS & QUADS
local Tileset = love.graphics.newImage("assets/images/collision-showcase.png")
local PlayerTileset = love.graphics.newImage("assets/images/temp-player.png")
local Quads = {}
--TO BE ORGANIZED
local player = {
    Position = Vector2.new(1, 1);
    AbsolutePosition = Vector2.new(0, 0);
    MoveDir = nil;
    Direction = "down";
    IsMoving = false;
}

--FUNCTIONS
local Overworld = {}

local function loadMap()
    print('running')

    local tilesetWidth, tilesetHeight = Tileset:getDimensions()

    for col = 1, mapHeight, 1 do
        for row = 1, mapWidth, 1 do
            local layer1TileAtPosition = TileData[map_layer1[col][row]]
            local layer2TileAtPosition = TileData[map_layer2[col][row]]

            if not Quads[map_layer1[col][row]] then
                Quads[map_layer1[col][row]] = love.graphics.newQuad(
                    layer1TileAtPosition.Position.X * 32,
                    layer1TileAtPosition.Position.Y * 32,
                    QUAD_SIZE,
                    QUAD_SIZE,
                    tilesetWidth,
                    tilesetHeight
                )
            end
            if not Quads[map_layer2[col][row]] then
                Quads[map_layer2[col][row]] = love.graphics.newQuad(
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

function Overworld.onSceneBegin()
    loadMap()
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
        TILE_SIZE/QUAD_SIZE, --x scale
        TILE_SIZE/QUAD_SIZE --y scale
    )
end

local function drawLayer(layer)
    for col = 1, mapHeight, 1 do
        for row = 1, mapWidth, 1 do
            local TileId = layer[col][row]

            print(TileId)
            print(Quads[TileId])

            if TileId ~= "-" then
                love.graphics.draw(
                    Tileset, --tileset
                    Quads[TileId],  --quad
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

function Overworld.update(dt)
    -- if love.keyboard.isDown("left") then 
    --     MovePlayer("left")
    -- elseif love.keyboard.isDown("right") then
    --     MovePlayer("right")
    -- elseif love.keyboard.isDown("down") then
    --     MovePlayer("down")
    -- elseif love.keyboard.isDown("up") then
    --     MovePlayer("up")
    -- end
end

function Overworld.keypressed(key, scanCode, isRepeat)
    if key == "left" or key == "right" or key == "down" or key == "up" then
        MovePlayer(key)
    elseif key == "escape" then 
        SM:switch("mainmenu")
    end
end

function Overworld.keyreleased(key, scancode)
    if key == "left" or key == "right" or key == "down" or key == "up" then
        if player.MoveDir == key then player.MoveDir = nil end
    end
end

function MovePlayer(direction)
    if player.IsMoving then
        player.MoveDir = direction
        return
    elseif not DetermineCollision(direction) then
        local movementTween = nil

        if direction == "left" then
            player.Position.X = player.Position.X - 1
        elseif direction == "right" then
            player.Position.X = player.Position.X + 1
        elseif direction == "down" then
            player.Position.Y = player.Position.Y + 1
        elseif direction == "up" then
            player.Position.Y = player.Position.Y - 1
        else return
        end

        if direction == "left" or direction == "right" then
            movementTween = TM:Create(player.AbsolutePosition, 12, "X", (player.Position.X - 1) * TILE_SIZE)
        else
            movementTween = TM:Create(player.AbsolutePosition, 12, "Y", (player.Position.Y - 1) * TILE_SIZE)
        end

        player.MoveDir = direction
        player.IsMoving = true
        movementTween:Play()

        movementTween.Completed:Connect(function()
            player.IsMoving = false
            if player.IsMoving ~= nil then
                MovePlayer(player.MoveDir)
            end
            movementTween = nil
        end)
    end
    player.Direction = player.MoveDir or direction
    -- local newX = (player.Position.X - 0.5) * TILE_SIZE
    -- local newY = (player.Position.Y - 0.5) * TILE_SIZE
    -- local movementTween = Tween.new(15, player.AbsolutePosition, {newX, newY}, "linear")
    -- movementTween:update()

    --print(player.Position)
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