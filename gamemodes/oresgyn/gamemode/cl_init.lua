include("shared.lua")
include("rounds/cl_rounds.lua")

function GM:CalcView(ply, origin, angles, fox, znear, zfar)
    if(!ply:IsSpectator()) then
        local view = { }

        view.origin = origin + Vector(0, 0, 200)
        view.angles = angles--Vector(0, 90, 0)
        view.fov = fov
        view.drawviwer = true
        return view
    end
end