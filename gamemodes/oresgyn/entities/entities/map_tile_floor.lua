AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Map Tile Floor"

if SERVER then
    function ENT:Initialize()
        self:SetColor(Color(50, 50, 50))
        self:SetMaterial("models/debug/debugwhite", true)
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
            self:SetColor(self.OwnerPlayer.tileColour)
        end
    end
end

function ENT:Draw()
    self:DrawModel()
end