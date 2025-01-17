local Queue = {}
Queue.__index = Queue

function Queue.new()
    local instance = setmetatable({}, Queue)

    instance._array = Queue

    return instance
end

function Queue:enqueue(action, priority, speed)
    assert(type(priority) == "number", "action priority must be a number!")
    assert(type(speed) == "number" or nil, "action speed must be a number or nil!")

    local field = {
        action,
        priority,
        speed
    }

    table.insert(self._array, 1, field)
end

function Queue:dequeue()
    return table.remove(self._array, 1)
end

function Queue:sort()
    for i = 1, #self._array do
        local max_idx = i
        for max_candidate_idx = i + 1, #self._array do
            if self._array[max_candidate_idx][2] > self._array[max_idx][2] then
                max_idx = max_candidate_idx
            elseif self._array[max_candidate_idx][2] == self._array[max_idx][2] then
                if self._array[max_candidate_idx][3] > self._array[max_idx][3] then
                    max_idx = max_candidate_idx
                end
            end
        end
        self._array[i], self._array[max_idx] = self._array[max_idx], self._array[i]
    end
end

return Queue