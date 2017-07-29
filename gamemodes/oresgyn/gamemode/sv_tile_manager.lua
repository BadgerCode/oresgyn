
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

        if(IsValid(tile.Tower)) then
            tile.Tower:Remove()
            tile.has_tower = false
        end

        RecalculateIncome(ply)
    end
end