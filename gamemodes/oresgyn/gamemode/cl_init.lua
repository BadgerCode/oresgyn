include("shared.lua")
include("rounds/cl_rounds.lua")

function GM:CalcView(ply, origin, angles, fox, znear, zfar)
    if(!ply:IsSpectator()) then
        local view = { }

        view.origin = origin + Vector(0, 0, 400)
        view.angles = Vector(90, 0, 0)
        view.fov = fov
        view.drawviewer = true
        return view
    end
end