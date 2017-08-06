util.AddNetworkString(NET_ECONOMY_PLAYER_UPDATE)
util.AddNetworkString(NET_ECONOMY_INCOME_UPDATE)

local TIMER_ECONOMY = "EconomyTimer"
local TILE_VALUE = 1
local TOWER_COST_PER_TURN = TILE_VALUE * 5
local TOWER_INITIAL_COST = TOWER_COST_PER_TURN * 3
local MOVE_SPEED_INITIAL_COST = TILE_VALUE * 20
local MOVE_SPEED_COST_PER_TURN = TILE_VALUE * 3

local function SendPlayerFinanceUpdate(ply, income)
    net.Start(NET_ECONOMY_PLAYER_UPDATE)
        net.WriteInt(ply:GetMoney(), 32)
        net.WriteInt(income, 32)
    net.Send(ply)
end

local function CalculateIncome(ply)
    return ply:GetNumTiles() * TILE_VALUE - ply:GetNumOwnedTowers() * TOWER_COST_PER_TURN - ply:GetMoveSpeedLevel() * MOVE_SPEED_COST_PER_TURN
end

function StartEconomy()
    for k, ply in pairs(player.GetAll()) do
        ply:ResetMoney()
    end

    timer.Create(TIMER_ECONOMY, TIME_BETWEEN_ECONOMY_TICKS, 0, function()
        for k, ply in pairs(team.GetPlayers(TEAM_ALIVE)) do
            local income = CalculateIncome(ply)
            ply:AddMoney(income)

            if(ply:GetMoney() < 0) then
                ply:ResetMoney()

                if(ply:GetNumOwnedTowers() < 1) then
                    ply:Lose()
                else
                    ply:DestroyLastTower()
                end
            end

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

function CanPlayerAffordTower(ply)
    return ply:GetMoney() >= TOWER_INITIAL_COST
end

function BuyTower(ply)
    ply:AddMoney(-TOWER_INITIAL_COST)
end

function UpdatePlayerFinances(ply)
    SendPlayerFinanceUpdate(ply, CalculateIncome(ply))
end

function CanAffordMoveSpeedUpgrade(ply)
    return ply:GetMoney() >= MOVE_SPEED_INITIAL_COST
end

function BuyMoveSpeed(ply)
    ply:AddMoney(-MOVE_SPEED_INITIAL_COST)
end