AddCSLuaFile()

GM.Name = "Oresgyn"
GM.Author = "Badger"
GM.Email = "badger@badgercode.co.uk"
GM.Website = "https://badgercode.co.uk"

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

        ply:SetEyeAngles(Angle(90, 0, 0))

        if(IsValid(ply.SpectatorPos)) then
            ply:SetPos(ply.SpectatorPos)
        end
    else
        ply:SetPos(ply.SpawnTile:GetPos() + Vector(0, 0, 10))
        ply:ResetMoveSpeed()
    end

    hook.Call( "PlayerLoadout", GAMEMODE, ply )
    hook.Call( "PlayerSetModel", GAMEMODE, ply )
end
