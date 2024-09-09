local Event = {}
Event.__index = Event

function Event.new()
    local instance = setmetatable({}, Event)

    instance._callback = nil

    return instance
end

function Event:Connect(callback)
    assert(type(callback) == "function", "Event must have a function for its callback parameter!")
    self._callback = callback
end

function Event:Disconnect()
    self._callback = nil
end

function Event:Invoke() --should never be called from any non-class module
    if self._callback == nil then return end
    self._callback()
end

return Event