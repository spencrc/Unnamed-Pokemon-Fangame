--MODULES
local Button = require("/lib/ui/button")
local SceneManager = require("/lib/scene-manager")
local Queue = require("/lib/battle/actionqueue")
--SCENE MANAGER
_G.SM = SceneManager.new()
SM:switch('mainmenu')
--i need to organize everything in this section
local inputDisplay = "pressed nothing"

function love.load()
    print("START")
    -- local q = Queue.new()
    -- q:enqueue("A", 1, 1)
    -- q:enqueue("B", 2, 1)
    -- q:enqueue("C", 1, 1)
    -- q:enqueue("D", 1, 2)
    -- q:enqueue("E", 0, 100)
    -- q:enqueue("F", 100, 0)
    -- q:sort()
    -- for i = 1, 6 do
    --     local e = q:dequeue()
    --     print(e[1])
    -- end
    -- print("END")
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

love.window.setTitle("Pokemon")
--love.window.setFullscreen(true)