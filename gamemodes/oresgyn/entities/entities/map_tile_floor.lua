AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Map Tile Floor"

if SERVER then
    function ENT:Initialize()
        self:SetMoveType(MOVETYPE_NONE)
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetTrigger( true )

        local phys = self:GetPhysicsObject()
        if(IsValid(phys)) then
            phys:EnableMotion(false)
        end
    end

    function ENT:StartTouch(entity)
        if(!self.OwnerPlayer and entity:IsPlayer()) then
            self.OwnerPlayer = entity
            self:SetColor(Color(255, 0, 0, 255))
        end
    end
end

function ENT:Draw()
    self:DrawModel()
end