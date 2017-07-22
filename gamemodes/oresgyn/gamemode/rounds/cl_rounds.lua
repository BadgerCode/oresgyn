include("sh_rounds.lua")

local roundStatus = ROUND_WAIT

local roundStatusMessage = { }
roundStatusMessage[ROUND_WAIT] = "A new round is about to begin."
roundStatusMessage[ROUND_ACTIVE] = "The round has started!"
roundStatusMessage[ROUND_OVER] = "The round is over."

net.Receive(NET_ROUND_STATUS_UPDATE, function(len)
    roundStatus = net.ReadInt(4)

    LocalPlayer():ChatPrint(roundStatusMessage[roundStatus])
end)
