AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("rounds/cl_rounds.lua")
AddCSLuaFile("rounds/sh_rounds.lua")
AddCSLuaFile("sh_player.lua")

include("shared.lua")
include("sh_player.lua")
include("rounds/sv_rounds.lua")
include("map-generation/sv_mapgen.lua")

function GM:Initialize()
    roundWaitForPlayers()
end

function GM:PlayerDeath(ply, weapon, killer)
    ply:SetSpectator()
    if team.NumPlayers(TEAM_ALIVE) < 2 then
        endRound()
    end
end

function GM:CanPlayerSuicide(ply)
    return !ply:IsSpectator()
end

function GM:PlayerSay(ply, text, isTeamChat)
    if(text == "pos") then
        print(ply:GetPos())
    end

    return text
end