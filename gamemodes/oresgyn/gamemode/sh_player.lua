AddCSLuaFile()

local plymeta = FindMetaTable( "Player" )
if not plymeta then Error("FAILED TO FIND PLAYER TABLE") return end

function plymeta:SetSpectator(isFirstSpawn)
    if self:IsSpectator() then return end

    if SERVER then self:StripWeapons() end

    if(!isFirstSpawn) then
        self.SpectatorPos = self:GetPos() + Vector(0, 0, 400)
    end
    
    self:SetTeam(TEAM_SPECTATOR)
end

function plymeta:SetAlive()
    self:SetTeam(TEAM_ALIVE)
end

function plymeta:IsAlive()
    return self:Team() == TEAM_ALIVE
end

function plymeta:IsSpectator()
    return self:Team() == TEAM_SPECTATOR
end

function plymeta:SpawnForRound()
    if(self:IsSpectator()) then
        self:SetAlive()
        self:UnSpectate()
        self:Spawn()
    end
end
