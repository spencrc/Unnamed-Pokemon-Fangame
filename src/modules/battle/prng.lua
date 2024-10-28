local PRNG = {}
PRNG.__index = PRNG

function PRNG.new(seed) --IMPLEMENTATION OF MULTIPLY-WITH-CARRY FROM THIS GITHUB: https://github.com/linux-man/randomlua/blob/master/randomlua.lua
    local instances = setmetatable({}, PRNG) --did u think i know enough about cryptology or reading the wikipedia page to do this myself ???

    instances.a = 1103515245
    instances.c = 12345
    instances.m = 0x10000
    instances.ic = instances.c
    instances.x = nil

    instances:randomseed(seed)

    return instances
end

function PRNG:randomseed(seed)
    if not seed then 
        seed = os.time() % 2 ^ 31
    end
    self.c = self.ic
    self.x = seed % 2 ^ 31
end

function PRNG:random(a, b)
    local t = self.a * self.x + self.c
    local y = t % self.m

    self.x = y
    self.c = math.floor(t / self.m)

    if not a then return y / 0x10000
    elseif not b then
        if a == 0 then return y
        else return 1 + (y % a) end
    else return a + y % (b - a + 1) end
end

function PRNG:rolledAtMostNumber(n, a, b)
    local roll = self:random(a, b)
    if n <= roll then return true end
    return false
end

function PRNG:rolledExactNumber(n, a, b)
    local roll = self:random(a, b)
    if n == roll then return true end
    return false
end

function PRNG:rolledAtLeastNumber(n, a, b)
    local roll = self:random(a, b)
    if n >= roll then return true end
    return false
end

function PRNG:coinFlip()
    local roll = self:random(1, 2)
    if roll == 1 then return true end
    return false
end

return PRNG