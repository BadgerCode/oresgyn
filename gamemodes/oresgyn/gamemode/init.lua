AddCSLuaFile("cl_init.lua")
AddCSLuaFile("economy/cl_economy.lua")
AddCSLuaFile("gui/cl_disable_hud.lua")
AddCSLuaFile("gui/cl_hud.lua")
AddCSLuaFile("gui/cl_notifications.lua")
AddCSLuaFile("rounds/cl_rounds.lua")
AddCSLuaFile("tile-manager/cl_player_tiles.lua")

include("shared.lua")
include("sh_player.lua")
include("rounds/sh_rounds.lua")
include("economy/sh_economy.lua")
include("tile-manager/sh_player_tiles.lua")

include("sv_player.lua")
include("sv_player_attack.lua")
include("sv_player_colours.lua")
include("economy/sv_economy.lua")
include("map-generation/sv_mapgen.lua")
include("rounds/sv_rounds.lua")
include("tile-manager/sv_player_tiles.lua")
include("tile-manager/sv_tile_manager.lua")

function GM:Initialize()
    roundWaitForPlayers()
end

function GM:PlayerInitialSpawn(ply)
    ply:SetSpectator(true)
end

function GM:PlayerSpawn(ply)
    if ply:IsSpectator() then
        ply:Spectate(OBS_MODE_ROAMING)

        ply:SetEyeAngles(Angle(90, 0, 0))

        if(ply.SpectatorPos ~= nil) then
            ply:SetPos(ply.SpectatorPos)
        end
    else
        ply:SetJumpPower(0)
        ply:SetPos(ply.SpawnTile:GetPos() + Vector(0, 0, 10))
        ply:ResetMoveSpeed()
    end

    hook.Call( "PlayerLoadout", GAMEMODE, ply )
    hook.Call( "PlayerSetModel", GAMEMODE, ply )
end

function GM:PlayerConnected(name, ip)
    print(name .. " connected.")
end

function GM:PlayerDisconnected(ply)
    print(ply:GetName() .. " disconnected.")

    if(!ply:IsSpectator()) then
        ply:Lose()
    end
end

function GM:PlayerDeath(ply, weapon, killer)
    if(!ply:IsSpectator()) then
        print(ply:GetName() .. " died.")

        ply:Lose()
    end
end

function GM:PostPlayerDeath(ply)
    if(ply:IsSpectator()) then
        ply:Spawn()
    end
end

function GM:PlayerDeathSound()
    return true -- This actually means DON'T play the death sound
end

function GM:CanPlayerSuicide(ply)
    return !ply:IsSpectator()
end

function GM:PlayerSetModel(ply)
    ply:SetModel( "models/player/odessa.mdl" )
end

function GM:PlayerLoadout(ply)
    if(!ply:IsSpectator()) then
        ply:Give("weapon_ores_crowbar")
    end
    return true
end

function GM:KeyPress(ply, key)
    if(ply:IsSpectator() or !isRoundActive()) then return end

    if key == IN_USE then
        ply:BuyMoveSpeed()
    elseif key == IN_JUMP then
        hook.Run("PlayerPurchaseTower", ply)
    end
end

function GM:Think()
    hook.Run("CheckRoundTime")
end
