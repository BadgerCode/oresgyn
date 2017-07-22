GM.Name = "Oresgyn"
GM.Author = "Badger"
GM.Email = "badger@badgercode.co.uk"
GM.Website = "https://badgercode.co.uk"

function GM:Initialize()
	GAMEMODE.TeamBased = false
end

function GM:PlayerInitialSpawn(ply)
    for k, p in pairs( player.GetAll() ) do
        p:ChatPrint(ply:GetName() .. " joined the server.\n")
    end
end