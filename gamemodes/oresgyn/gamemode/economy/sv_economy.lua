util.AddNetworkString(NET_ECONOMY_PLAYER_UPDATE)
util.AddNetworkString(NET_ECONOMY_INCOME_UPDATE)

local TIMER_ECONOMY = "EconomyTimer"
local TILE_VALUE = 5

local function SendPlayerFinanceUpdate(ply, income)
    net.Start(NET_ECONOMY_PLAYER_UPDATE)
        net.WriteInt(ply:GetMoney(), 32)
        net.WriteInt(income, 32)
    net.Send(ply)
end

local function CalculateIncome(ply)
    return ply:GetNumTiles() * TILE_VALUE
end

function StartEconomy()
    for k, ply in pairs(player.GetAll()) do
        ply:ResetMoney()
    end

    timer.Create(TIMER_ECONOMY, TIME_BETWEEN_ECONOMY_TICKS, 0, function()
        for k, ply in pairs(player.GetAll()) do
            local income = CalculateIncome(ply)
            ply:AddMoney(income)

            SendPlayerFinanceUpdate(ply, income)
        end
    end)
end

function EndEconomy()
    timer.Destroy(TIMER_ECONOMY)
end

function RecalculateIncome(ply)
    local income = CalculateIncome(ply)
    
    net.Start(NET_ECONOMY_INCOME_UPDATE)
        net.WriteInt(income, 32)
    net.Send(ply)
end