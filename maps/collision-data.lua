local CollisionData = {
    ["all"] = {1}; --list of tiles that are collidable from all sides

    ["top"] = {2}; --list of tiles collidable from its top side only, meaning you cannot move down into it
    ["left"] = {3}; --list of tiles collidable from its left side only, meaning you cannot press right into it
    ["right"] = {4}; --list of tiles collidable from its right side only, meaning you cannot press left into it
    ["bottom"] = {5}; --list of tiles collidable from its top side only, meaning you cannot move up into it

    ["topleft"] = {6}; --list of tiles collidable from its top side and left side, meaning you cannot move down OR press right into it
    ["topright"] = {7}; --list of tiles collidable from its top side and right side, meaning you cannot move down OR press left into it
    ["bottomleft"] = {8}; --list of tiles collidable from its bottom side and left side, meaning you cannot move up OR press right into it
    ["bottomright"] = {9}; --list of tiles collidable from its bottom side and right side, meaning you cannot move up OR press left into it
    
    ["leftright"] = {10}; --list of tiles collidable from the left and right only, meaning you cant press left OR right into it
    ["topbottom"] = {11} --list of tiles collidable from its top and bottom only, meaning you cant press up OR down into it
}

local newattempt = {
}

return CollisionData, newattempt