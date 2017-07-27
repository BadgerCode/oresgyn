include("sh_rounds.lua")

util.AddNetworkString(NET_ROUND_STATUS_ON_JOIN)
util.AddNetworkString(NET_ROUND_STATUS_UPDATE)

PREP_TIME = 5
END_TIME = 5
ROUND_TIME = 180

local roundStatus = ROUND_WAIT

function roundWaitForPlayers()
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
    setRoundStatus(ROUND_PREPARE)

    destroyMap()

    for k, ply in pairs(player.GetAll()) do
        if(!ply:IsSpectator()) then
            ply:SetSpectator()
        end
        ply:ResetScore()
    end

    timer.Simple(PREP_TIME, function()
        beginRound()
    end)
end

function beginRound()
    setRoundStatus(ROUND_ACTIVE)

    generateMap()
    assignPlayersColours()

    for k, ply in pairs(player.GetAll()) do
        ply:SpawnForRound()
        ply:ResetScore()
    end

    timer.Simple(ROUND_TIME, function()
        endRound()
    end)
end

function endRound()
    if roundStatus == ROUND_OVER then return end
    setRoundStatus(ROUND_OVER)

    timer.Simple(END_TIME, function()
        restartRound()
    end)
end

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
    return getRoundStatus == ROUND_ACTIVE
end
