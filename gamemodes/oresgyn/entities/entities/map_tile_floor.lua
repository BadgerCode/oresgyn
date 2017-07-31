AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Map Tile Floor"

local towerDestroySound = Sound("physics/wood/wood_crate_break5.wav")
local towerDamageSound = Sound("physics/wood/wood_crate_impact_hard1.wav")

function ENT:Initialize()
    if SERVER then
        self:SetColor(Color(50, 50, 50))
        self:SetMaterial("models/debug/debugwhite", true)
        self:SetModel("models/hunter/plates/plate3x3.mdl")
        self:SetMoveType(MOVETYPE_NONE)
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetTrigger( true )

        self.Tower = nil

        local phys = self:GetPhysicsObject()
        if(IsValid(phys)) then
            phys:EnableMotion(false)
        end
    elseif CLIENT then
        self.ProtectionSymbol = ClientsideModel("models/props_c17/streetsign004e.mdl")
        self.ProtectionSymbol:SetNoDraw(true)
        self.ProtectionSymbol:SetColor(Color(255, 255, 255))
        self.ProtectionSymbol:SetPos(self:GetPos() + Vector(0, 0, 20))
        self.ProtectionSymbol:SetAngles(Angle(0, 0, 90))

        self.TowerProtectionSymbol = ClientsideModel("models/props_junk/wood_crate001a.mdl")
        self.TowerProtectionSymbol:SetModelScale(0.5)
        self.TowerProtectionSymbol:SetNoDraw(true)
        self.TowerProtectionSymbol:SetPos(self:GetPos() + Vector(0, 0, 10))
        self.TowerProtectionSymbol:SetAngles(Angle(0, 0, 90))
    end
end

function ENT:OnRemove()
    if SERVER then
        self:RemoveLeftWall()
        self:RemoveRightWall()
        self:RemoveTopWall()
        self:RemoveBottomWall()

        if IsValid(self.Tower) then self.Tower:Remove() end
    elseif CLIENT then
        self.ProtectionSymbol:Remove()
    end
end

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "ProtectedFromPlayer")
    self:NetworkVar("Bool", 1, "ProtectedFromNeighbourTower")
    if SERVER then
        self:SetProtectedFromPlayer(false)
        self:SetProtectedFromNeighbourTower(false)
    end
end

