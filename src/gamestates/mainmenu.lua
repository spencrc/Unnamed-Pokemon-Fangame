--MODULES
local Button = require("/modules/ui/button")
--
local tester = Button.new(128, 128, 128, 64, "clicky")
local switcher = Button.new(128, 256, 128, 128, "yowch")
--FUNCTIONS
local MainMenu = {}

function MainMenu.draw()
    tester:draw()
    switcher:draw()
end

function MainMenu.update(dt)
    tester:update(dt)
    switcher:update(dt)
end

function MainMenu.onStateBegin()
    tester.Clicked:Connect(function()
        print('click clack')
    end)
    switcher.Clicked:Connect(function()
        GSM:switch("overworld")
    end)
end

function MainMenu.onStateEnd()
    tester.Clicked:Disconnect()
    switcher.Clicked:Disconnect()
end

return MainMenu