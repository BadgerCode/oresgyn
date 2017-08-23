local INITIAL_MOVE_SPEED = 250
local MOVE_SPEED_LEVEL_MODIFIER = 50

local plymeta = FindMetaTable( "Player" )
if not plymeta then Error("FAILED TO FIND PLAYER TABLE") return end

function plymeta:Lose()
    local activeTile = self:GetActiveTile()
    if IsValid(activeTile) and activeTile.OwnerPlayer == self then
        activeTile:RemoveProtectionFromPlayer()
    end

    self:SetSpectator()
    self:Spawn()

    print("[ROUND] " .. self:GetName() .. " lost.")

    AnnouncePlayerLost(self)

    checkForVictory()
end

function plymeta:ResetScore()
    self:ResetTileCount()
end

function plymeta:GetMoney()
    return self.Money
end

function plymeta:AddMoney(amount)
    self.Money = self.Money + amount
end

function plymeta:ResetMoney()
    self.Money = 0
end

function plymeta:ResetMoveSpeed()
    self:SetMoveSpeed(INITIAL_MOVE_SPEED)
    self.MoveSpeedLevel = 0
end

function plymeta:SetMoveSpeed(speed)
    self:SetWalkSpeed(speed)
    self:SetRunSpeed(speed)
end

function plymeta:ApplyMoveSpeedLevel()
    self:SetMoveSpeed(INITIAL_MOVE_SPEED + self.MoveSpeedLevel * MOVE_SPEED_LEVEL_MODIFIER)
end

function plymeta:GetMoveSpeedLevel()
    return self.MoveSpeedLevel
end

function plymeta:BuyMoveSpeed()
    if(!CanAffordMoveSpeedUpgrade(self)) then return end

    BuyMoveSpeed(self)
    self.MoveSpeedLevel = self.MoveSpeedLevel + 1
    self:ApplyMoveSpeedLevel()

    UpdatePlayerFinances(self)
end
