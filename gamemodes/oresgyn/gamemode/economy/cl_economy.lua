
local money = 0
local income = 0

function ResetEconomy()
    money = 0
    income = 0
end

net.Receive(NET_ECONOMY_PLAYER_UPDATE, function(len)
    money = net.ReadInt(32)
    income = net.ReadInt(32)
end)

net.Receive(NET_ECONOMY_INCOME_UPDATE, function(len)
    income = net.ReadInt(32)
end)

function GetMoney()
    return money
end

function GetIncome()
    return income
end
