using ForwardDiff#, Plots

# ╔═╡ 1bd435bb-b9e8-40e1-83b9-6c65551c1280
include("intervalos.jl")

# ╔═╡ f6fbd260-bf9e-4ca9-9f7f-53100a24f962
struct Raiz
	raiz::Intervalo;   unicidad::Bool
end

# ╔═╡ 3305d0e0-4774-4555-9c1a-d1c6832985ae
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

# ╔═╡ 6bbea2d2-28f9-4d55-9ab9-e034a308e232
#=function esmonotona_chida(f, I, part=1e-5)
	interv = I.infimo:part:I.supremo
	for i in interv
		if ForwardDiff.derivative(f,i) == 0.0
			return false
		elseif ForwardDiff.derivative(f,i) < 0.0
			for j in i:part:interv[end]
				if ForwardDiff.derivative(f,j) == 0.0
					return false
				elseif ForwardDiff.derivative(f,j) > 0.0
					return false
				end
			end
			return true
		elseif ForwardDiff.derivative(f,i) > 0.0
			for k in i:part:interv[end]
				if ForwardDiff.derivative(f,k) == 0.0
					return false
				elseif ForwardDiff.derivative(f,k) < 0.0
					return false
				end
			end
			return true
		end
	end
end=#

# ╔═╡ 3090f4f9-130d-4ec1-8689-fc9492893e2c
function esmonotona(f, I) 
	if 0.0 ∈ ForwardDiff.derivative(f, I)
		return false
	else
		return true
	end
end

# ╔═╡ ab894a96-c403-449c-b45c-b15eae978b1d
function unicity(f, V)
	l = length(V);   uni = trues(l)
	for I in 1:l
		monot = esmonotona(f, V[I])
		if monot == false
			uni[I] = false
		end
	end
	return uni
end

# ╔═╡ 3d099169-4f12-4144-8073-898c7714f204
function ceros_newton(f, I::Intervalo, tol=1/1024)
	roots = INR_method(f, I, tol)
	unis = unicity(f, roots)
	return Raiz.(roots, unis)
end

# ╔═╡ ea5ee562-4ac7-4b09-975f-3a888e85db6e
#=begin
	h(x) = 4*x + 3
	    #r = ceros_newton(h, Intervalo(-1,0), 0.25)
	    #@test -0.75 ∈ getfield(r[1], :raiz)
	    # Este ejemplo no tiene raices
	    r = ceros_newton(h, Intervalo(1,2), 0.5)
	    length(r) == 0
end=#

# ╔═╡ 49655b70-c745-48e6-a0dc-1aacc9bd8b2a
#=begin
	h3(x) = x^3*(4-5x)
    rr3 = ceros_newton(h3, Intervalo(-big(3),4), big(1)/2^10)
	INR_method(h3, Intervalo(-big(3),4), 0.09)
    #all(0 .∈ h3.(getfield.(rr3, :raiz)))
    #all(typeof.(getfield.(rr3, :raiz)) .== Intervalo{BigFloat})
    #any( 4//5 .∈ getfield.(rr3, :raiz))
	#getfield.(rr3, :raiz)
    #any( 0 .∈ getfield.(rr3, :raiz))
    #any(getfield.(rr3, :unicidad))
    #!all(getfield.(rr3, :unicidad))
end=#

# ╔═╡ f6431349-8d03-4c8c-bd29-071ce4326275
#plot(-0.1:0.01:0.1, x->h3(x), key=false)
