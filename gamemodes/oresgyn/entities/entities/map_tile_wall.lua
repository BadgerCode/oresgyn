AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Map Tile Floor"

if SERVER then
    function ENT:Initialize()
        self:SetColor(Color(20, 20, 20))
        self:SetMaterial("models/debug/debugwhite", true)
        self:SetModel("models/hunter/plates/plate1x3.mdl")
        self:SetMoveType(MOVETYPE_NONE)
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )

        local phys = self:GetPhysicsObject()
        if(IsValid(phys)) then
            phys:EnableMotion(false)
        end
    end
end

function ENT:Draw()
    self:DrawModel()
end