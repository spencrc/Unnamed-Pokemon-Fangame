--MODULES
local Event = require("/modules/event")
--
local Tween = {}
Tween.__index = Tween

function Tween.new(manager, target, duration, propertyName, endGoal, easingStyle)
    local instance = setmetatable({}, Tween)

    assert(type(target) == "table", "target parameter must be a table!")
    assert(type(duration) == "number", "duration parameter must be a number!")
    assert(type(propertyName) == "string", "propertyName parameter must be a string!")
    assert(type(endGoal) == "number", "endGoal parameter must be a number!")
    --PUBLIC
    instance.PlaybackState = "Begin"
    instance.Completed = Event.new()
    --PRIVATE
    instance._manager = manager
    instance._target = target
    instance._duration = 0
    instance._maxDuration = duration
    instance._propertyName = propertyName
    instance._start = target[propertyName]
    instance._endGoal = endGoal
    instance._easingStyle = easingStyle or "linear"

    return instance
end

function Tween:Play()
    if self._duration >= self._maxDuration then
        self._duration = 0
    end
    self._manager:add(self)
end

function Tween:Pause()
    self.PlaybackState = "Paused"
end

function Tween:Cancel()
    self.PlaybackState = "Cancelled"
end

return Tween