--modules
local Vector2 = require("/lib/vector2")
--
local MovementHelpers = {}

local CollisionData = {
    ["all"] = {2}; --list of tiles that are collidable from all sides

    ["top"] = {5}; --list of tiles collidable from its top side only, meaning you cannot move down into it
    ["left"] = {3}; --list of tiles collidable from its left side only, meaning you cannot press right into it
    ["right"] = {6}; --list of tiles collidable from its right side only, meaning you cannot press left into it
    ["bottom"] = {4}; --list of tiles collidable from its top side only, meaning you cannot move up into it

    ["topleft"] = {8}; --list of tiles collidable from its top side and left side, meaning you cannot move down OR press right into it
    ["topright"] = {10}; --list of tiles collidable from its top side and right side, meaning you cannot move down OR press left into it
    ["bottomleft"] = {7}; --list of tiles collidable from its bottom side and left side, meaning you cannot move up OR press right into it
    ["bottomright"] = {9}; --list of tiles collidable from its bottom side and right side, meaning you cannot move up OR press left into it
    ["leftright"] = {11}; --list of tiles collidable from the left and right only, meaning you cant press left OR right into it
    ["topbottom"] = {12} --list of tiles collidable from its top and bottom only, meaning you cant press up OR down into it
}

function MovementHelpers.MovePlayer(direction, playerVector, tileSize, map)
    local newVector = Vector2.new(playerVector.X, playerVector.Y)
    local newAbsolute = Vector2.new()

    if not DetermineCollision(direction, playerVector, map) then
        if direction == "left" then
            newVector.X = playerVector.X - 1
        elseif direction == "right" then
            newVector.X = playerVector.X + 1
        elseif direction == "down" then
            newVector.Y = playerVector.Y + 1
        elseif direction == "up" then
            newVector.Y = playerVector.Y - 1
        end
    end

    newAbsolute.X = (newVector.X - 0.5) * tileSize
    newAbsolute.Y = (newVector.Y - 0.5) * tileSize

    return newVector, newAbsolute
end

return MovementHelpers