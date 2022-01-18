using ForwardDiff

struct Raiz 
	raiz::Intervalo; unicidad::Bool 
end 



###########################
#BORRADOR DEL MÉTODO DE NEWTON 
###########################


#Operador de Newton intervalar utilizando la división extendida 

function N_divext(f, dom)
    f′ = ForwardDiff.derivative(f, dom)
    m = mid(dom)
    Nm = m .- [division_extendida(f(m), f′)...]
    return Nm
end


#NEWTON INTERVALAR 

function Newton!(v_candidatos, f, tol)

    for _ in eachindex(v_candidatos)
	dom = popfirst!(v_candidatos) #Extrae y borra la primer entrada de `v_candidatos`
                vf = f(dom)
	0 ∉ vf && continue
	if diam(dom) < tol
                	push!(v_candidatos, dom) #Se incluye a `dom` (al final de `v_candidatos`)
                else
	n0ext = N_divext(f,dom)
		for n0 in n0ext
			dom1 = n0 ∩ dom
			append!(v_candidatos, dom1)
		end
                end
    end
    return nothing
end

# Función Newton2 
function Newton2(f, dom::Intervalo, tol)
    bz = !(0 ∈ f(dom))
    v_candidatos = [dom]  # Vector que incluirá al resultado
	
    while !bz
        Newton!(v_candidatos, f, tol)
        bz = maximum(diam.(v_candidatos)) < tol 
    end

    #Filtra los intervalos que no incluyan al 0
    vind = findall(0 .∈ f.(v_candidatos))
    return v_candidatos[vind]
end

function ceros_newton(dom::Intervalo, tol)
	v_candidatos = Newton2(f, dom, tol)
	unicidad = esmonotona.(f, v_candidatos)
	return Raiz.(v_candidatos, unicidad)
end 