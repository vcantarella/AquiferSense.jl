using Test

# Test the Delaunay2D module
using Delaunay2D
using LinearAlgebra

# Test the Triel struct
@testset "Triel struct" begin
    triel = Delaunay2D.Triel(1, 2, 3)
    @test triel.p == [1, 2, 3]
    @test triel.d == [-1, -1, -1]
    @test triel.stat == 1
end

# Test the boundary function
@testset "is point inside triangle, if so in the bounds" begin
    triel = Delaunay2D.Triel(1, 2, 3)
    point = [0.5, 0.5]
    point_array = [0 0; 1 0; 0 1]
    @test Delaunay2D.containspoint(triel, point, point_array) == (true, true)
    point = [0.1, 0.1]
    @test Delaunay2D.containspoint(triel, point, point_array) == (true, false)
end

@testset "Inscribed circle" begin
    triel = Delaunay2D.Triel(1, 2, 3)
    point_array = [0 0; 1 0; 0 1]
    a = [0, 0]
    b = [1, 0]
    c = [0, 1]
    dab = norm(a - b)
    dbc = norm(b - c)
    dca = norm(c - a)
    s = (dab + dbc + dca) / 2
    r = sqrt(s * (s - dab) * (s - dbc) * (s - dca)) / s
    q = (dbc * a + dca * b + dab * c) / (2s)
    @test all(Delaunay2D.circumcircle(triel, point_array).center .≈ q)
    @test Delaunay2D.circumcircle(triel, point_array).radius ≈ r
    @test all(Delaunay2D.circumcircle(a, b, c).center .≈ q)
    @test Delaunay2D.circumcircle(a, b, c).radius ≈ r
end