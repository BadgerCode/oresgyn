local currentRoundStatus = ROUND_WAIT

local roundStatusMessage = {
    [ROUND_WAIT] = "Waiting for players to join.",
    [ROUND_PREPARE] = "A new round is about to begin.",
    [ROUND_OVER] = "The round is over.",
    [ROUND_ACTIVE] = "The round has started!"
}

local roundChatColour = Color(151, 211, 255)
local deathChatColour = Color(255, 151, 151)

local roundEndTime = 0

function getRoundStatus()
    return roundStatus
end

function isRoundActive()
    return getRoundStatus() == ROUND_ACTIVE
end

function getRoundRemainingSeconds()
    return math.max(0, roundEndTime - CurTime())
end

local function PlayRoundSoundEffect()
    surface.PlaySound("ui/achievement_earned.wav")
    hook.Run("DisplayNotification", roundMessage)
end

net.Receive(NET_ROUND_STATUS_ON_JOIN, function(len)
    currentRoundStatus = net.ReadInt(4)

    if(currentRoundStatus == ROUND_ACTIVE) then
        chat.AddText(roundChatColour, "The round has already started. You will be able to join the next round.")
    else
        chat.AddText(roundChatColour, roundStatusMessage[currentRoundStatus])
    end
end)

net.Receive(NET_ROUND_WAITING, function(len)
    currentRoundStatus = ROUND_WAIT

    chat.AddText(roundChatColour, roundStatusMessage[currentRoundStatus])
end)

net.Receive(NET_ROUND_PREPARING, function(len)
    currentRoundStatus = ROUND_PREPARE

    chat.AddText(roundChatColour, roundStatusMessage[currentRoundStatus])
end)

net.Receive(NET_ROUND_STARTED, function(len)
    roundEndTime = net.ReadDouble()

    currentRoundStatus = ROUND_ACTIVE

    PlayRoundSoundEffect()

    chat.AddText(roundChatColour, roundStatusMessage[currentRoundStatus])
    chat.AddText("Press SPACE to buy towers and USE (E) to buy speed upgrades.")
    hook.Run("DisplayNotification", "The round has started!")

    ResetEconomy()
end)

net.Receive(NET_ROUND_OVER, function(len)
    roundWinnerName = net.ReadString()

    currentRoundStatus = ROUND_OVER

    PlayRoundSoundEffect()

    chat.AddText(roundChatColour, roundStatusMessage[currentRoundStatus])

    hook.Run("DisplayNotification", roundWinnerName .. " won the round!")
end)

net.Receive(NET_ROUND_PLAYER_LOSE, function(len)
    local playerLost = net.ReadEntity()

    if(!IsValid(playerLost)) then return end

    local message = playerLost == LocalPlayer() 
                    and "You lost!"
                    or playerLost:GetName() .. " has lost!"

    hook.Run("DisplayNotification", message)
    chat.AddText(deathChatColour, message)

    surface.PlaySound("phx/eggcrack.wav")
end)
