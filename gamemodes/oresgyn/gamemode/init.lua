AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("rounds/cl_rounds.lua")
AddCSLuaFile("rounds/sh_rounds.lua")

include("shared.lua")
include("rounds/sv_rounds.lua")

function GM:PlayerDeath(ply, weapon, killer)
    endRound()
end
