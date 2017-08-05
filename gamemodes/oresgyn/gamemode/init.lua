AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("economy/cl_economy.lua")
AddCSLuaFile("rounds/cl_rounds.lua")

include("shared.lua")
include("sh_player.lua")
include("rounds/sh_rounds.lua")
include("economy/sh_economy.lua")

include("sv_player.lua")
include("sv_player_attack.lua")
include("sv_player_colours.lua")
include("sv_tile_manager.lua")
include("rounds/sv_rounds.lua")
include("map-generation/sv_mapgen.lua")
include("economy/sv_economy.lua")

function GM:Initialize()
    roundWaitForPlayers()
end

function GM:PlayerInitialSpawn(ply)
    ply:SetSpectator()
end

function GM:PlayerSpawn(ply)
    if ply:IsSpectator() then
        ply:Spectate(OBS_MODE_ROAMING)

        ply:SetEyeAngles(Angle(90, 0, 0))

        if(IsValid(ply.SpectatorPos)) then
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
        print(ply:GetName() .. " died.")
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
--[[    elseif key == IN_FORWARD then
        ply:SetEyeAngles(Angle(0, 0, 0))
    elseif key == IN_BACK then
        ply:SetEyeAngles(Angle(0, 180, 0))
    elseif key == IN_MOVELEFT then
        ply:SetEyeAngles(Angle(0, 90, 0))
    elseif key == IN_MOVERIGHT then
        ply:SetEyeAngles(Angle(0, 270, 0))--]]
    end
    ply:SetEyeAngles(Angle(0, 0, 0))
end

function GM:Move(ply, moveData, command)
    if(!ply:IsSpectator()) then
        moveData:SetMoveAngles(Angle(0, 0, 0))
    end
end

function GM:PlayerSpawnAsSpectator(ply)

end
