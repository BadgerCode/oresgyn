util.AddNetworkString(NET_PLAYER_JOIN)
util.AddNetworkString(NET_ROUND_STATUS_ON_JOIN)
util.AddNetworkString(NET_ROUND_STATUS_UPDATE)
util.AddNetworkString(NET_ROUND_WINNER)
util.AddNetworkString(NET_ROUND_PLAYER_LOSE)

TIMER_WAIT_PLAYERS          = "WaitForPlayers"
TIMER_ROUND_TIME            = "RoundTimer"

local roundStatus = ROUND_WAIT

local minTilesForOwnershipVictory = 0

function roundWaitForPlayers()
    print("Waiting for players to join")
    setRoundStatus(ROUND_WAIT)

    timer.Create(TIMER_WAIT_PLAYERS, 2, 0, function()
        if(player.GetCount() > 0) then
            print("Enough players have joined")
            restartRound()
            timer.Destroy(TIMER_WAIT_PLAYERS)
        end
    end)
end

function restartRound()
    print("Restarting the round")
    setRoundStatus(ROUND_PREPARE)

    for k, ply in pairs(team.GetPlayers(TEAM_ALIVE)) do
        ply:ResetScore()
    end

    if player.GetCount() == 0 then
        roundWaitForPlayers()
    else
        timer.Simple(PREP_TIME, function()
            beginRound()
        end)
    end
end

function beginRound()
    print("Starting the round")
    setRoundStatus(ROUND_ACTIVE)

    for k, ply in pairs(team.GetPlayers(TEAM_ALIVE)) do
        if(!ply:IsSpectator()) then
            ply:SetSpectator()
            ply:Spawn()
        end
    end

    DestroyMap()
    GenerateMap()
    minTilesForOwnershipVictory = GetNumTotalTiles() * MIN_PCT_TILES_FOR_OWNERSHIP_VICTORY

    assignPlayersColours()

    for k, ply in pairs(player.GetAll()) do
        ply:SpawnForRound()
        ply:ResetScore()
        ply:ResetOwnedTowers()

        ply.SpawnTile:SetOwnerPlayer(ply)
        ply.SpawnTile:AddProtectionFromPlayer()
        ply:AddTile()
    end

    StartEconomy()

    timer.Create(TIMER_ROUND_TIME, ROUND_TIME, 0, function()
        checkForVictory()
        if isRoundActive() then endRound(nil) end
    end)

    print("Round has begun")
end

function endRound(winner)
    print("Ending the round. " .. (IsValid(winner) and winner:GetName() or "Nobody") .. " won")

    if timer.Exists(TIMER_ROUND_TIME) then
        timer.Destroy(TIMER_ROUND_TIME)
    end
    if roundStatus == ROUND_OVER then return end
    setRoundStatus(ROUND_OVER)
    setRoundWinner(winner)

    EndEconomy()

    timer.Simple(END_TIME, function()
        restartRound()
    end)

    print("Round has ended")
end

net.Receive(NET_PLAYER_JOIN, function(len, ply)
    sendPlayerCurrentRoundStatus(ply)
end)

function sendPlayerCurrentRoundStatus(ply)
    net.Start(NET_ROUND_STATUS_ON_JOIN)
        net.WriteInt(roundStatus, 4)
    net.Send(ply)
end

function setRoundStatus(status)
    roundStatus = status

    net.Start(NET_ROUND_STATUS_UPDATE)
        net.WriteInt(roundStatus, 4)
    net.Broadcast()
end

function getRoundStatus()
    return roundStatus
end

function isRoundActive()
    return getRoundStatus() == ROUND_ACTIVE
end

function setRoundWinner(ply)
    local winnerName = "Nobody"
    if IsValid(ply) then winnerName = ply:GetName() end

    net.Start(NET_ROUND_WINNER)
        net.WriteString(winnerName)
    net.Broadcast()
end

function checkForVictory()
    local numLivingPlayers = team.NumPlayers(TEAM_ALIVE)
    if numLivingPlayers < 2 then
        local winner = nil
        if numLivingPlayers == 1 then
            winner = team.GetPlayers(TEAM_ALIVE)[1]
            winner:AddFrags(1)
        end

        endRound(winner)
    end
end

function CheckForTileOwnershipVictory(ply)
    if(ply:GetNumTiles() >= minTilesForOwnershipVictory) then
        endRound(ply)
    end
end

function AnnouncePlayerLost(ply)
    net.Start(NET_ROUND_PLAYER_LOSE)
        net.WriteEntity(ply)
    net.Broadcast()
end
