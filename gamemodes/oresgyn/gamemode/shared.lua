GM.Name = "Oresgyn"
GM.Author = "Badger"
GM.Email = "badger@badgercode.co.uk"
GM.Website = "https://badgercode.co.uk"

include("sh_player.lua")

TEAM_ALIVE = 1


function GM:CreateTeams()
    team.SetUp(TEAM_ALIVE, "Alive Players", Color(100, 100, 200, 255), false)
    team.SetUp(TEAM_SPECTATOR, "Spectators", Color(200, 200, 200, 255), true)
end

function GM:PlayerInitialSpawn(ply)
    sendPlayerCurrentRoundStatus(ply)
    ply:SetSpectator()
end

function GM:PlayerSpawn(ply)
    if ply:IsSpectator() then
        ply:Spectate(OBS_MODE_ROAMING)
    else
        ply:SetModel( "models/player/odessa.mdl" )
        ply:SetPos(ply.SpawnPos)
    end
end
