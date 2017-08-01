local STARTING_TILES_PER_PLAYER = 24
local MIN_WIDTH_OR_HEIGHT = 4

local mapMiddle = Vector(-128.000000, 384.000000, -12287.080078)
local mapTileSize = { x = 142.600006, y = 142.599991 }

local mapSize = { width = 25, height = 25 }
local mins = { 
    x = mapMiddle.x - (mapSize.width * mapTileSize.x) / 2,
    y = mapMiddle.y - (mapSize.height * mapTileSize.y) / 2
}

local mapGenerated = false

local numTiles = 0
local mapTiles = {}

function GetNumTotalTiles()
    return numTiles
end

local function CalculateMapSize()
    local numPlayers = player.GetCount()
    numTiles = numPlayers * STARTING_TILES_PER_PLAYER
    local maxWidth = numTiles / MIN_WIDTH_OR_HEIGHT

    mapSize.width = math.random(MIN_WIDTH_OR_HEIGHT, maxWidth)
    mapSize.height = math.Round(numTiles / mapSize.width)
end

local function CalculateMinimumCorner()
    mins.x = mapMiddle.x - (mapSize.width * mapTileSize.x) / 2 
    mins.y = mapMiddle.y - (mapSize.height * mapTileSize.y) / 2
end

local function GenerateMapSpawns()
    local usedSpawns = { }

    for k, ply in pairs(player.GetAll()) do
        local x = 0
        local y = 0
        local spawnExists = true
        while(spawnExists) do
            x = math.random(0, mapSize.width - 1)
            y = math.random(0, mapSize.height - 1)

            spawnExists = usedSpawns[x] and usedSpawns[x][y]
        end

        ply.SpawnTile = mapTiles[x][y]
    end
end

function GenerateMap()
    if(mapGenerated) then return end
    mapGenerated = true
    mapTiles = {}

    CalculateMapSize()
    CalculateMinimumCorner()

    local pos = mapMiddle
    pos.x = mins.x

    for i=0, mapSize.width - 1, 1 do
        mapTiles[i] = {}
        pos.y = mins.y

        for j=0, mapSize.height - 1, 1 do
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

                    if(i == mapSize.width - 1) then
                        plate:AddTopWall()
                    end
                end

                if(j == 0) then
                    plate:AddRightWall()
                else
                    plate.RightNeighbour = mapTiles[i][j - 1]
                    plate.RightNeighbour.LeftNeighbour = plate

                    if(j == mapSize.height - 1) then
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
