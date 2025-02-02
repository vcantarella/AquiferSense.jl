using SpecialFunctions
using QuadGK

"""
    theis(p::AbstractArray{Real}, t::Number, r::Number, Qs::AbstractArray{Real}, tq::AbstractArray{Number})
    Calculate the drawdown in a confined aquifer using the Theis solution.

    # Arguments
    - `p::AbstractArray{Real}`: Array containing the transmissivity `T` and storage coefficient `S` of the aquifer.
    - `t::Number`: Time since pumping started (T).
    - `r::Number`: Radial distance from the well (L).
    - `Qs::AbstractArray{Real}`: Array of pumping rates (L³/T).
    - `tq::AbstractArray{Number}`: Array of times corresponding to the pumping rates (T).

    # Returns
    - `s::Float64`: Drawdown at distance `r` and time `t` (L).

    # Example
    ```p = [1.0e-4, 1.0e-5]  # Transmissivity (T) and storage coefficient (S)
    t = 10.0  # Time since pumping started
    r = 50.0  # Radial distance from the well
    Qs = [100.0, 80.0, 60.0]  # Pumping rates
    tq = [0.0, 5.0, 10.0]  # Times corresponding to the pumping rates

    drawdown = theis(p, t, r, Qs, tq)
   ```
"""
function theis(p::AbstractArray, t::Number, r::Number, Qs::AbstractArray, tq::AbstractArray)
    T, S = p
    u(t) = r^2*S/(4*T*t)
    dh(T, Q, t) = Q*expint(u(t))
    length(Qs) == length(tq) || error("`Qs` and `tq` must have the same dimensions,
        received: $(length(Qs)) and $(length(tq))")
    Qs_c = [Qs[1]; [Qs[i] - Qs[i-1] for i in 2:length(Qs)]]
    results = 0.0
    for i in eachindex(tq)
        if t >= tq[i]
            results += dh(T, Qs_c[i], t-tq[i])
        end
    end
    return results/(4π*T)
end


"""
    hantush(p::AbstractArray{Real}, t::Number, r::Number, Qs::AbstractArray{Real}, tq::AbstractArray{Number})
    Calculate the drawdown in a confined aquifer overlain by a leaky aquitard using the Hantush solution.

    # Arguments
    - `p::AbstractArray{Real}`: Array containing the transmissivity `T`, storage coefficient `S`, and aquitard diffusivity `a` of the aquifer.
    - `t::Number`: Time since pumping started (T).
    - `r::Number`: Radial distance from the well (L).
    - `Qs::AbstractArray{Real}`: Array of pumping rates (L³/T).
    - `tq::AbstractArray{Number}`: Array of times corresponding to the pumping rates (T).

    # Returns
    - `s::Float64`: Drawdown at distance `r` and time `t` (L).
"""
function hantush(p::AbstractArray, t::Number, r::Number, Qs::AbstractArray, tq::AbstractArray)
    T, S, aqui = p
    u(t) = r^2*S/(4*T*t)
    β = r/4*sqrt(aqui/(T*S))
    dh(Q, t) = Q*quadgk(y->exp(-y)/y*erfc(β*sqrt(u(t))/(sqrt(y*(y-u(t))))),
        u(t), Inf, # integration bounds (lower, upper)
        rtol=1e-6, atol = 1e-9)[1] #tolerances
    length(Qs) == length(tq) || error("`Qs` and `tq` must have the same dimensions, received: $(length(Qs)) and $(length(tq))")
    Qs_c = [Qs[1]; [Qs[i] - Qs[i-1] for i in 2:length(Qs)]]
    results = 0
    for i in eachindex(tq)
        if t > tq[i]
            results += dh(Qs_c[i], t-tq[i])
        end
    end
    return results/(4π*T)
end