include("sh_rounds.lua")

util.AddNetworkString(NET_ROUND_STATUS_UPDATE)

local roundStatus = ROUND_WAIT

function restartRound()
    setRoundStatus(ROUND_WAIT)

    timer.Simple(5, function()
        beginRound()
    end)
end

function beginRound()
    setRoundStatus(ROUND_ACTIVE)
end

function endRound()
    setRoundStatus(ROUND_OVER)

    timer.Simple(5, function()
        restartRound()
    end)
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
