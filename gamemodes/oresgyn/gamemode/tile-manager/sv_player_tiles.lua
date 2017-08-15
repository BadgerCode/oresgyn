util.AddNetworkString(NET_TILE_COUNT_UPDATE)
util.AddNetworkString(NET_TOWER_COUNT_UPDATE)

local plymeta = FindMetaTable( "Player" )
if not plymeta then Error("FAILED TO FIND PLAYER TABLE") return end

local function SendTileCount(ply)
    local pctMapOwned = math.Round((ply:GetNumTiles() / GetNumTotalTiles()) * 100)

    net.Start(NET_TILE_COUNT_UPDATE)
        net.WriteInt(ply:GetNumTiles(), 32)
        net.WriteInt(pctMapOwned, 32)
    net.Send(ply)
end

local function SendTowerCount(ply)
    net.Start(NET_TOWER_COUNT_UPDATE)
        net.WriteInt(ply:GetNumOwnedTowers(), 32)
    net.Send(ply)
end

function plymeta:ResetTileCount()
    self.NumTiles = 0
    SendTileCount(self)
end

function plymeta:AddTile()
    self.NumTiles = self.NumTiles + 1
    CheckForTileOwnershipVictory(self)

    SendTileCount(self)
end

function plymeta:RemoveTile()
    self.NumTiles = self.NumTiles - 1
    if(self.NumTiles < 1) then
        self:Lose()
    end

    SendTileCount(self)
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

function plymeta:ResetOwnedTowers()
    self.OwnedTowers = { }
    self.NumOwnedTowers = 0

    SendTowerCount(self)
end

function plymeta:DestroyLastTower()
    if(self.NumOwnedTowers < 1) then return end

    -- Last tower will have the highest creation Id
    local tower = self.OwnedTowers[table.maxn(self.OwnedTowers)]
    tower.ProtectedTile:RemoveTower()

    SendTowerCount(self)
end

function plymeta:AddOwnedTower(tower)
    self.OwnedTowers[tower:GetCreationID()] = tower
    self.NumOwnedTowers = self.NumOwnedTowers + 1

    SendTowerCount(self)
end

function plymeta:RemoveOwnedTower(tower)
    if (self.OwnedTowers[tower:GetCreationID()] == nil) then return end

    self.OwnedTowers[tower:GetCreationID()] = nil
    self.NumOwnedTowers = self.NumOwnedTowers - 1

    UpdatePlayerFinances(self)
    SendTowerCount(self)
end

function plymeta:GetNumOwnedTowers()
    return self.NumOwnedTowers
end