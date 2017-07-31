
local D_FORWARD, D_LEFT, D_DOWN, D_RIGHT = 1, 2, 3, 4

local function GetTargettedTile(ply)
    local activeTile = ply:GetActiveTile()
    local targetTile = nil

    if(activeTile.OwnerPlayer != ply) then
        targetTile = activeTile
    else
        local direction = (math.Round((ply:GetAngles().y % 360) / 90) % 4) + 1
        local neighbour = nil

        if(direction == D_FORWARD) then
            targetTile = activeTile.TopNeighbour
        elseif(direction == D_LEFT) then
            targetTile = activeTile.LeftNeighbour
        elseif(direction == D_DOWN) then
            targetTile = activeTile.BottomNeighbour
        elseif(direction == D_RIGHT) then
            targetTile = activeTile.RightNeighbour
        end

        if IsValid(targetTile) and targetTile.OwnerPlayer == ply then return nil end
    end

    return targetTile
end

function GM:PlayerAttacked(ply)
    local targetTile = GetTargettedTile(ply)

    if targetTile == nil or !targetTile:HasTower() then return end

    targetTile:DamageTower()
end