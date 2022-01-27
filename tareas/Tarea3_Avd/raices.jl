using ForwardDiff

export Raiz, esmonotona, ceros_newton

struct Raiz
	raiz::Intervalo;   unicidad::Bool
end

function INR_method(f, I, tol)
    0.0 ∉ f(I) && return Vector{Intervalo}()
	roots = [I]
    while true
        counter = 0   ### counter used for now on to keep cycling
		more_roots = typeof(I)[]   ### more_roots = Vector{typeof(I)}()
        for Ir in roots
            if Ir.supremo - Ir.infimo < tol  ### Checking diameter smaller than tol
            	push!(more_roots, Ir)
				counter += 1
            else   ### Interval Newton-Rhapson method
                mp = Ir.infimo + (Ir.supremo - Ir.infimo)*0.5   ### mid-point
                mI = Intervalo(mp)   ### mid-Interval
                F′ = ForwardDiff.derivative(f, Ir)
                Intervals = mI .- division_extendida(f(mI), F′)   ### recursive
                intersect = Ir .∩ Intervals
				for i in intersect
	                if 0.0 ∈ f(i)
						push!(more_roots, i)
					end
                end
            end
        end
        counter == length(more_roots) && return more_roots
        roots = more_roots   ### If not, redefine the interval solutions array
    end
end

function esmonotona(f, I) 
	if 0.0 ∈ ForwardDiff.derivative(f, I)
		return false
	else
		return true
	end
end

function unicity(f, V)
	return esmonotona.(f, V)
end

function ceros_newton(f, I::Intervalo, tol=1/1024)
	roots = INR_method(f, I, tol)
	unis = unicity(f, roots)
	return Raiz.(roots, unis)
end
