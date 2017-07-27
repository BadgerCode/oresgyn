local mapMiddle = Vector(-128.000000, 384.000000, -12287.080078)
local mapTileDimensions = { x = 25, y = 25 }
local mapFeatures = {
    floor = {
        Model = Model("models/hunter/plates/plate3x3.mdl"),
        Size = Vector(142.600006, 142.599991, 3.5)
    }
}
local mins = { 
    x = mapMiddle.x - (mapTileDimensions.x * mapFeatures.floor.Size.x) / 2, 
    y = mapMiddle.y - (mapTileDimensions.y * mapFeatures.floor.Size.y) / 2
}

local mapProps = {}

local mapGenerated = false

function generateMap()
    if(mapGenerated) then return end
    mapGenerated = true

    local pos = mapMiddle
    pos.x = mins.x

    for i=0, mapTileDimensions.x, 1 do
        pos.y = mins.y

        for j=0, mapTileDimensions.y, 1 do
            local plate = ents.Create("map_tile_floor")
            if(IsValid(plate)) then
                table.insert(mapProps, plate)
                plate:SetModel(mapFeatures.floor.Model)
                plate:SetPos(pos)
                plate:Spawn()
            end

            pos.y = pos.y + mapFeatures.floor.Size.y
        end

        pos.x = pos.x + mapFeatures.floor.Size.x
    end

    generateMapSpawns()

    print("Map generated")
end

function generateMapSpawns()
    local usedSpawns = { }

    for k, ply in pairs(player.GetAll()) do
        local x = 0
        local y = 0
        local spawnExists = true
        while(spawnExists) do
            x = math.random(0, mapTileDimensions.x - 1)
            y = math.random(0, mapTileDimensions.y - 1)

            spawnExists = usedSpawns[x] and usedSpawns[x][y]
        end

        ply.SpawnPos = Vector(mins.x + x * mapFeatures.floor.Size.x, mins.y + y * mapFeatures.floor.Size.y, mapMiddle.z + 10)
    end
end

function destroyMap()
    if(!mapGenerated) then return end
    mapGenerated = false

    for k, v in pairs(mapProps) do
        v:Remove()
    end

    table.Empty(mapProps)

    print("Map destroyed")
end