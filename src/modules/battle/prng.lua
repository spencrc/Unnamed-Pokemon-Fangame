local bit = require("bit") --library included in LuaJIT
--MODULES
local PRNG = {}
PRNG.__index = PRNG

local function generateSeed()
    return {
        math.floor(math.random() * 0x10000),
        math.floor(math.random() * 0x10000),
        math.floor(math.random() * 0x10000),
        math.floor(math.random() * 0x10000)
    }
end

function PRNG.new(seed)
    local instances = setmetatable({}, PRNG)

    instances.seed = seed or generateSeed()
    instances._initialSeed = {}

    for i, e in pairs(instances.seed) do
        instances._initialSeed[i] = e
    end

    return instances
end

function PRNG:startingSeed()
    return self._initialSeed
end

function PRNG:clone()
    return self.new(self.seed)
end

function PRNG:next(from, to)
    self.seed = self:nextFrame(self.seed)
    local result = (bit.lshift(self.seed[1], 16) + self.seed[2]) % 2^32
    if from then from = math.floor(from) end
    if to then to = math.floor(to) end
    if from == nil then 
        result = result / 0x100000000
    elseif (!to) then
        result = math.floor(result * from / 0x100000000)
    else
        result = math.floor(result * (to - from) / 0x100000000) + from
    end
    return result
end

function PRNG:multiplyAdd(a, b, c)
    local out = {0, 0, 0, 0}
    local carry = 0

    for outIdx = 4, 1, -1 do
        for bIdx = outIdx, 4, 1 do
            local aIdx = 4 - (bIdx - outIdx)
            carry = carry + a[aIdx] * b[bIdx]
        end
        carry = carry + c[outIdx]

        out[outIdx] = bit.band(carry, 0xFFFF)
        carry = carry % 2^16 --% 2^16 is equivalent to JS' >>> 16
    end

    return out
end

function PRNG:nextFrame(seed, framesToAdvance)
    local b = {0x5D58, 0x8B65, 0x6C07, 0x8965}
    local c = {0, 0, 0x26, 0x9EC3}
    local n = framesToAdvance or 0

    for i = 1, n, 1 do
        seed = self:multiplyAdd(seed, b, c)
    end

    return seed
end

return PRNG