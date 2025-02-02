module Delaunay2D
using LinearAlgebra
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

struct Circle
    center::AbstractVector{<:Real}
    radius::Real
    Circle(center::AbstractVector{<:Real}, radius::Real) = new(center, radius)
end

"""
Calculate the inscribed circumcircle of a triangle given by a triel element
"""
function circumcircle(triel::Triel, point_array::AbstractMatrix{<:Real})
    triel_coords = point_array[triel.p, :]
    a, b, c = triel_coords[1, :], triel_coords[2, :], triel_coords[3, :]
    # side lengths
    dab = norm(a - b)
    dbc = norm(b - c)
    dca = norm(c - a)
    # half perimeter
    s = 1//2 * (dab + dbc + dca)
    # center point
    q = @. 1/(2s)*(dbc* a + dca * b + dab * c)
    radius = √((s - dab) * (s - dbc) * (s - dca) / s)
    return Circle(q, radius)
end

"""
Calculate the inscribed circumcircle of a triangle given by three points
"""
function circumcircle(a::AbstractVector{<:Real},b::AbstractVector{<:Real},
    c::AbstractVector{<:Real})
    # side lengths
    dab = norm(a - b)
    dbc = norm(b - c)
    dca = norm(c - a)
    # verify the if statement below (chatpgt)
    if dab + dbc <= dca || dbc + dca <= dab || dca + dab <= dbc
        error("The three points do not form a triangle")
    end
    # half perimeter
    s = 1//2 * (dab + dbc + dca)
    # center point
    q = @. 1/(2s)*(dbc* a + dca * b + dab * c)
    radius = √((s - dab) * (s - dbc) * (s - dca) / s)
    return Circle(q, radius)
end

function incircle(triel::Triel, point::AbstractVector{<:Real}, point_array::AbstractMatrix{<:Real})
    triel_coords = point_array[triel.p, :]
    a, b, c = triel_coords[1, :], triel_coords[2, :], triel_coords[3, :]
    circle = circumcircle(triel, point_array)
    return norm(point - circle.center) <= circle.radius
end

export Triel, sign_triangle, containspoint, circumcircle, Circle

end # module Delaunay2D