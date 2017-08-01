local plymeta = FindMetaTable( "Player" )
if not plymeta then Error("FAILED TO FIND PLAYER TABLE") return end

function plymeta:ResetScore()
    self.NumTiles = 0
end

function plymeta:AddTile()
    self.NumTiles = self.NumTiles + 1
    CheckForTileOwnershipVictory(self)
end

function plymeta:RemoveTile()
    self.NumTiles = self.NumTiles - 1
end

function plymeta:GetNumTiles()
    return self.NumTiles
end

function plymeta:GetActiveTile()
    return self.ActiveTile
end

function plymeta:SetActiveTile(tileEntity)
    self.ActiveTile = tileEntity
end

function plymeta:OwnsActiveTile()
    return IsValid(self.ActiveTile) and self.ActiveTile.OwnerPlayer == self
end

function plymeta:GetMoney()
    return self.Money
end

function plymeta:AddMoney(amount)
    self.Money = self.Money + amount
end

function plymeta:ResetMoney()
    self.Money = 0
end

function plymeta:ResetOwnedTowers()
    self.OwnedTowers = { }
    self.NumOwnedTowers = 0
end

function plymeta:DestroyLastTower()
    if(self.NumOwnedTowers < 1) then return end

    -- Last tower will have the highest creation Id
    local tower = self.OwnedTowers[table.maxn(self.OwnedTowers)]
    tower.ProtectedTile:RemoveTower()
end

function plymeta:AddOwnedTower(tower)
    self.OwnedTowers[tower:GetCreationID()] = tower
    self.NumOwnedTowers = self.NumOwnedTowers + 1
end

function plymeta:RemoveOwnedTower(tower)
    if (self.OwnedTowers[tower:GetCreationID()] == nil) then return end

    self.OwnedTowers[tower:GetCreationID()] = nil
    self.NumOwnedTowers = self.NumOwnedTowers - 1

    UpdatePlayerFinances(self)
end

function plymeta:GetNumOwnedTowers()
    return self.NumOwnedTowers
end