local Gamestate = {}
Gamestate.__index = Gamestate

function Gamestate:load(manager)
    local instance = setmetatable({}, Gamestate)

    instance._manager = manager

    return instance
end

function Gamestate:unload() return end

function Gamestate:draw() return end

function Gamestate:update(dt) return end

function Gamestate:keypressed(key, scancode, isRepeat) return end