local currentRoundStatus = ROUND_WAIT

local roundStatusMessage = {
    [ROUND_WAIT] = "Waiting for players to join.",
    [ROUND_PREPARE] = "A new round is about to begin.",
    [ROUND_OVER] = "The round is over.",
    [ROUND_ACTIVE] = "The round has started!"
}

local function UpdateRoundStatus(newStatus)
    if(currentRoundStatus == newStatus) then return end

    currentRoundStatus = newStatus

    local ply = LocalPlayer()

    if(newStatus == ROUND_ACTIVE or newStatus == ROUND_OVER) then
        surface.PlaySound("ui/achievement_earned.wav")
        hook.Run("DisplayNotification", roundStatusMessage[newStatus])
    else
        local roundMessage = roundStatusMessage[newStatus]
        if(roundMessage ~= nil) then
            -- Lazy fix
            ply:ChatPrint(roundMessage)
        end
    end

    if(ply:IsAlive() and newStatus == ROUND_ACTIVE) then
        if(ply:IsAlive()) then
            ResetEconomy()
            ply:ChatPrint("Press SPACE to buy towers and USE (E) to buy speed upgrades.")
        else
            ply:ChatPrint("The round has already started. You will be able to join the next round.")
        end
    end
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

    if(playerLost == LocalPlayer()) then
        hook.Run("DisplayNotification", "You lost!")
    else
        hook.Run("DisplayNotification", playerLost:GetName() .. " has lost!")
    end

    surface.PlaySound("phx/eggcrack.wav")
end)