include("shared.lua")
include("rounds/cl_rounds.lua")

function GM:CalcView(ply, origin, angles, fox, znear, zfar)
    if(!ply:IsSpectator()) then
        local view = { }

        view.origin = origin + Vector(0, 0, 400)
        view.angles = Vector(90, 0, 0)
        view.fov = fov
        view.drawviewer = true
        return view
    end
end

function GM:OnPlayerChat(ply, text, teamChat, isDead)
	if string.sub(text, 1, 4) == "stop" then
		local ProtectionSymbol = ClientsideModel("models/props_c17/streetsign004e.mdl")
        --ProtectionSymbol:SetNoDraw(true)
        ProtectionSymbol:SetPos(ply:GetPos() + Vector(0, 0, 20))
        ProtectionSymbol:SetAngles(Angle(0, 0, 90))
    end
end