
function assignPlayersColours()
	local players = player.GetAll()
	local hue = math.random(0, 360)
	local goldenRatioConjugate = 0.618033988749895

	for k, ply in pairs(players) do
		ply.tileColour = HSVToColor(hue % 360, 0.65, 0.85)
		hue = hue + (360 * goldenRatioConjugate)
	end
end
