--MODULES
local Button = require("/lib/ui/button")
local SceneManager = require("/lib/scene-manager")
--SCENE MANAGER
_G.SM = SceneManager.new()
SM:switch('mainmenu')
--i need to organize everything in this section
local inputDisplay = "pressed nothing"

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
end

function love.draw()
    love.graphics.print(inputDisplay, 5, 5)
    SM:draw()
end

function love.update(dt)
    SM:update(dt)
end

function love.keypressed(key, scanCode, isRepeat)
    inputDisplay = "pressed ".. key
    SM:keypressed(key, scanCode, isRepeat)
end

function love.keyreleased(key, scanCode)
    SM:keyreleased(key, scanCode)
end

love.window.setTitle("aaaaaaaaaaaaaaaaaaaaaaaaaa")
--love.window.setFullscreen(true)