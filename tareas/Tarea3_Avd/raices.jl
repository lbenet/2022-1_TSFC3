using ForwardDiff

struct Raiz
	raiz::Intervalo;   unicidad::Bool
end

"""
	INR_method(f, I, tol)
Interval Newton-Raphson method.
"""
function INR_method(f, I, tol)
    0.0 ∉ f(I) && return Vector{Intervalo}()
	roots = [I]
    while true
        counter = 0   ### counter used for now on to keep cycling
        more_roots = [] ## where it's gonna be stored the new root(s)
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

"""
	esmonotona(f, I)
Check if the function *f* is monotonous in the Intervalo interval *I*.
"""
function esmonotona(f, I) 
	if 0.0 ∈ ForwardDiff.derivative(f, I)
		return false
	else
		return true
	end
end

"""
unicity(f, V)
Check if the roots of function *f* in the Intervalo interval *I* are unique or not.
"""
function unicity(f, V)
	return esmonotona.(f, V)
end

function ceros_newton(f, I::Intervalo, tol=1/1024)
	roots = INR_method(f, I, tol)
	unis = unicity(f, roots)
	return Raiz.(roots, unis)
end