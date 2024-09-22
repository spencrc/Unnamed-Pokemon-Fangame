--MODULES
local Tile = require("/modules/tile")
--
local Tiles = {
    ["-"] = Tile.new(0, 0); --EMPTY TILE NOT MEANT TO BE DRAWN
    ["."] = Tile.new(0, 0); --PLAIN, EMPTY TILE
    ["#"] = Tile.new(1, 0, "all"); --FILLED TILE
    ["["] = Tile.new(2, 0, "left"); --LEFT-SIDE FILLED TILE
    ["]"] = Tile.new(3, 0, "right"); --RIGHT-SIDE FILLED TILE
    ["P1"] = Tile.new(0, 1); --PINE TREE TOP LEFT
    ["P2"] = Tile.new(1, 1); --PINE TREE TOP RIGHT
    ["P3"] = Tile.new(0, 2, "all"); --PINE TREE BOTTOM LEFT
    ["P4"] = Tile.new(1, 2, "all"); --PINE TREE BOTTOM RIGHT
}

return Tiles