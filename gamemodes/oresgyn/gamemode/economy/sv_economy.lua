util.AddNetworkString(NET_ECONOMY_PLAYER_UPDATE)

local TIMER_ECONOMY = "EconomyTimer"
local TILE_VALUE = 5

local function SendPlayerFinanceUpdate(ply, moneyPerTurn)
    net.Start(NET_ECONOMY_PLAYER_UPDATE)
        net.WriteInt(ply:GetMoney(), 32)
        net.WriteInt(moneyPerTurn, 32)
    net.Send(ply)
end

function StartEconomy()
    for k, ply in pairs(player.GetAll()) do
        ply:ResetMoney()
    end

    timer.Create(TIMER_ECONOMY, TIME_BETWEEN_ECONOMY_TICKS, 0, function()
        for k, ply in pairs(player.GetAll()) do
            local moneyPerTurn = ply:GetNumTiles() * TILE_VALUE
            ply:AddMoney(moneyPerTurn)

            SendPlayerFinanceUpdate(ply, moneyPerTurn)
        end
    end)
end

function EndEconomy()
    timer.Destroy(TIMER_ECONOMY)
end
