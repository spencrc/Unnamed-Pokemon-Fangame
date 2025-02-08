--MODULES
local Constants = require("/lib/constants")
local Vector2 = require("/lib/vector2")
--
local Entity = {}
Entity.__index = Entity

local function initializeQuads(tileset, entitySize)
    local quads = {}
    local tilesetWidth, tilesetHeight = tileset:getDimensions()
    for col = 1, tilesetHeight/entitySize, 1 do
        quads[col] = {}
        for row = 1, tilesetWidth/entitySize, 1 do
            quads[col][row] = 0
            quads[col][row] = love.graphics.newQuad(
                (row-1)*entitySize,
                (col-1)*entitySize,
                entitySize,
                entitySize,
                tileset,
                tileset
            )
        end
    end
    return quads
end

function Entity.new(tileset, entitySize)
    local instances = setmetatable({}, Entity)

    --POSITIONAL DATA
    instances.Position = Vector2.new(1, 1)
    instances.AbsolutePosition = Vector2.new(0, 0)
    --TEXTURE DATA
    instances._tileset = tileset
    instances._quads = initializeQuads(tileset, entitySize)
    instances._entitySize = entitySize
    --MOVEMENT DATA
    instances.MoveDir = nil --movement direction
    instances.Direction = "down" --facing direction
    instances.IsMoving = false
    instances._moveAnimationCycle = 1 --current frame the animation is on
    instances._moveAnimationFramesElapsed = 0 --number of frames elapsed since last animation frame change

    return instances
end

function Entity:drawSprite()
    local spriteCol = 1

    if self.Direction == "down" then
        spriteCol = 1
    elseif self.Direction == "left" then
        spriteCol = 2
    elseif self.Direction == "right" then
        spriteCol = 3
    elseif self.Direction == "up" then
        spriteCol = 4
    else error(self.Direction.." is not a valid direction!")
    end --IS BASED ON THE IDEA THAT ALL ENTITY SPRITES HAVE 4 DIRECTIONS

    if self.IsMoving == true or self._moveAnimationCycle > 1 then
        self._moveAnimationFramesElapsed = self._moveAnimationFramesElapsed + 1 --increments each frame
        if self._moveAnimationFramesElapsed >= 6 then --IS BASED ON THE IDEA THAT ENTITY SPRITES HAVE 4 FRAMES IN ANIMATION
            if (self._moveAnimationCycle + 1) > 4 or self.IsMoving == false then --checks if next cycle would be out of bounds if simply incrementing
                self._moveAnimationCycle = 1 --wraps around animation cycle
            else
                self._moveAnimationCycle = self._moveAnimationCycle + 1 --increments animation cycle
            end
            self._moveAnimationFramesElapsed = 0 --resets time elapsed since frame has changed
        end
    end

    love.graphics.draw(
        self._tileset, --tileset
        self._quads[spriteCol][self._moveAnimationCycle], --selects quad to use (Quads[col][row])
        self.AbsolutePosition.X, --x position
        self.AbsolutePosition.Y, --y position
        2*math.pi,--angle in radians
        Constants.TILE_SIZE/self._entitySize, --x scale
        Constants.TILE_SIZE/self._entitySize --y scale
    )
end

function Entity:draw()
    self:drawSprite()
end

return Entity
