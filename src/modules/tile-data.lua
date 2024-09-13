--MODULES
local Tile = require("/modules/tile")
--
local Tiles = {
    ["."] = Tile.new(0, 0); --PLAIN, EMPTY TILE
    ["#"] = Tile.new(1, 0, "all"); --FILLED TILE
    ["="] = Tile.new(11, 0, "topbottom"); --TOP-AND-BOTTOM FILLED TILE
}

return Tiles