GM.Name = "Oresgyn"
GM.Author = "Badger"
GM.Email = "badger@badgercode.co.uk"
GM.Website = "https://badgercode.co.uk"

function GM:Initialize()
	GAMEMODE.TeamBased = false

    if SERVER then
        restartRound()
    end
end

function GM:PlayerInitialSpawn(ply)
    
end