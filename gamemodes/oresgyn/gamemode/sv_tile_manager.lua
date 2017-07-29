function GM:PlayerTouchedTile(ply, tile)
    local plyPreviousTile = ply:GetActiveTile()
    if IsValid(plyPreviousTile) and plyPreviousTile.OwnerPlayer == ply then
        plyPreviousTile:RemoveProtectionFromPlayer()
    end

    ply:SetActiveTile(tile)

    local currentOwner = tile.OwnerPlayer

    if(currentOwner == ply) then
        tile:AddProtectionFromPlayer()
    elseif(!tile:IsProtected()) then
        tile.OwnerPlayer = ply
        tile:SetColor(tile.OwnerPlayer.tileColour)
        tile.OwnerPlayer:AddTile()
        tile:AddProtectionFromPlayer()

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

    activeTile:SetHasTower(true)

    tower.ProtectedTile = activeTile
    tower:SetPos(activeTile:GetPos() + Vector(0, 0, 10))
    tower:SetOwner(ply)
    tower:Spawn()

    BuyTower(ply)
    ply:AddOwnedTower(tower)

    UpdatePlayerFinances(ply)
end