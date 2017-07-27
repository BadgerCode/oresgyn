AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Map Tile Floor"

if SERVER then

    function ENT:Initialize()
        self:SetColor(Color(50, 50, 50))
        self:SetMaterial("models/debug/debugwhite", true)
        self:SetModel("models/hunter/plates/plate3x3.mdl")
        self:SetMoveType(MOVETYPE_NONE)
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetTrigger( true )

        local phys = self:GetPhysicsObject()
        if(IsValid(phys)) then
            phys:EnableMotion(false)
        end
    end

    function ENT:OnRemove()
        self:RemoveLeftWall()
        self:RemoveRightWall()
        self:RemoveTopWall()
        self:RemoveBottomWall()
    end

    function ENT:StartTouch(entity)
        if(!entity:IsPlayer()) then return end

        local plyPreviousTile = entity:GetActiveTile()
        if IsValid(plyPreviousTile) and plyPreviousTile.OwnerPlayer == entity then
            plyPreviousTile:RemoveProtectionFromPlayer()
        end

        entity:SetActiveTile(self)

        local currentOwner = self.OwnerPlayer

        if(currentOwner == entity) then
            self:AddProtectionFromPlayer()
        elseif(!self:IsProtected()) then
            self.OwnerPlayer = entity
            self:SetColor(self.OwnerPlayer.tileColour)
            self.OwnerPlayer:AddTile()
            self:AddProtectionFromPlayer()

            if(IsValid(currentOwner)) then
                currentOwner:RemoveTile()
            end
        end
    end

    function ENT:Think()
        if self:IsProtected() then
            self:SetColor(Color(50, 50, 200))
        else
            if IsValid(self.OwnerPlayer) then
                self:SetColor(self.OwnerPlayer.tileColour)
            else
                self:SetColor(Color(50, 50, 50))
            end
        end
    end

    function ENT:AddProtectionFromPlayer()
        self.ProtectedFromPlayer = true

        if(IsValid(self.LeftNeighbour) and self.LeftNeighbour.OwnerPlayer == self.OwnerPlayer) then 
            self.LeftNeighbour.ProtectedFromPlayer = true
        end

        if(IsValid(self.RightNeighbour) and self.RightNeighbour.OwnerPlayer == self.OwnerPlayer) then 
            self.RightNeighbour.ProtectedFromPlayer = true
        end

        if(IsValid(self.TopNeighbour) and self.TopNeighbour.OwnerPlayer == self.OwnerPlayer) then 
            self.TopNeighbour.ProtectedFromPlayer = true
        end

        if(IsValid(self.BottomNeighbour) and self.BottomNeighbour.OwnerPlayer == self.OwnerPlayer) then 
            self.BottomNeighbour.ProtectedFromPlayer = true
        end
    end

    function ENT:RemoveProtectionFromPlayer()
        self.ProtectedFromPlayer = false

        if(IsValid(self.LeftNeighbour) and self.LeftNeighbour.OwnerPlayer == self.OwnerPlayer) then 
            self.LeftNeighbour.ProtectedFromPlayer = false
        end

        if(IsValid(self.RightNeighbour) and self.RightNeighbour.OwnerPlayer == self.OwnerPlayer) then 
            self.RightNeighbour.ProtectedFromPlayer = false
        end

        if(IsValid(self.TopNeighbour) and self.TopNeighbour.OwnerPlayer == self.OwnerPlayer) then 
            self.TopNeighbour.ProtectedFromPlayer = false
        end

        if(IsValid(self.BottomNeighbour) and self.BottomNeighbour.OwnerPlayer == self.OwnerPlayer) then 
            self.BottomNeighbour.ProtectedFromPlayer = false
        end
    end

    function ENT:IsProtected()
        return self.ProtectedFromPlayer
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
end

function ENT:Draw()
    self:DrawModel()
end