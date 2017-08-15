local disabledHudElements = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["CHudCrosshair"] = true,
    ["CHudSuitPower"] = true,
    ["CHudWeaponSelection"] = true
}

function GM:HUDShouldDraw(name)
   if disabledHudElements[name] then return false end

   return self.BaseClass.HUDShouldDraw(self, name)
end