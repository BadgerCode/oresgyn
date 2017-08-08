local currentNotification = nil
local notificationTimer = "Notification_Timer"

local NOTIFICATION_PADDING = 10

function GM:DisplayNotification(message)
    currentNotification = message
    timer.Remove(notificationTimer)

    timer.Create(notificationTimer, 5, 0, function()
        currentNotification = nil
        timer.Destroy(notificationTimer)
    end)
end

function GM:DrawNotifications()
    if(currentNotification == nil) then return end

    surface.SetFont("DermaLarge")
    local textWidth, textHeight = surface.GetTextSize(currentNotification)
    local originX, originY = ScrW() / 2 - textWidth / 2 - NOTIFICATION_PADDING, 100

    draw.RoundedBox(4, originX, originY, textWidth + NOTIFICATION_PADDING * 2, textHeight + NOTIFICATION_PADDING * 2, Color(20,20,20))

    draw.Text({
        text = currentNotification,
        pos = { originX + NOTIFICATION_PADDING, originY + NOTIFICATION_PADDING },
        color = Color(220, 220, 220),
        font = "DermaLarge"
    })
end

function GM:PostDrawHUD()
    
end