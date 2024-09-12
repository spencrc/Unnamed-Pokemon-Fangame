local layer1 = {
    {1,2,1,1};
    {1,1,12,1};
    {1,1,1,1};
    {1,1,1,1};
}

local layer2 = {
    {0, 0, 0, 0};
    {0, 0, 0, 0};
    {0, 0, 1, 2};
    {0, 0, 3, 4};
}

local objects = {}

local collision_map = {
    {0, 0, 0, 0};
    {0, 0, 0, 0};
    {0, 0, 0, 0};
    {0, 0, 0, 0};
}

return layer1, layer2