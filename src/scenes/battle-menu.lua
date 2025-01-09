--MODULES
local Button = require("/lib/ui/button")
--BUTTONS
local Attack = Button.new(128, 128, 128, 64, "clicky")
local yourHealth = 100
local theirHealth = 100
--
local Versus = {}

function Versus.draw()
    Attack:draw()
end

function Versus.update(dt)
    Attack:update(dt)
end

function Versus.onSceneBegin()
    Attack.Clicked:Connect(function() 

    end)
end

function Versus.onSceneEnd()
    Attack.Clicked:Disconnect()
end

return Versus