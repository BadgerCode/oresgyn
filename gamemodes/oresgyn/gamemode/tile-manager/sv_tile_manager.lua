util.AddNetworkString(NET_TILE_COUNT_UPDATE)
util.AddNetworkString(NET_TOWER_COUNT_UPDATE)

local function DoesPlayerOwnANeighbouringTile(ply, tile)
    return IsValid(tile.TopNeighbour) and tile.TopNeighbour.OwnerPlayer == ply
        or IsValid(tile.LeftNeighbour) and tile.LeftNeighbour.OwnerPlayer == ply
        or IsValid(tile.RightNeighbour) and tile.RightNeighbour.OwnerPlayer == ply
        or IsValid(tile.BottomNeighbour) and tile.BottomNeighbour.OwnerPlayer == ply
end

function GM:PlayerTouchedTile(ply, tile)
    local plyPreviousTile = ply:GetActiveTile()
    if IsValid(plyPreviousTile) and plyPreviousTile.OwnerPlayer == ply then
        plyPreviousTile:RemoveProtectionFromPlayer()
    end

    ply:SetActiveTile(tile)

    if(!isRoundActive()) then return end

    local currentOwner = tile.OwnerPlayer

    if(currentOwner == ply) then
        tile:AddProtectionFromPlayer()
    elseif(!tile:IsProtected() and DoesPlayerOwnANeighbouringTile(ply, tile)) then
        tile:SetOwnerPlayer(ply)
        tile.OwnerPlayer:AddTile()
        tile:AddProtectionFromPlayer()
        tile:CheckProtectionFromNeighbourTowers()

        if(IsValid(currentOwner)) then
            currentOwner:RemoveTile()
            RecalculateIncome(currentOwner)
        end

        RecalculateIncome(ply)
    end
end

function GM:PlayerPurchaseTower(ply)
    if(!ply:OwnsActiveTile()) then return end
    if(ply:GetActiveTile():HasTower()) then return end
    if(!CanPlayerAffordTower(ply)) then return end
    
    local tower = ents.Create("map_tower")
    if !IsValid(tower) then return end

    local activeTile = ply:GetActiveTile()

    activeTile:SetTower(tower)

    tower.ProtectedTile = activeTile
    tower:SetPos(activeTile:GetPos() + Vector(0, 0, 10))
    tower:SetOwner(ply)
    tower:Spawn()

    BuyTower(ply)
    ply:AddOwnedTower(tower)

    UpdatePlayerFinances(ply)
end