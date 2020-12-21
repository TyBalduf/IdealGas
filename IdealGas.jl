#=
IdealGas.jl:
- Julia version: 1.5.1
- Author: tbald
- Date: 2020-12-20
=#

module IdealGas
using Unitful

const R=.0831446261815324u"bar*L*K^-1*mol^-1"

#Returns amount in desired unit
function ideal(P::Unitful.Pressure,V::Unitful.Volume,
               n::Unitful.AmountUnits,T::Unitful.Temperature)::Unitful.Amount
    newT= T |> u"K"
    units=Unitful.unit(P)*Unitful.unit(V)/(u"K"*n)
    newR=R |> units
    newN=P*V/(newR*newT)
end

#Returns Temperature in desired unit
function ideal(P::Unitful.Pressure,V::Unitful.Volume,
               n::Unitful.Amount,T::Unitful.TemperatureUnits)::Unitful.Temperature
    units=Unitful.unit(P)*Unitful.unit(V)/(u"K"*Unitful.unit(n))
    newR=R |> units
    newT=P*V/(newR*n)
    newT |> T
end

#Returns Volume in desired unit
function ideal(P::Unitful.Pressure,V::Unitful.VolumeUnits,
               n::Unitful.Amount,T::Unitful.Temperature)::Unitful.Volume
    newT= T |> u"K"
    units=Unitful.unit(P)*V/(u"K"*Unitful.unit(n))
    newR=R |> units
    newV=(n*newR*newT)/P
end

#Returns Pressure in desired unit
function ideal(P::Unitful.PressureUnits,V::Unitful.Volume,
               n::Unitful.Amount,T::Unitful.Temperature)::Unitful.Pressure
    newT= T |> u"K"
    units=P*Unitful.unit(V)/(u"K"*Unitful.unit(n))
    newR=R |> units
    newP=(n*newR*newT)/V
end

@time P=ideal(u"atm",22.4u"L",2u"mol",273.0u"K")
println(P)
@time V=ideal(2u"atm",u"L",2u"mol",273.0u"K")
println(V)
@time N=ideal(1.0u"atm",22.7u"mL",u"mol",273.0u"°C")
println(N)
@time T=ideal(1.0u"atm",22.7u"mL",.0005u"mol",u"°C")
println(T)
end