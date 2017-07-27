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

function plymeta:GetActiveTile()
    return self.ActiveTile
end

function plymeta:SetActiveTile(tileEntity)
    self.ActiveTile = tileEntity
end
