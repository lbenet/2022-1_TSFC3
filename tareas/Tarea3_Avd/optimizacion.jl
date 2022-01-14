include("intervalos.jl")

# ╔═╡ a7cc31d3-e34a-425a-a698-e4e869c57a05
#using Plots   ### To help me visualize better what I'm trying and doing

# ╔═╡ 7dd4495e-73fc-11ec-37a7-9fbab661cf88
#=function mini(f, I, tol=1e-5)   ### Non-Interval minimize method
	y = f(I.infimo)
	x = I.infimo
	for i in (I.infimo+tol):tol:I.supremo
		if f(i-tol) > f(i) < f(i+tol)
			if f(i) < y
				y = f(i)
				x = i
			end
		end
	end
	return y, x
end=#

# ╔═╡ aab40414-6df7-4f1b-8a86-5d216ff3b61f
#=function maxi(f, I, tol=1e-5)   ### Non-Interval maximize method
	y = f(I.infimo)
	x = I.infimo
	for i in (I.infimo+tol):tol:I.supremo
		if f(i-tol) < f(i) > f(i+tol)
			if f(i) > y
				y = f(i)
				x = i
			end
		end
	end
	return y, x
end=#

# ╔═╡ 6811f544-94ba-4998-9ab7-0c156f042736
#=function minimiza_no_peaks(f, I, tol)
	(I.supremo - I.infimo) < tol && return I
	I₀ = I
	while true
		mp = I₀.infimo + (I₀.supremo - I₀.infimo)/2
		I₁ = Intervalo(I₀.infimo, mp);   I₂ = Intervalo(mp, I₀.supremo)
		Ints = [I₁, I₂];   ys = []
		for i in Ints
			step = (i.supremo - i.infimo)/100
			y_min = Inf
			for p in i.infimo:step:i.supremo
				if f(p-step) > f(p) < f(p+tol)
					if f(p) < y_min
						y_min = f(p)
					end
				end
			end
			push!(ys, y_min)
		end
		if ys[1] < ys[2]
			I₀ = Ints[1]
		elseif ys[2] < ys[1]
			I₀ = Ints[2]
		end
		if (I₀.supremo - I₀.infimo) < tol
			return I₀
		end
	end 
end=#

# ╔═╡ 062f4a8e-0520-417f-b361-3f79de6c5a66
"""
	subdividing(Is)
Given a Intervalo's vector *Is*, for each element of it, subdivide them at half and return another Intervalo's vector with all the Intervalo's sub-intervals.
"""
function subdividing(Is)
	subdiv = Vector{Intervalo}()
	for i in Is
		mp = i.infimo + (i.supremo - i.infimo)/2   ### mid-point
		push!(subdiv, Intervalo(i.infimo, mp))
		push!(subdiv, Intervalo(mp, i.supremo))
	end
	return subdiv
end

# ╔═╡ ddf1b388-e95d-4d8d-ad58-56ac884290e7
function extrems(f, V)
	l = length(V)
	exts = zeros(l)
	for e in 1:l
		exts[e] = f(V[e].infimo + (V[e].supremo - V[e].infimo)/2)
	end
	return exts
end

# ╔═╡ 5f4e4159-5517-4907-a583-3cdfbbcabbdb
"""
	minimiza(f, I, tol)
Find the interval(s) (type=Intervalo) which contains the minimum of the function *f* in the initial given interval (type=Intervalo) *I*, until the diameter of the answer(s) meets the condition to have less length than *tol*.
"""
function minimiza(f, I::Intervalo, tol=1/1024)
	Intervals = [I]
	while true
		to_add = subdividing(Intervals)
		l = length(to_add)   ### Filtering the subintervals
		sups = zeros(l);   infs = zeros(l)
		for j in 1:l
			sups[j] = f(to_add[j]).supremo
			infs[j] = f(to_add[j]).infimo
		end
		super_sup = minimum(sups)
		Is = Vector{Intervalo}()
		for k in 1:l
			if infs[k] < super_sup
				push!(Is, to_add[k])
			end
		end
		Intervals = Is   ### Redefining
		I1 = Intervals[1]   ### Checking if the tol is meet
		if (I1.supremo - I1.infimo) < tol
			exts = extrems(f, Intervals)
			return Intervals, exts
		end
	end
end

# ╔═╡ bf68dde3-9148-4b3a-9261-de589885a749
#=begin
	g(x) = - x^3 + (x+2)^2 - 2x + 3
	mn = minimiza(x->g(x), Intervalo(-2,3))
	p = plot(-2:0.1:3, x->g(x), key=false)
	for i in mn
		plot!(p, [i.infimo, i.infimo, i.supremo, i.supremo, i.infimo],
		[g(i).infimo, g(i).supremo, g(i).supremo, g(i).infimo, g(i).infimo], lw=2)
	end
	p
end=#

# ╔═╡ d3176cd6-4ff9-4ec9-8656-161de957557e
"""
	maximiza(f, I, tol)
Find the interval(s) (type=Intervalo) which contains the maximum of the function *f* in the initial given interval (type=Intervalo) *I*, until the diameter of the answer(s) meets the condition to have less length than *tol*.
"""
function maximiza(f, I::Intervalo, tol=1/1024)
	Intervals = [I]
	while true
		to_add = subdividing(Intervals)
		l = length(to_add)   ### Filtering the subintervals
		sups = zeros(l);   infs = zeros(l)
		for j in 1:l
			sups[j] = f(to_add[j]).supremo
			infs[j] = f(to_add[j]).infimo
		end
		infi_inf = maximum(infs)
		Is = Vector{Intervalo}()
		for k in 1:l
			if infi_inf < sups[k]
				push!(Is, to_add[k])
			end
		end
		Intervals = Is   ### Redefining
		I1 = Intervals[1]   ### Checking if the tol is meet
		if (I1.supremo - I1.infimo) < tol
			exts = extrems(f, Intervals)
			return Intervals, exts
		end
	end
end

# ╔═╡ 960f4d88-d6bc-4a60-aa91-7743edf7453f
#=begin
	mx = maximiza(x->g(x), Intervalo(-1.4,3))
	q = plot(-1.5:0.1:3, x->g(x), key=false)
	for i in mx
		plot!(q, [i.infimo, i.infimo, i.supremo, i.supremo, i.infimo],
		[g(i).infimo, g(i).supremo, g(i).supremo, g(i).infimo, g(i).infimo], lw=2)
	end
	q
end=#

# ╔═╡ 4a4adcca-55fd-4866-b1fb-f38f1ba7820b
#=begin
	h(x) = 1 - x^4 + x^5
	xm, ym = minimiza(h, Intervalo(0,1))
	typeof(xm) <: Vector{T} where {T<: Intervalo}
	any(4/5 .∈ xm)
	all(ym .∈ h.(xm))
end=#
