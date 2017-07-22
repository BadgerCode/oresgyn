include("sh_rounds.lua")

local roundStatus = ROUND_WAIT

local roundStatusMessage = { }
roundStatusMessage[ROUND_WAIT] = "Waiting for players to join."
roundStatusMessage[ROUND_PREPARE] = "A new round is about to begin."
roundStatusMessage[ROUND_ACTIVE] = "The round has started!"
roundStatusMessage[ROUND_OVER] = "The round is over."

local roundStatusJoinMessage = { }
roundStatusJoinMessage[ROUND_WAIT] = roundStatusMessage[ROUND_WAIT]
roundStatusJoinMessage[ROUND_PREPARE] = roundStatusMessage[ROUND_PREPARE]
roundStatusJoinMessage[ROUND_ACTIVE] = "The round has already started. You will be able to join the next round."
roundStatusJoinMessage[ROUND_OVER] = roundStatusMessage[ROUND_OVER]

net.Receive(NET_ROUND_STATUS_UPDATE, function(len)
    roundStatus = net.ReadInt(4)

    LocalPlayer():ChatPrint(roundStatusMessage[roundStatus])
end)

net.Receive(NET_ROUND_STATUS_ON_JOIN, function(len)
    roundStatus = net.ReadInt(4)

    LocalPlayer():ChatPrint(roundStatusJoinMessage[roundStatus])
end)
