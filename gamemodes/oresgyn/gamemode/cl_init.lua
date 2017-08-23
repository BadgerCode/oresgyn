include("shared.lua")
include("sh_player.lua")
include("rounds/sh_rounds.lua")
include("economy/sh_economy.lua")
include("tile-manager/sh_player_tiles.lua")

include("rounds/cl_rounds.lua")
include("economy/cl_economy.lua")
include("gui/cl_disable_hud.lua")
include("gui/cl_hud.lua")
include("gui/cl_notifications.lua")
include("tile-manager/cl_player_tiles.lua")

function GM:InitPostEntity()
    LocalPlayer():ResetTiles()
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

function GM:CreateMove(cmd)
    local ply = LocalPlayer()
    if(ply:IsSpectator()) then return end

    cmd:SetUpMove(0)
    cmd:ClearMovement()

    local movement = Vector()

    if cmd:KeyDown(IN_FORWARD) then
        movement.x = 1
    elseif cmd:KeyDown(IN_BACK) then
        movement.x = -1
    end

    if cmd:KeyDown(IN_MOVELEFT) then
        movement.y = 1
    elseif cmd:KeyDown(IN_MOVERIGHT) then
        movement.y = -1
    end

    if(movement:IsZero()) then return end

    cmd:SetForwardMove(ply:GetRunSpeed())
    cmd:SetViewAngles(movement:Angle())
end
