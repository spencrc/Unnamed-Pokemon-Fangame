local Scene = {}
Scene.__index = Scene

function Scene:load(manager)
    local instance = setmetatable({}, Scene)

    instance._manager = manager

    return instance
end

function Scene:unload() return end

function Scene:draw() return end

function Scene:update(dt) return end

function Scene:keypressed(key, scancode, isRepeat) return end