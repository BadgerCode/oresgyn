
function GM:HUDPaint()
    local ply = LocalPlayer()
    local moneyMsg = "£" .. GetMoney()
    local moneyPerTurnMsg = "£" .. GetMoneyPerTurn() .. "/" .. TIME_BETWEEN_ECONOMY_TICKS .. "second"

    draw.Text({
        text = moneyMsg,
        pos = { 100, 100 },
        color = Color(0, 0, 0)
    })

    draw.Text({
        text = moneyPerTurnMsg,
        pos = { 200, 200 },
        color = Color(0, 0, 0)
    })
end