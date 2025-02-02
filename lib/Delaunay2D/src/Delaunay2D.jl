module Delaunay2D

"""
struct for a Triangle element called 'Triel'
"""
struct Triel
    p::AbstractArray{Integer} #triangles, vertices
    d::AbstractArray{Integer} #daughter triangles
    stat::Integer
    Triel(a,b,c) = begin
        p = [a,b,c]
        d = [-1,-1,-1]
        stat = 1
        return new(p, d, stat)
    end
end

function sign_triangle(p1::AbstractArray{<:Real}, p2::AbstractArray{<:Real}, p3::AbstractArray{<:Real})
    # Assuming 2D points
    return (p1[1] - p3[1])*(p2[2] - p3[2]) - (p2[1] - p3[1])*(p1[2] - p3[2])
end

"""
Check if a point is inside a triangle using implementation here:
https://stackoverflow.com/questions/2049582/how-to-determine-if-a-point-is-in-a-2d-triangle

"""
function containspoint(triel::Triel, point::AbstractVector{<:Real}, point_array::AbstractMatrix{<:Real})
    triel_coords = point_array[triel.p, :]
    a, b, c = triel_coords[1, :], triel_coords[2, :], triel_coords[3, :]
    x, y = point
    d1 = sign_triangle([x, y], a, b)
    d2 = sign_triangle([x, y], b, c)
    d3 = sign_triangle([x, y], c, a)
    has_neg = (d1 < 0) || (d2 < 0) || (d3 < 0)
    has_pos = (d1 > 0) || (d2 > 0) || (d3 > 0)
    bound = false
    if d1 == 0 || d2 == 0 || d3 == 0
        bound = true
    end
    return !(has_neg && has_pos), bound
end
end

export Triel, sign_triangle, containspoint

end # module Delaunay2D

points = [0 0
         1 0
         0 1]