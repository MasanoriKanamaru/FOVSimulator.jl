
"""
    mutable struct SpiceCamera

# Fields
- `name`         : Instrument name
- `id`           : Instrument ID
- `_fov_shape_`  : Instrument FOV shape as defined in the SPICE kernel.
- `_fov_frame_`  : Name of the frame in which FOV vectors are defined as defined in the SPICE kernel.
- `_boresight_`  : Boresight vector as defined in the SPICE kernel.
- `_fov_bounds_` : FOV boundary vectors as defined in the SPICE kernel.
- `boresight`    : Boresight vector at a frame/epoch.
- `fov_bounds`   : FOV boundary vectors at a frame/epoch.
"""
mutable struct SpiceCamera
    _name_ ::String
    _id_   ::Int

    _fov_shape_  ::String
    _fov_frame_  ::String
    _boresight_  ::SVector{3, Float64}
    _fov_bounds_ ::Vector{SVector{3, Float64}}

    boresight  ::SVector{3, Float64}
    fov_bounds ::Vector{SVector{3, Float64}}
end


function SpiceCamera(_name_::String, _id_::Int)
    _fov_shape_, _fov_frame_, _boresight_, _fov_bounds_ = SPICE.getfov(_id_)

    boresight = similar(_boresight_)
    fov_bounds = similar(_fov_bounds_)

    cam = SpiceCamera(_name_, _id_, _fov_shape_, _fov_frame_, _boresight_, _fov_bounds_, boresight, fov_bounds)

    return cam
end


function Base.show(io::IO, cam::SpiceCamera)
    msg =  "Camera parameters\n"
    msg *= "-----------------\n"
    msg *= "Instrument name      : $(cam._name_)\n"
    msg *= "Instrument ID        : $(cam._id_)\n"
    msg *= "FOV shape            : $(cam._fov_shape_)\n"
    msg *= "FOV reference frame  : $(cam._fov_frame_)\n"
    msg *= "Boresight vector     : $(cam._boresight_)\n"
    msg *= "FOV boundary vectors : \n"
    for v in cam._fov_bounds_
        msg *= "    $v\n"
    end
    msg *= "-----------------\n"
    msg *= "Current boresight vector     : $(cam.boresight)\n"
    msg *= "Current FOV boundary vectors : \n"
    for v in cam.fov_bounds
        msg *= "    $v\n"
    end
    
    print(io, msg)
end


"""
    update!(cam::SpiceCamera, target_frame::String, et::Float64)

Update a boresight vector and FOV boundary vectors at `target_frame` and ephemeris time `et`.

# Arguments
- `cam`          : Camera
- `target_frame` : Target frame
- `et`           : Ephemeris time
"""
function update!(cam::SpiceCamera, target_frame::String, et::Float64)

    Rot = RotMatrix{3}(SPICE.pxform(cam._fov_frame_, target_frame, et))

    cam.boresight = Rot * cam._boresight_

    for (i, v) in enumerate(cam._fov_bounds_)
        cam.fov_bounds[i] = Rot * v
    end
end
