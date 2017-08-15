
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
local hudCorner = {
    width = 200,
    height = 100
}

local defaultBGColour = Color(100, 100, 150)

local function DrawHUDTopBar()
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
    local timeRemainingMsg = string.FormattedTime(getRoundRemainingSeconds(), "%02i:%02i")

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
        text = timeRemainingMsg,
        pos = { ScrW() / 2, 20 },
        color = Color(220, 220, 220),
        font = "DermaLarge",
        xalign = TEXT_ALIGN_CENTER
    })

    draw.Text({
        text = incomeMsg,
        pos = { ScrW() / 2 + 70, 20 },
        color = Color(220, 220, 220),
        font = "DermaLarge"
    })
end

local function DrawHUDCorner()
    local ply = LocalPlayer()
    local tileCount = ply:GetTileCount()
    local towerCount = ply:GetTowerCount()

    draw.RoundedBox(4,
                    padding, ScrH() - padding - hudCorner.height,
                    hudCorner.width, hudCorner.height,
                    Color(20,20,20))

    draw.Text({
        text = "Tiles: " .. tileCount .. " (" .. ply:GetPctOfMapOwned() .. "%)",
        pos = { padding * 2, ScrH() - hudCorner.height },
        color = Color(220, 220, 220),
        font = "DermaLarge"
    })

    draw.Text({
        text = "Towers: " .. towerCount,
        pos = { padding * 2, ScrH() - hudCorner.height / 2 },
        color = Color(220, 220, 220),
        font = "DermaLarge"
    })
end

function GM:HUDPaint()
    -- TODO: Handle players who aren't in the round

    DrawHUDTopBar()
    DrawHUDCorner()

    hook.Run("DrawNotifications")
end
