local Pokemon = {}
Pokemon.__index = Pokemon

function Pokemon.new()
    local instance = setmetatable({}, Pokemon)

    instance.name = ""
    instance.level = 0
    instance.gender = "male"
    instance.happiness = 0
    instance.pokeball = "normal"
    instance.weight = 0
    instance.hp = 0
    instance.fainted = false

    instance.baseSpecies = ""
    instance.species = ""

    instance.statBonuses = {}
    instance.ivs = {}
    instance.evs = {}

    instance.status = 0
    instance.volatiles = {}

    instance.baseAbility = 0
    instance.ability = 0

    instance.item = 0
    instance.itemUsed = false

    instance.trapped = false

    instance.lastMove = 0
    instance.encore = false
    instance.currentMove = 0

    instance.isActive = false

    return instance
end

return Pokemon