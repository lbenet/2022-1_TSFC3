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
        #more_roots = [] ## where it's gonna be stored the new root(s)
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
						#@show(i, f(i))
						push!(more_roots, i)
					else
						@show(i, f(i))
					end
                end
            end
        end
		#@show(roots, more_roots)
        counter == length(more_roots) && return more_roots
        #roots = more_roots   ### If not, redefine the interval solutions array
		roots = copy(more_roots)   ### deepcopy()
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

# ╔═╡ 97292631-e296-4937-92db-a5a58966defe
#=begin
	h3(x) = x^3*(4-5x)
    rr3 = ceros_newton(h3, Intervalo(-big(3),4), big(1)/2^10)
	INR_method(h3, Intervalo(-big(3),4), 0.09)
    #all(0 .∈ h3.(getfield.(rr3, :raiz)))
    #all(typeof.(getfield.(rr3, :raiz)) .== Intervalo{BigFloat})
    #any( 4//5 .∈ getfield.(rr3, :raiz))
    #any( 0 .∈ getfield.(rr3, :raiz))   ########################
    #any(getfield.(rr3, :unicidad))
    #!all(getfield.(rr3, :unicidad))   ########################
end=#