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

