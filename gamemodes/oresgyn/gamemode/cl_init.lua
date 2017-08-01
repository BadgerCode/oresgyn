include("shared.lua")
include("sh_player.lua")
include("rounds/sh_rounds.lua")
include("economy/sh_economy.lua")

include("rounds/cl_rounds.lua")
include("economy/cl_economy.lua")
include("cl_hud.lua")

function GM:InitPostEntity()
    net.Start(NET_PLAYER_JOIN)
    net.SendToServer()
end

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
