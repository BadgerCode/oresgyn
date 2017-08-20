util.AddNetworkString(NET_PLAYER_JOIN)
util.AddNetworkString(NET_ROUND_STATUS_ON_JOIN)
util.AddNetworkString(NET_ROUND_WAITING)
util.AddNetworkString(NET_ROUND_PREPARING)
util.AddNetworkString(NET_ROUND_STARTED)
util.AddNetworkString(NET_ROUND_OVER)
util.AddNetworkString(NET_ROUND_PLAYER_LOSE)

TIMER_WAIT_PLAYERS          = "WaitForPlayers"
TIMER_ROUND_TIME            = "RoundTimer"

local roundStatus = ROUND_WAIT
local roundEndTime = 0

local minTilesForOwnershipVictory = 0

function roundWaitForPlayers()
    print("[ROUND] Waiting for players to join")
    roundStatus = ROUND_WAIT
    sendRoundWaiting()

    timer.Create(TIMER_WAIT_PLAYERS, 2, 0, function()
        if(player.GetCount() > 0) then
            print("[ROUND] Enough players have joined.")
            restartRound()
            timer.Destroy(TIMER_WAIT_PLAYERS)
        end
    end)
end

function restartRound()
    print("[ROUND] Restarting the round")
    roundStatus = ROUND_PREPARE
    sendRoundPreparing()

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
    print("[ROUND] Starting the round")
    roundStatus = ROUND_ACTIVE

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

    roundEndTime = CurTime() + ROUND_TIME

    sendRoundStarted(roundEndTime)

    print("[ROUND] Round has begun")
end

function GM:CheckRoundTime()
    if(isRoundActive() and CurTime() >= roundEndTime) then
        checkForVictory()
        if isRoundActive() then endRound(nil) end
    end
end

function endRound(winner)
    print("[ROUND] Ending the round. " .. (IsValid(winner) and winner:GetName() or "Nobody") .. " won")

    if timer.Exists(TIMER_ROUND_TIME) then
        timer.Destroy(TIMER_ROUND_TIME)
    end
    if roundStatus == ROUND_OVER then return end

    roundStatus = ROUND_OVER
    sendRoundEnd(winner)

    EndEconomy()

    timer.Simple(END_TIME, function()
        restartRound()
    end)

    print("[ROUND] Round has ended")
end

net.Receive(NET_PLAYER_JOIN, function(len, ply)
    net.Start(NET_ROUND_STATUS_ON_JOIN)
        net.WriteInt(roundStatus, 4)
    net.Send(ply)
end)

function sendRoundWaiting()
    net.Start(NET_ROUND_WAITING)
    net.Broadcast()
end

function sendRoundPreparing()
    net.Start(NET_ROUND_PREPARING)
    net.Broadcast()
end

function sendRoundStarted(endTime)
    for k, ply in pairs(player.GetAll()) do
        net.Start(NET_ROUND_STARTED)
            net.WriteDouble(endTime)
        net.Send(ply)
    end
end

function sendRoundEnd(winner)
    local winnerName = "Nobody"
    if IsValid(winner) then winnerName = winner:GetName() end

    net.Start(NET_ROUND_OVER)
        net.WriteString(winnerName)
    net.Broadcast()
end

function getRoundStatus()
    return roundStatus
end

function isRoundActive()
    return getRoundStatus() == ROUND_ACTIVE
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
