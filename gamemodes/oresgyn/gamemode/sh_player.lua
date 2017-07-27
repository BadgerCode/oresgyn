local plymeta = FindMetaTable( "Player" )
if not plymeta then Error("FAILED TO FIND PLAYER TABLE") return end

function plymeta:SetSpectator()
    if self:IsSpectator() then return end

    self:SetTeam(TEAM_SPECTATOR)
end

function plymeta:SetAlive()
    self:SetTeam(TEAM_ALIVE)
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
