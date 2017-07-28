AddCSLuaFile()

local plymeta = FindMetaTable( "Player" )
if not plymeta then Error("FAILED TO FIND PLAYER TABLE") return end

function plymeta:ResetScore()
    self.NumTiles = 0
end

function plymeta:AddTile()
    self.NumTiles = self.NumTiles + 1
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

function plymeta:GetMoney()
    return self.Money
end

function plymeta:AddMoney(amount)
    self.Money = self.Money + amount
end

function plymeta:ResetMoney()
    self.Money = 0
end