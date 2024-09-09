local GamestateManager = {}
GamestateManager.__index = GamestateManager

function GamestateManager.new()
    local instances = setmetatable({}, GamestateManager)

    instances.currentState = nil

    return instances
end

function GamestateManager:switch(gamestate)
    if self.currentState and self.currentState.onStateEnd then 
        self.currentState.onStateEnd() 
    end

    self.currentState = require("/gamestates/"..gamestate)
    assert(self.currentState, "invalid gamestate name given when attempting to switch gamestates!")

    if self.currentState.onStateBegin then 
        self.currentState.onStateBegin() 
    end
end

function GamestateManager:update(dt)
    assert(self.currentState, "there must be a valid gamestate before attempting an update!")
    if self.currentState.update then
        self.currentState.update(dt)
    end
end

function GamestateManager:draw()
    assert(self.currentState, "there must be a valid gamestate before attempting to draw!")
    if self.currentState.draw then
        self.currentState.draw()
    end
end

function GamestateManager:keypressed(key, scanCode, isRepeat)
    assert(self.currentState, "there must be a valid gamestate before attempting to draw!")
    if self.currentState.keypressed then
        self.currentState.keypressed(key, scanCode, isRepeat)
    end
end

return GamestateManager