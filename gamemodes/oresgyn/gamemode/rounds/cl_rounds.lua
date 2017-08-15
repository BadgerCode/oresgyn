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

local function UpdateRoundStatus(newStatus)
    if(currentRoundStatus == newStatus) then return end

    local ply = LocalPlayer()
    local roundMessage = roundStatusMessage[newStatus]

    if(roundMessage ~= nil) then
        -- Lazy fix
        chat.AddText(roundChatColour, roundMessage)
    end

    if(newStatus == ROUND_ACTIVE or newStatus == ROUND_OVER) then
        surface.PlaySound("ui/achievement_earned.wav")
        hook.Run("DisplayNotification", roundMessage)
    end

    if(ply:IsAlive() and newStatus == ROUND_ACTIVE) then
        if(ply:IsAlive()) then
            ResetEconomy()
            ply:ChatPrint("Press SPACE to buy towers and USE (E) to buy speed upgrades.")
        else
            ply:ChatPrint("The round has already started. You will be able to join the next round.")
        end
    end

    currentRoundStatus = newStatus
end


net.Receive(NET_ROUND_STATUS_UPDATE, function(len)
    UpdateRoundStatus(net.ReadInt(4))
end)

net.Receive(NET_ROUND_STATUS_ON_JOIN, function(len)
    if(currentRoundStatus != ROUND_WAIT) then return end

    UpdateRoundStatus(net.ReadInt(4))
end)

net.Receive(NET_ROUND_WINNER, function(len)
    roundWinnerName = net.ReadString()

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

net.Receive(NET_ROUND_SEND_END_TIME, function(len)
    roundEndTime = net.ReadDouble()
end)