using Test
using AquiferTest

Qs = [6, 4.2, 3.9, 3.6]./3600
tq = [0, 19, 590, 1489].*60
D = 15.24 # diametro do poco em cm
global const r = D/2*1e-2 # raio do poco em m
p0 = [1e-3, 1e-4, 1e-6]

@testset "test 0 evaluates to number" begin
    t = 0
    @test hantush(p0, t, r, Qs, tq) ≈ 0.0
    @test theis(p0, t, r, Qs, tq) ≈ 0.0
end

@testset "test broadcast" begin
    t = [100, 500, 2000, 6000, 10000, 100000]
    @assert length(hantush.(Ref(p0), t, Ref(r), Ref(Qs), Ref(tq))) == length(t)
    @assert length(theis.(Ref(p0), t, Ref(r), Ref(Qs), Ref(tq))) == length(t)
end
