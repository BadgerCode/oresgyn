-- -704.000000 -576.000000 -12287.280273

local mapGenerated = false

function generateMap()
    mapGenerated = true
    print("Map generated")
end

function destroyMap()
    if(!mapGenerated) then return end
    mapGenerated = false
    print("Map destroyed")
end