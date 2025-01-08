--MODULES
local Button = require("/modules/ui/button")
local GamestateManager = require("/modules/gamestate-manager")
--GAMESTATE MANAGER
_G.GSM = GamestateManager.new()
GSM:switch('mainmenu')
--i need to organize everything in this section
local inputDisplay = "pressed nothing"

function love.draw()
    love.graphics.print(inputDisplay, 5, 5)
    GSM:draw()
end

function love.update(dt)
    GSM:update(dt)
end

function love.keypressed(key, scanCode, isRepeat)
    inputDisplay = "pressed ".. key
    GSM:keypressed(key, scanCode, isRepeat)
end

function love.keyreleased(key, scanCode)
    GSM:keyreleased(key, scanCode)
end

love.window.setTitle("aaaaaaaaaaaaaaaaaaaaaaaaaa")
--love.window.setFullscreen(true)