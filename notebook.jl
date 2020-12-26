### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 3c92f3e0-4561-11eb-37f1-8592dae8553f
begin 
	using Plots
	using PlutoUI
	using Unitful
	using UnitfulRecipes
end

# ╔═╡ 089cf360-4561-11eb-2df0-8f3849683471
include("GasLaws.jl")

# ╔═╡ fae31c72-46f2-11eb-08b9-0b24d9a602cc
md"""
Enter $3$ of $P$, $V$, $n$, and $T$ and just the units for the remaining quantity. The remaining quantity will be calculated with the chosen units using the Ideal Gas law.

A number of units are available for each quantity and most SI prefixes can be used. To specifiy Celcius/Fahrenheit temperature units, you must include the degree symbol (e.g. °C/°F)
"""

# ╔═╡ ea7c3510-459e-11eb-19e1-0b4793eb57fb
begin
	md"""
	P = $(@bind P NumberField(0.0:100.0))  $(@bind P_unit TextField(;default="bar"))
	
	V= $(@bind V NumberField(0.0:100.0))  $(@bind V_unit TextField(;default="L"))
	
	n= $(x=@bind n NumberField(0.0:100.0)) $(@bind n_unit TextField(;default="mol"))
	
	T= $(@bind T NumberField(0.0:1000.0))  $(@bind T_unit TextField(;default="K"))
	"""
end	
	

# ╔═╡ b26d3f00-45a0-11eb-358c-e10f44d8a1cc
begin
	if isnan(P)
		P_full=uparse(P_unit)
		quantity="Pressure"
	else
	    P_full=P*uparse(P_unit)
	end	
	if isnan(V)
		V_full=uparse(V_unit)
		quantity="Volume"
	else
	    V_full=V*uparse(V_unit)
	end	
	if isnan(n)
		n_full=uparse(n_unit)
		quantity="amount"
    else
	    n_full=n*uparse(n_unit)
	end	
	if isnan(T)
		T_full=T*uparse(T_unit)
		quantity="Temperature"
	else
		T_full=T*uparse(T_unit)
	end
	try 
	    result=GasLaws.ideal(P_full,V_full,n_full,T_full)
	    md"""The resulting $quantity is $result"""
	catch err
		md"""Enter $3$ values to calculate the blank value"""
	end	
end
	

# ╔═╡ 59abc110-4731-11eb-3392-c5d3db261f1a


# ╔═╡ 99c5e560-46f4-11eb-2e31-254b08bf6a2b
md"""
Can calculate pressure for a real gas using the Van der Waals or Redlich-Kwong equations. The Slider below allows you to change the temperature for a plots of $P$ vs $V_m$ (molar volume) with each of these equations. The $a$ and $b$ constants for $\ce{CO2}$ are used for each function. 
"""

# ╔═╡ 57be7b8e-4727-11eb-0c8d-aff4ab6b8835
@bind newT Slider(0.0:1000.0,show_value=true)

# ╔═╡ 86087550-4727-11eb-3b46-fd0ef0c05d93
begin
	realT=newT*1u"K"
	Vm_range=(1.0:0.25:5.0)u"L/mol"
	VdW(v)=GasLaws.Van_der_Waals(v,realT)
	RK(v)=GasLaws.Redlich_Kwong(v,realT)
	plot(VdW,Vm_range,xlabel="Molar Volume",ylabel="Pressure",label="Van der Waals")
	plot!(RK,Vm_range,xlabel="Molar Volume",ylabel="Pressure",label="Redlich-Kwong")
end	

# ╔═╡ Cell order:
# ╟─089cf360-4561-11eb-2df0-8f3849683471
# ╟─3c92f3e0-4561-11eb-37f1-8592dae8553f
# ╟─fae31c72-46f2-11eb-08b9-0b24d9a602cc
# ╟─ea7c3510-459e-11eb-19e1-0b4793eb57fb
# ╟─b26d3f00-45a0-11eb-358c-e10f44d8a1cc
# ╟─59abc110-4731-11eb-3392-c5d3db261f1a
# ╟─99c5e560-46f4-11eb-2e31-254b08bf6a2b
# ╟─57be7b8e-4727-11eb-0c8d-aff4ab6b8835
# ╟─86087550-4727-11eb-3b46-fd0ef0c05d93
