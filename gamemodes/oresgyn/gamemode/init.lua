AddCSLuaFile("cl_init.lua")
AddCSLuaFile("rounds/cl_rounds.lua")
AddCSLuaFile("economy/cl_economy.lua")
AddCSLuaFile("cl_hud.lua")

include("shared.lua")
include("sh_player.lua")
include("rounds/sh_rounds.lua")
include("economy/sh_economy.lua")

include("sv_player_colours.lua")
include("sv_player.lua")
include("rounds/sv_rounds.lua")
include("map-generation/sv_mapgen.lua")
include("economy/sv_economy.lua")

function GM:Initialize()
    roundWaitForPlayers()
end

function GM:PlayerDisconnected(ply)
    checkForVictory()

    if(!ply:IsSpectator()) then
        local activeTile = ply:GetActiveTile()
        if IsValid(activeTile) and activeTile.OwnerPlayer == ply then
            activeTile:RemoveProtectionFromPlayer()
        end
    end
end

function GM:PlayerDeath(ply, weapon, killer)
    if(!ply:IsSpectator()) then
        ply:SetSpectator()

        local activeTile = ply:GetActiveTile()
        if IsValid(activeTile) and activeTile.OwnerPlayer == ply then
            activeTile:RemoveProtectionFromPlayer()
        end
    end

    checkForVictory()
end

function GM:PostPlayerDeath(ply)
    if(ply:IsSpectator()) then
        ply:Spawn()
        ply:SetPos(ply.SpectatorPos)
    end
end

function GM:PlayerDeathSound()
    return true -- This actually means DON'T play the death sound
end

function GM:CanPlayerSuicide(ply)
    return !ply:IsSpectator()
end

function GM:SetupMove(ply, moveData, command)
    if(!ply:IsSpectator()) then
        if moveData:KeyDown(IN_JUMP) then
            moveData:SetButtons(moveData:GetButtons() - IN_JUMP)
        end

        moveData:SetMoveAngles(Angle(0, 0, 0))

        if moveData:KeyDown(IN_FORWARD) then
            ply:SetEyeAngles(Angle(0, 0, 0))
        elseif moveData:KeyDown(IN_BACK) then
            ply:SetEyeAngles(Angle(0, 180, 0))
        elseif moveData:KeyDown(IN_MOVELEFT) then
            ply:SetEyeAngles(Angle(0, 90, 0))
        elseif moveData:KeyDown(IN_MOVERIGHT) then
            ply:SetEyeAngles(Angle(0, 270, 0))
        end
    end
end

function GM:PlayerSay(ply, text, isTeamChat)
    if(text == "pos") then
        ply:ChatPrint(tostring(ply:GetPos()))
    end

    return text
end
