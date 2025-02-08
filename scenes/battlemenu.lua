--MODULES
local Button = require("/lib/ui/button")
--BUTTONS
local Attack = Button.new(128, 128, 128, 64, "clicky")
local yourHealth = 100
local theirHealth = 100
--
local BattleMenu = {}

function BattleMenu.draw()
    Attack:draw()
end

function BattleMenu.update(dt)
    Attack:update(dt)
end

function BattleMenu.onSceneBegin()
    Attack.Clicked:Connect(function() 

    end)
end

function BattleMenu.onSceneEnd()
    Attack.Clicked:Disconnect()
end

return BattleMenu