if SERVER then
    function ENT:StartTouch(entity)
        if(!entity:IsPlayer()) then return end

        hook.Run("PlayerTouchedTile", entity, self)
    end

    function ENT:AddProtectionFromPlayer()
        self:SetProtectedFromPlayer(true)

        if(IsValid(self.LeftNeighbour) and self.LeftNeighbour.OwnerPlayer == self.OwnerPlayer) then 
            self.LeftNeighbour:SetProtectedFromPlayer(true)
        end

        if(IsValid(self.RightNeighbour) and self.RightNeighbour.OwnerPlayer == self.OwnerPlayer) then 
            self.RightNeighbour:SetProtectedFromPlayer(true)
        end

        if(IsValid(self.TopNeighbour) and self.TopNeighbour.OwnerPlayer == self.OwnerPlayer) then 
            self.TopNeighbour:SetProtectedFromPlayer(true)
        end

        if(IsValid(self.BottomNeighbour) and self.BottomNeighbour.OwnerPlayer == self.OwnerPlayer) then 
            self.BottomNeighbour:SetProtectedFromPlayer(true)
        end
    end

    function ENT:RemoveProtectionFromPlayer()
        self:SetProtectedFromPlayer(false)

        if(IsValid(self.LeftNeighbour) and self.LeftNeighbour.OwnerPlayer == self.OwnerPlayer) then 
            self.LeftNeighbour:SetProtectedFromPlayer(false)
        end

        if(IsValid(self.RightNeighbour) and self.RightNeighbour.OwnerPlayer == self.OwnerPlayer) then 
            self.RightNeighbour:SetProtectedFromPlayer(false)
        end

        if(IsValid(self.TopNeighbour) and self.TopNeighbour.OwnerPlayer == self.OwnerPlayer) then 
            self.TopNeighbour:SetProtectedFromPlayer(false)
        end

        if(IsValid(self.BottomNeighbour) and self.BottomNeighbour.OwnerPlayer == self.OwnerPlayer) then 
            self.BottomNeighbour:SetProtectedFromPlayer(false)
        end
    end

    function ENT:AddLeftWall()
        if(IsValid(self.LeftWall)) then return end

        self.LeftWall = ents.Create("map_tile_wall")
        if(IsValid(self.LeftWall)) then
            local tilePos = self:GetPos()
            local x = tilePos.x
            local y = tilePos.y + self:OBBMaxs().y
            local z = tilePos.z

            self.LeftWall:SetPos(Vector(x, y, z))
            self.LeftWall:SetAngles(Angle(90, 90, 0))
            self.LeftWall:Spawn()
        end
    end

    function ENT:AddTopWall()
        if(IsValid(self.TopWall)) then return end

        self.TopWall = ents.Create("map_tile_wall")
        if(IsValid(self.TopWall)) then
            local tilePos = self:GetPos()
            local x = tilePos.x + self:OBBMaxs().x
            local y = tilePos.y
            local z = tilePos.z

            self.TopWall:SetPos(Vector(x, y, z))
            self.TopWall:SetAngles(Angle(90, 0, 0))
            self.TopWall:Spawn()
        end
    end

    function ENT:AddRightWall()
        if(IsValid(self.RightWall)) then return end

        self.RightWall = ents.Create("map_tile_wall")
        if(IsValid(self.RightWall)) then
            local tilePos = self:GetPos()
            local x = tilePos.x
            local y = tilePos.y + self:OBBMins().y
            local z = tilePos.z

            self.RightWall:SetPos(Vector(x, y, z))
            self.RightWall:SetAngles(Angle(90, 90, 0))
            self.RightWall:Spawn()
        end
    end

    function ENT:AddBottomWall()
        if(IsValid(self.BottomWall)) then return end

        self.BottomWall = ents.Create("map_tile_wall")
        if(IsValid(self.BottomWall)) then
            local tilePos = self:GetPos()
            local x = tilePos.x + self:OBBMins().x
            local y = tilePos.y
            local z = tilePos.z

            self.BottomWall:SetPos(Vector(x, y, z))
            self.BottomWall:SetAngles(Angle(90, 0, 0))
            self.BottomWall:Spawn()
        end
    end

    function ENT:RemoveLeftWall()
        if(IsValid(self.LeftWall))then
            self.LeftWall:Remove()
        end
    end

    function ENT:RemoveTopWall()
        if(IsValid(self.TopWall))then
            self.TopWall:Remove()
        end
    end

    function ENT:RemoveRightWall()
        if(IsValid(self.RightWall))then
            self.RightWall:Remove()
        end
    end

    function ENT:RemoveBottomWall()
        if(IsValid(self.BottomWall))then
            self.BottomWall:Remove()
        end
    end

    function ENT:HasTower()
        return IsValid(self.Tower)
    end

    local function TryGiveNeighbourTowerProtection(tile, neighbour)
        if(IsValid(neighbour) and tile.OwnerPlayer == neighbour.OwnerPlayer) then
            neighbour:AddProtectionFromNeighbourTower()
        end
    end

    function ENT:SetTower(towerEnt)
        self.Tower = towerEnt
        self.TowerHealth = 3

        TryGiveNeighbourTowerProtection(self, self.TopNeighbour)
        TryGiveNeighbourTowerProtection(self, self.LeftNeighbour)
        TryGiveNeighbourTowerProtection(self, self.RightNeighbour)
        TryGiveNeighbourTowerProtection(self, self.BottomNeighbour)
    end

    function ENT:AddProtectionFromNeighbourTower()
        self:SetProtectedFromNeighbourTower(true)
    end

    local function DoesNeighbourGiveTowerProtection(tile, neighbour)
        return IsValid(neighbour) 
                and neighbour:HasTower()
                and tile.OwnerPlayer == neighbour.OwnerPlayer
    end

    function ENT:CheckProtectionFromNeighbourTowers()
        local isProtected = DoesNeighbourGiveTowerProtection(self, self.TopNeighbour)
                         or DoesNeighbourGiveTowerProtection(self, self.LeftNeighbour)
                         or DoesNeighbourGiveTowerProtection(self, self.RightNeighbour)
                         or DoesNeighbourGiveTowerProtection(self, self.BottomNeighbour)

        self:SetProtectedFromNeighbourTower(isProtected)
    end

    function ENT:IsProtected()
        return self:GetProtectedFromPlayer() or self:HasTower() or self:GetProtectedFromNeighbourTower()
    end

    function ENT:IsProtectedFromTower()
        return self:HasTower() or self:GetProtectedFromNeighbourTower()
    end
end

function ENT:DamageTower()
    self:EmitSound(towerDamageSound)

    if SERVER then
        self.TowerHealth = self.TowerHealth - 1

        if(self.TowerHealth <= 0) then
            self:RemoveTower()
        end
    end
end

function ENT:RemoveTower()
    self:EmitSound(towerDestroySound)

    if SERVER then
        self.Tower:Remove()
        self.Tower = nil

        if IsValid(self.TopNeighbour) then self.TopNeighbour:CheckProtectionFromNeighbourTowers() end
        if IsValid(self.LeftNeighbour) then self.LeftNeighbour:CheckProtectionFromNeighbourTowers() end
        if IsValid(self.RightNeighbour) then self.RightNeighbour:CheckProtectionFromNeighbourTowers() end
        if IsValid(self.BottomNeighbour) then self.BottomNeighbour:CheckProtectionFromNeighbourTowers() end
    end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()

        if self:GetProtectedFromNeighbourTower() then
            self.TowerProtectionSymbol:DrawModel()
        elseif self:GetProtectedFromPlayer() then
            self.ProtectionSymbol:DrawModel()
        end
    end
end