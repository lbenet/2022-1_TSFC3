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

"""
	extrems(f, V)
Calculate each extreme point of the function *f* for each Intervalo in *V*.
"""
function extrems(f, V)
	l = length(V)
	exts = zeros(l)
	for e in 1:l
		exts[e] = f(V[e].infimo + (V[e].supremo - V[e].infimo)/2)
	end
	return exts
end

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