AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("rounds/cl_rounds.lua")
AddCSLuaFile("rounds/sh_rounds.lua")
AddCSLuaFile("sh_player.lua")

include("shared.lua")
include("sv_player_colours.lua")
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

function GM:SetupMove(ply, moveData, command)
    if moveData:KeyDown(IN_JUMP) then
        moveData:SetButtons(moveData:GetButtons() - IN_JUMP)
    end

    if(!ply:IsSpectator()) then
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
    elseif(text == "tbl") then
        print(mapProps.floor.Model)
        print(mapProps.floor.Size)
    elseif(text == "prop") then
        local pos = ply:GetPos()
        for i = 0, 5, 1 do
            local plate = ents.Create("prop_physics")
            if(!IsValid(plate)) then return text end

            plate:SetMoveType(MOVETYPE_NONE)
            plate:SetModel(Model("models/hunter/plates/plate3x3.mdl"))
            plate:SetPos(pos)
            plate:Spawn()

            local phys = plate:GetPhysicsObject()
            if(IsValid(phys)) then
                phys:EnableMotion(false)
            end

            local mins = plate:OBBMins()
            local maxs = plate:OBBMaxs()
            pos.x = pos.x + maxs.x

            maxs:Sub(mins)
            print(maxs)
        end
    end

    return text
end
