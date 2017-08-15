local plymeta = FindMetaTable( "Player" )
if not plymeta then Error("FAILED TO FIND PLAYER TABLE") return end

-- TODO: Reset values on player join

function plymeta:GetTileCount()
	return self.tileCount
end

function plymeta:SetTileCount(tileCount)
	self.tileCount = tileCount
end

function plymeta:GetTowerCount()
	return self.towerCount
end

function plymeta:SetTowerCount(towerCount)
	self.towerCount = towerCount
end

function plymeta:GetPctOfMapOwned()
	return self.pctMapOwned
end

function plymeta:SetPctOfMapOwned(pctMapOwned)
	self.pctMapOwned = pctMapOwned
end

function plymeta:ResetTiles()
	self.tileCount = 0
	self.towerCount = 0
	self.pctMapOwned = 0
end

net.Receive(NET_TILE_COUNT_UPDATE, function(len)
	LocalPlayer():SetTileCount(net.ReadInt(32))
	LocalPlayer():SetPctOfMapOwned(net.ReadInt(32))
end)

net.Receive(NET_TOWER_COUNT_UPDATE, function(len)
	LocalPlayer():SetTowerCount(net.ReadInt(32))
end)

