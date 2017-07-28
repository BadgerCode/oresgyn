
local money = 0
local moneyPerTurn = 0

function ResetEconomy()
    money = 0
    moneyPerTurn = 0
end

net.Receive(NET_ECONOMY_PLAYER_UPDATE, function(len)
    money = net.ReadInt(32)
    moneyPerTurn = net.ReadInt(32)
end)

function GetMoney()
    return money
end

function GetMoneyPerTurn()
    return moneyPerTurn
end
