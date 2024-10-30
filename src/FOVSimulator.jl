module FOVSimulator

using LinearAlgebra
using Rotations
using StaticArrays

import SPICE

include("SpiceCamera.jl")
export SpiceCamera, update!

## Utility functions
angle_rad(v1, v2) = @. acos(normalize(v1) ⋅ normalize(v2))
angle_deg(v1, v2) = rad2deg.(angle_rad(v1, v2))
export angle_rad, angle_deg

end # module FOVSimulator
