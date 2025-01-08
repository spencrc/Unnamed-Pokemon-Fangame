--MODULES
local Tween = require("/modules/tween")
--
local TweenManager = {}
TweenManager.__index = TweenManager

function TweenManager.new()
    local instance = setmetatable({}, TweenManager)

    instance._active = {}
    instance._instancesUpdatedThisFrame = {}

    return instance
end

function TweenManager:Create(target, duration, propertyName, endGoal, easingStyle)
    local newTween = Tween.new(self, target, duration, propertyName, endGoal, easingStyle)
    return newTween
end

function TweenManager.linear(ratio) return ratio end
-- function TweenManager.quad(r) return r * r end
-- function TweenManager.cubic(r) return r * r * r end
-- function TweenManager.quart(r) return r * r * r *r end
-- function TweenManager.quint(r) return r * r * r * r * r end
-- function TweenManager.exponential(r) return 2 ^ (10 * (r -1)) end
--https://easings.net/ <-- IF NEED MORE

local function find(table, element)
    if #table <= 0 then return false end
    for i, v in pairs (table) do
        if v == element then
            return true
        end
    end
end

function TweenManager:update(dt)
    for i, t in pairs (self._active) do
        if t.PlaybackState == "Cancelled" then
            table.remove(self._active, i)
        elseif t.PlaybackState == "Playing" or t.PlaybackState == "Queued" or t.PlaybackState == "Begin" then
            local difference = t._endGoal - t._start
            local easing = self[t._easingStyle](t._duration / t._maxDuration)

            if not find(self._instancesUpdatedThisFrame, t._target) then
                if t.PlaybackState ~= "Playing" then
                    t._start = t._target[t._propertyName]
                    t.PlaybackState = "Playing"
                end
                table.insert(self._instancesUpdatedThisFrame, t._target)

                if t._duration >= t._maxDuration then
                    t._target[t._propertyName] = t._endGoal
                    t.PlaybackState = "Completed"
                    t.Completed:Invoke()
                    table.remove(self._active, i)
                else
                    t._target[t._propertyName] = math.floor(t._start + difference * easing)
                    t._duration = t._duration + 1
                end
            else
                t.PlaybackState = "Queued"
            end
        end
    end
    self._instancesUpdatedThisFrame = {}
end

function TweenManager:add(tween)
    table.insert(self._active, tween)
end

return TweenManager