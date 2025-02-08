local SceneManager = {}
SceneManager.__index = SceneManager

function SceneManager.new()
    local instances = setmetatable({}, SceneManager)

    instances.currentScene = nil

    return instances
end

function SceneManager:switch(scene)
    if self.currentScene and self.currentScene.onSceneEnd then 
        self.currentScene.onSceneEnd() 
    end

    self.currentScene = require("/scenes/"..scene)
    assert(self.currentScene, "invalid scene name given when attempting to switch scenes!")

    if self.currentScene.onSceneBegin then 
        self.currentScene.onSceneBegin() 
    end
end

function SceneManager:update(dt)
    assert(self.currentScene, "there must be a valid scene before attempting an update!")
    if self.currentScene.update then
        self.currentScene.update(dt)
    end
end

function SceneManager:draw()
    assert(self.currentScene, "there must be a valid scene before attempting to draw!")
    if self.currentScene.draw then
        self.currentScene.draw()
    end
end

function SceneManager:keypressed(key, scanCode, isRepeat)
    assert(self.currentScene, "there must be a valid scene before attempting to detect key presses!")
    if self.currentScene.keypressed then
        self.currentScene.keypressed(key, scanCode, isRepeat)
    end
end

function SceneManager:keyreleased(key, scanCode)
    assert(self.currentScene, "there must be a valid scene before attempting to detect key releases!")
    if self.currentScene.keyreleased then
        self.currentScene.keyreleased(key, scanCode)
    end
end

return SceneManager