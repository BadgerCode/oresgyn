local mapMiddle = Vector(-128.000000, 384.000000, -12287.080078)
local mapDimensionsInTiles = { x = 25, y = 25 }
local mapTileSize = { x = 142.600006, y = 142.599991 }
local mins = { 
    x = mapMiddle.x - (mapDimensionsInTiles.x * mapTileSize.x) / 2, 
    y = mapMiddle.y - (mapDimensionsInTiles.y * mapTileSize.y) / 2
}

local mapGenerated = false

local mapTiles = {}

local function CalculateMapSize()

end

local function GenerateMapSpawns()
    local usedSpawns = { }

    for k, ply in pairs(player.GetAll()) do
        local x = 0
        local y = 0
        local spawnExists = true
        while(spawnExists) do
            x = math.random(0, mapDimensionsInTiles.x - 1)
            y = math.random(0, mapDimensionsInTiles.y - 1)

            spawnExists = usedSpawns[x] and usedSpawns[x][y]
        end

        ply.SpawnTile = mapTiles[x][y]
    end
end

function GenerateMap()
    if(mapGenerated) then return end
    mapGenerated = true
    mapTiles = {}

    local pos = mapMiddle
    pos.x = mins.x

    for i=0, mapDimensionsInTiles.x - 1, 1 do
        mapTiles[i] = {}
        pos.y = mins.y

        for j=0, mapDimensionsInTiles.y - 1, 1 do
            local plate = ents.Create("map_tile_floor")
            if(IsValid(plate)) then
                mapTiles[i][j] = plate
                plate:SetPos(pos)
                plate:Spawn()

                if(i == 0) then
                    plate:AddBottomWall()
                else
                    plate.BottomNeighbour = mapTiles[i - 1][j]
                    plate.BottomNeighbour.TopNeighbour = plate

                    if(i == mapDimensionsInTiles.x - 1) then
                        plate:AddTopWall()
                    end
                end

                if(j == 0) then
                    plate:AddRightWall()
                else
                    plate.RightNeighbour = mapTiles[i][j - 1]
                    plate.RightNeighbour.LeftNeighbour = plate

                    if(j == mapDimensionsInTiles.y - 1) then
                        plate:AddLeftWall()
                    end
                end
            end

            pos.y = pos.y + mapTileSize.y
        end

        pos.x = pos.x + mapTileSize.x
    end

    GenerateMapSpawns()

    print("Map generated")
end

function DestroyMap()
    if(!mapGenerated) then return end
    mapGenerated = false

    for k, col in pairs(mapTiles) do
        for _, tile in pairs(col) do
            tile:Remove()
        end
    end

    table.Empty(mapTiles)

    print("Map destroyed")
end
