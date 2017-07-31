-- From TTT

AddCSLuaFile()

SWEP.HoldType                = "melee"

if CLIENT then
   SWEP.PrintName            = "crowbar_name"
   SWEP.Slot                 = 0

   SWEP.DrawCrosshair        = false
   SWEP.ViewModelFlip        = false
   SWEP.ViewModelFOV         = 54
end

SWEP.Base                    = "weapon_base"

SWEP.UseHands                = true
SWEP.ViewModel               = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel              = "models/weapons/w_crowbar.mdl"

SWEP.Primary.Damage          = 20
SWEP.Primary.ClipSize        = -1
SWEP.Primary.DefaultClip     = -1
SWEP.Primary.Automatic       = true
SWEP.Primary.Delay           = 0.5
SWEP.Primary.Ammo            = "none"

SWEP.Secondary.ClipSize      = -1
SWEP.Secondary.DefaultClip   = -1
SWEP.Secondary.Automatic     = true
SWEP.Secondary.Ammo          = "none"
SWEP.Secondary.Delay         = 5

SWEP.Weight                  = 5

local sound_single = Sound("Weapon_Crowbar.Single")


function SWEP:PrimaryAttack()
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not IsValid(self.Owner) then return end

   self.Weapon:EmitSound(sound_single)

   if SERVER then
      self.Owner:SetAnimation( PLAYER_ATTACK1 )
      hook.Run("PlayerAttacked", self.Owner)
   end
end

function SWEP:GetClass()
	return "weapon_ores_crowbar"
end

function SWEP:OnDrop()
	self:Remove()
end
