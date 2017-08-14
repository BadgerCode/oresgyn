local plymeta = FindMetaTable( "Player" )
if not plymeta then Error("FAILED TO FIND PLAYER TABLE") return end

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

net.Receive(NET_TILE_COUNT_UPDATE, function(len)
	LocalPlayer():SetTileCount(net.ReadInt(32))
end)

net.Receive(NET_TOWER_COUNT_UPDATE, function(len)
	LocalPlayer():SetTowerCount(net.ReadInt(32))
end)

