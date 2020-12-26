#=
GasLaws.jl:
- Julia version: 1.5.1
- Author: tbald
- Date: 2020-12-20
=#

module GasLaws
using Unitful
using Unitful: 𝐋,𝐍

const R=.0831446261815324u"bar*L*K^-1*mol^-1"
@derived_dimension MolarVolume 𝐋^3/𝐍

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

#Solves for pressure using Van der Waals
#Default a and b for CO2
function Van_der_Waals(Vm::MolarVolume,T::Unitful.Temperature;a=3.658,b=0.04286)::typeof(1.0u"bar")
    full_a=a*1.0u"bar*L^2*mol^-2"
    full_b=b*1.0u"L*mol^-1"
    newT= T |> u"K"

    p=R*newT/(Vm-full_b)
    p+=-full_a/Vm^2
end

#Solves for pressure using Redlich-Kwong equation
##Default a and b for CO2
function Redlich_Kwong(Vm::MolarVolume,T::Unitful.Temperature;a=64.43,b=0.02963)::typeof(1.0u"bar")
    full_a=a*1.0u"bar*L^2*mol^-2*K^(1/2)"
    full_b=b*1.0u"L*mol^-1"
    newT= T |> u"K"

    p=R*newT/(Vm-full_b)
    p+=-full_a/(newT^(1/2)*Vm*(Vm+full_b))
end

##Could add reduced versions of the real gas laws

end