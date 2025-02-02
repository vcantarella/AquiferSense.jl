using AquiferTest
using JET
using Test

# Test with JET
Qs = [6, 4.2, 3.9, 3.6]./3600
tq = [0, 19, 590, 1489].*60
D = 15.24 # diametro do poco em cm
global const r = D/2*1e-2 # raio do poco em m
p0 = [1e-3, 1e-4, 1e-6]

t = 0
@test_opt hantush(p0, t, r, Qs, tq)
@test_opt theis(p0, t, r, Qs, tq)
