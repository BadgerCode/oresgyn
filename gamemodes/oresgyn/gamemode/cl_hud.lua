
function GM:HUDPaint()
    local ply = LocalPlayer()
    local moneyMsg = "£" .. GetMoney()
    local moneyPerTurnMsg = "£" .. GetMoneyPerTurn()

    draw.RoundedBox(4, ScrW() / 2 - 250, 10, 200, 50, Color(20,20,20))
    draw.RoundedBox(4, ScrW() / 2 + 50, 10, 200, 50, Color(20,20,20))

    draw.Text({
        text = moneyMsg,
        pos = { ScrW() / 2 - 230, 20 },
        color = Color(220, 220, 220),
        font = "DermaLarge"
    })

    draw.Text({
        text = moneyPerTurnMsg,
        pos = { ScrW() / 2 + 70, 20 },
        color = Color(220, 220, 220),
        font = "DermaLarge"
    })
end