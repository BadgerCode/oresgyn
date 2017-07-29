
local padding = 5
local financeBoxGapWidth = 100
local financeBox = {
    width = 200,
    height = 50
}
local topBar = {
    width = padding * 2 + financeBox.width * 2 + financeBoxGapWidth,
    height = financeBox.height + padding * 2
}

local defaultBGColour = Color(100, 100, 150)

function GM:HUDPaint()
    local ply = LocalPlayer()
    local income = GetIncome()
    local incomePrefix = "+"
    local incomeBgColour = defaultBGColour
    if (income < 0) then 
        incomePrefix = "-"
        incomeBgColour = Color(150, 100, 100)
    end

    local moneyMsg = "£" .. GetMoney()
    local incomeMsg = incomePrefix .. "£" .. math.abs(income)

    draw.RoundedBox(4, 
                    ScrW() / 2 - topBar.width / 2, padding, 
                    topBar.width, topBar.height, 
                    Color(20,20,20))
    draw.RoundedBox(4, 
                    ScrW() / 2 - topBar.width / 2 + padding, padding * 2, 
                    financeBox.width, financeBox.height, 
                    defaultBGColour)
    draw.RoundedBox(4, 
                    ScrW() / 2 + financeBoxGapWidth / 2, padding * 2, 
                    financeBox.width, financeBox.height, 
                    incomeBgColour)

    draw.Text({
        text = moneyMsg,
        pos = { ScrW() / 2 - 230, 20 },
        color = Color(220, 220, 220),
        font = "DermaLarge"
    })

    draw.Text({
        text = incomeMsg,
        pos = { ScrW() / 2 + 70, 20 },
        color = Color(220, 220, 220),
        font = "DermaLarge"
    })
end