local window = nil

function GM:InitialiseHUDUpgradeOptions()
	print("Init hud upgrade")
	window = vgui.Create( "DFrame" )
	window:SetSize( 200,200 )
	window:Center()
	window:SetTitle( "DModelPanel Test" )
	window:MakePopup()
	 
	local icon = vgui.Create( "DModelPanel", window )
	icon:SetModel( "models/props_junk/wood_crate001a.mdl" )
	 
	icon:SetSize( 100, 100 )
	icon:SetCamPos( Vector( 50, 50, 120 ) )
	icon:SetLookAt( Vector( 0, 0, 0 ) )
end

function GM:RemoveHUDUpgradeOptions()
	window:Remove()
end
