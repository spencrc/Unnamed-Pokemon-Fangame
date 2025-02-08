--modules
local RGBA = require ("/lib/rgba")
local Event = require("/lib/event")
local Label = require("/lib/ui/label")
local Vector2 = require("/lib/vector2")
--
local Button = {}
Button.__index = Button
--most of this module was taken from here: https://github.com/bncastle/love2d-tutorial/blob/Episode15/lib/ui/Button.lua
function Button.new(x, y, w, h, text) 
    local instance = setmetatable({}, Button)
    --public field
    instance.Position = Vector2.new(x or 0, y or 0)
    instance.Size = Vector2.new(w or 0, h or 0)
    instance.Label = Label.new(text)
    instance.Colour = RGBA.new()
    instance.HighlightColour = nil
    instance.ClickedColour = nil
    --private field
    instance._enabled = true
    instance._hovered = false
    instance._clicked = false
    --events
    instance.Clicked = Event.new()
    --instance.Hovered = Event.new()

    return instance
end

function Button:colours(regular, highlighted, pressed)
    self.Colour = regular
    if highlighted then self.HighlightColour = highlighted end
    if pressed then self.ClickedColour = pressed end
end

-- function Button:enable(enabled)
--     self._enabled = enabled
-- end

function Button:update(dt)
    if not self._enabled then return end

    local mX, mY = love.mouse.getPosition()
    local clicking = love.mouse.isDown(1)
    local in_bounds = (mX >= self.Position.X - self.Size.X/2 and mX <= self.Position.X + self.Size.X/2 and mY >= self.Position.Y - self.Size.Y/2 and mY <= self.Position.Y + self.Size.Y/2)

    if in_bounds then
        if clicking then
            self.Clicked:Invoke()
        else 
            print('in bounds! doing nothing! woah!')
            --self.Hovered:Invoke()
        end
    end
end

function Button:draw()
    --print(self.Position.X - self.Size.X/2, self.Position.Y - self.Size.Y/2, self.Size.X, self.Size.Y)
    love.graphics.push()

    if self._clicked and self.ClickedColour then
        --apply clicked colour by finishing and using RGB:convert()
        love.graphics.setColor(self.ClickedColour:convert())
    elseif self._hovered and self.HighlightColour then
        love.graphics.setColor(self.HighlightColour:convert())
    else
        love.graphics.setColor(self.Colour:convert())
    end
    
    love.graphics.rectangle("fill", self.Position.X - self.Size.X/2, self.Position.Y - self.Size.Y/2, self.Size.X, self.Size.Y)
    love.graphics.pop()

    self.Label:drawInside(self)
end

return Button