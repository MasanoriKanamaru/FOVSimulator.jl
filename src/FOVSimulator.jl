module FOVSimulator

using LinearAlgebra
using Rotations
using StaticArrays

import SPICE

include("SpiceCamera.jl")
export SpiceCamera, update!

## Utility functions
angle_rad(v1::AbstractVector{<:Real}, v2::AbstractVector{<:Real}) = acos(clamp(normalize(v1) ⋅ normalize(v2), -1.0, 1.0))
angle_deg(v1::AbstractVector{<:Real}, v2::AbstractVector{<:Real}) = rad2deg(angle_rad(v1, v2))

angle_rad(v1::AbstractVector{<:AbstractVector{<:Real}}, v2::AbstractVector{<:AbstractVector{<:Real}}) = angle_rad.(v1, v2)
angle_deg(v1::AbstractVector{<:AbstractVector{<:Real}}, v2::AbstractVector{<:AbstractVector{<:Real}}) = angle_deg.(v1, v2)

export angle_rad, angle_deg

end # module FOVSimulator
