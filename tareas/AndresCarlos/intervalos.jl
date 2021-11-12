### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ 7dfae42a-4211-11ec-3983-29e1cea73a3b
begin 
	
	"""
	             Intervalo
	La siguiente estructura definira un intervalo, que es un conjunto cerrado continuo donde el ´inf´ denota al valor minimo del intervalo y el ´sup´ el valor maximo del mismo.
	"""
	struct intervalo{T<:Real} #Definimos la estructura, tendra un subtipo menor a Real
		inf :: T #TDefinimos el tipo de las variables que tendra, en este caso el inf
		sup :: T #Definimos el tipo de la variabla sup, que sera de tipo T
		#mismo :: T #Definimos el tipo de la variable punto que sera tipo T
		
		function intervalo(inf::T, sup::T) where {T<:Real} #Definimos la función
			@assert inf ≤ sup #Hacemos la afirmación de inf menor a sup
			return new{T}(inf, sup) #Nos regresa un intervalo y de tipo T
		end
		
		
		
		
		
		
	end
	
	function intervalo(inf::T, sup::R) where {T<:Real, R<:Real} #Definimos la 
			                                                    #función
	    i, s = promote(inf, sup) #No necesariamente tiene que tener los mismos 
			                     #tipos
		return intervalo(i,s) #con Promote hacemos que sean del mismo tipo de 
	end                       #mayor jererquia y nos regresa la función 
		                          #intervalo anterior
		
	function intervalo(mismo::T) where{T<:Real} #Definimos la función para un 
			                                    #punto
		return intervalo(mismo, mismo) #nos regresa el intervalo del punto
	end
	
	
	function intervalo()     #Intervalo vacio
		return ()      #Regresamos un arreglo pues vacio :v
	end
	
end

# ╔═╡ b6be6e7a-3ae9-48ba-abf6-bd04e889164b
intervalo()

# ╔═╡ a2d08992-2591-4f1d-a8e0-43076aa9d5e2
function ∪(a::intervalo, b::intervalo) #Definimos la operación union#
	CotI=min(a.inf, b.inf) #Definimos la cota minima de los dos intervalos
	CotS=max(a.sup, b.sup) #Definimos la cota maxima de los dos intervalos
	return intervalo(CotI, CotS) #Regresamos la función intervalo con esas cotas
end

# ╔═╡ 477da29e-8326-48aa-b823-01cc86c4d4b3
begin
	I1=intervalo(3,4)
    I2=intervalo(5,9)
	I3=intervalo(1,10)
	I4=intervalo(9,16)
end

# ╔═╡ d1affbbd-b74e-4983-a6a2-92a688ab6c19
∪(I1,I2)

# ╔═╡ 5b13850e-1e68-461b-a41c-2cd695502716
function ∩(a::intervalo, b::intervalo) #definimos la función de intersección
	if a.sup < b.inf    #Vemos que el intervalo a y b son ajenos con a.sup < b.inf
		return intervalo() #de ser el caso nos arroja el vacio
	elseif b.sup < a.inf  #Vemos que sean ajenos para el otro caso que a este a la 
		                  #derecha de b
		return intervalo() #De ser el caso nos arroja el intervalo vacio
	elseif b.sup < a.sup && b.sup > a.inf  #vemos un primer caso de la intersección
		CotMin= max(a.inf, b.inf)  #como b esta atrapado en a, b.sup < a.sup, la cota
		return intervalo(CotMin, b.sup) #minima estara denotada por la maxima de los 
		                                #inf
	elseif a.sup < b.sup && a.sup > b.inf #El otro caso donde a.sup < b.sup
		CotMin= max(a.inf, b.inf)   #Vemos la cota inf adecuada para la intersección
		return intervalo(CotMin, a.sup) #Nos regresa la intersección
		
	end
end 

# ╔═╡ 6a5926ee-e419-4ea4-9ed2-fe1dd110de89
begin 
	
	import Base. == #No se lo entiendo del todo pero me pedia importar :V
	
	function ==(a::intervalo, b::intervalo) #Definimos la función de igualdad
		
		if a.inf == b.inf && a.sup == b.sup #Si los infs y sups son iguales da true
			return true # Devuelve true
	    else 
		    return false #Devuelve false si no es el caso
	    end
		
	end
	
end
		

# ╔═╡ 94aa2723-4d33-4a1d-b9f0-eae10c02f157
I1 == I2

# ╔═╡ 85117a02-e8fb-40e9-b9dc-43e1b599179a
begin 
	
	import Base. ∈
	
	function ∈(x::Real, j::intervalo) #Definimos el operador logico ∈ ¨creo¨
		
		if j.inf ≤ x && x ≤ j.sup #Hacemos la intrucción donde obtenemos un verdadero
			return true           #de pertenencia
		else 
			return false          #caso contrario nos devuelve un false
		end 
		
	end
	
end

# ╔═╡ cb54faf9-cd66-4459-b3f9-9917b6d5df7b
7 ∈ I2

# ╔═╡ 38542482-adfd-45d9-8190-c823e63740cf
function ⪽(a::intervalo, b::intervalo) #Definimos el operador logico ⪽ ¨creo, no se 
	                                   #decirlo mejor¨
	if a.inf > b.inf && a.sup < b.sup #Vemos que los extremos de a esten atrapados en 
		                              #b
		return true                   #obtenemos un verdadero
	else 
		return false                  #Caso contrario obtenemos un falso
	end
	
end

# ╔═╡ 1eac0dc7-89db-42fe-bff5-d5db0b317383
I1 ⪽ I3

# ╔═╡ 9b51c7e4-7c48-4f46-8e52-4f8d4fbd6cbe
function ⊃(a::intervalo, b::intervalo) #Definimos el operador logico ⊃ ¨creo, no se 
	                                   #decirlo mejor¨ 
	if b.inf > a.inf && b.sup < a.sup #Vemos que los extremos de b esten atrapados en 
		                              #a
		return true                   #obtenemos un verdadero
	else 
		return false                  #Caso contrario obtenemos un falso
	end
	
end

# ╔═╡ b55288a2-3e37-4f0e-9e29-54646aaf672a
function ⊆(a::intervalo, b::intervalo) #Definimos el operador logico ⊆ ¨creo, no se 
	                                   #decirlo mejor¨
	if a.inf ≥ b.inf && a.sup ≤ b.sup #Vemos que los extremos de a esten atrapados en 
		                              #b o sea igual a b
		return true                   #obtenemos un verdadero
	else 
		return false                  #Caso contrario obtenemos un falso
	end
	
end

# ╔═╡ f18f5215-6846-4ee2-aa5a-a1bb0926c720
begin 
	import Base: + 
	
	function +(a::intervalo, b::intervalo)  #Definimos la suma
	    suminf = a.inf + b.inf        #sumamos infimos
	    sumsup = a.sup + b.sup        #Sumamos supremos
	    return intervalo(suminf, sumsup)  #Regresamos el intervalo supremo
    end
	
end
	

# ╔═╡ ba47a76f-75b7-4ee0-8f5a-aaa3332d9cc3
begin 
	import Base: -   #importamos de Base el -
	
	function -(a::intervalo, b::intervalo) #Definimos la resta
	    restinf = a.inf - b.sup   #Hacemos el infimo de la resta
	    restsup = a.sup + b.inf   #Hacemos el supremo de la resta
	    return intervalo(restinf, restsup)  #Devolvemos el intervalo resta
    end
	
end

# ╔═╡ 715fe57f-04c9-4ec2-96d7-cfc3f83c5baf
begin 
	
	import Base: * #importamos de Base el *
	
	function *(a::intervalo, b::intervalo) #Definimos el producto
	    producinf = min(a.inf*b.inf, a.inf*b.sup, a.sup*b.inf, a.sup*b.sup)
	    producsup = max(a.inf*b.inf, a.inf*b.sup, a.sup*b.inf, a.sup*b.sup) 
	    return intervalo(producinf, producsup) #Devolvemos el producto 
    end
	
end

# ╔═╡ bdc3c336-77c1-47f2-a7f7-0bd5b41e38d0
*(I4,I4)

# ╔═╡ baf8ef76-0642-4510-82cc-668e0cf216c3
#=begin 
	
	import Base: ^ #Importamos de Base la potencia
	
	function ^(a::intervalo, n::Integer) #definimos la potencia
		#@assert typeof(n) == Integer
		k=1 #Ponemos valores iniciales para hacer la potencia
		b=a #Definimos b = a para que haga el producto usando codigo anterior
		
	    for i in 1:n #Iteramos para la potencia buscada
			k=k+1    #Aumentamos un valor a K para que en algun momento se detenga
		    poteninf = min(a.inf*b.inf, a.inf*b.sup, a.sup*b.inf, a.sup*b.sup)
	        potensup = max(a.inf*b.inf, a.inf*b.sup, a.sup*b.inf, a.sup*b.sup)
	        b=intervalo(poteninf, potensup) #Obtenemos un nuevo valor de b
			if k == n #Si se ejecuta el codigo n-1 veces se detiene la iteración
				break #Se sale del ciclo con el break
			end
			
		end
		
		return b #Regresamos el nuevo valor de b, o la potencia nueva que se buscaba
		
    end
	
end =#

# ╔═╡ 1a338fb1-44d6-4793-948c-5a6f2e187791
begin
	import Base. ^
	
	function ^(a::intervalo, m::Int64)
		if rem(m, 2) == 0 #Vemos si la potencia es par
			
		    if abs(a.inf) < abs(a.sup) 
			    potinf = abs(a.inf)^m
			    potsup = abs(a.sup)^m
		    elseif abs(a.sup) < abs(a.inf)
			    potinf = abs(a.sup)^m
			    potsup = abs(a.inf)^m
		    end
			
		elseif rem(m, 2) > 0 #Vemos si la potencia es impar
				potinf = a.inf^m
			    potsup = a.sup^m
		end
		
		return intervalo(potinf, potsup)
	end
	
end

# ╔═╡ 06253152-86e6-4449-811d-288ca381da70
^(I1, 3)

# ╔═╡ 09b7fdad-8d3d-4ad5-88ea-86c6d266f250
begin 
	
	#import Base: ÷ #Importamos de base el div pero segun yo no es necesario, creo 
	#No, no es necesario xD
	function ÷(a::intervalo, b::intervalo) #Definimos la función división
		@assert b.inf < 0 && b.inf > 0 && b.sup < 0 && b.sup > 0 #Que no haya ceros
	    divinf=min(a.inf*(1/b.sup), a.inf*(1/b.inf), a.sup*(1/b.sup), a.sup*(1/b.inf))
	    divsup=max(a.inf*(1/b.sup), a.inf*(1/b.inf), a.sup*(1/b.sup), a.sup*(1/b.inf))
	    return intervalo(divinf, divsup) #Regresamos el valor de la división calculado
    end
	
end

# ╔═╡ 92b5da99-b067-4b68-8bff-2b15090df7b9
+(I1,I2)

# ╔═╡ e10f41f4-739d-4f30-8b85-b8b87bc02635
n=2


# ╔═╡ ac97b423-45cd-45d5-94be-528fc40f3f86
begin
	I9=intervalo(0.0,1.0) 
	I8=intervalo(-Inf, Inf) 
	*(I8,I9)
end

# ╔═╡ Cell order:
# ╠═7dfae42a-4211-11ec-3983-29e1cea73a3b
# ╠═b6be6e7a-3ae9-48ba-abf6-bd04e889164b
# ╠═a2d08992-2591-4f1d-a8e0-43076aa9d5e2
# ╠═d1affbbd-b74e-4983-a6a2-92a688ab6c19
# ╠═477da29e-8326-48aa-b823-01cc86c4d4b3
# ╠═5b13850e-1e68-461b-a41c-2cd695502716
# ╠═6a5926ee-e419-4ea4-9ed2-fe1dd110de89
# ╠═94aa2723-4d33-4a1d-b9f0-eae10c02f157
# ╠═85117a02-e8fb-40e9-b9dc-43e1b599179a
# ╠═cb54faf9-cd66-4459-b3f9-9917b6d5df7b
# ╠═38542482-adfd-45d9-8190-c823e63740cf
# ╠═1eac0dc7-89db-42fe-bff5-d5db0b317383
# ╠═9b51c7e4-7c48-4f46-8e52-4f8d4fbd6cbe
# ╠═b55288a2-3e37-4f0e-9e29-54646aaf672a
# ╠═f18f5215-6846-4ee2-aa5a-a1bb0926c720
# ╠═ba47a76f-75b7-4ee0-8f5a-aaa3332d9cc3
# ╠═715fe57f-04c9-4ec2-96d7-cfc3f83c5baf
# ╠═bdc3c336-77c1-47f2-a7f7-0bd5b41e38d0
# ╠═baf8ef76-0642-4510-82cc-668e0cf216c3
# ╠═1a338fb1-44d6-4793-948c-5a6f2e187791
# ╠═06253152-86e6-4449-811d-288ca381da70
# ╠═09b7fdad-8d3d-4ad5-88ea-86c6d266f250
# ╠═92b5da99-b067-4b68-8bff-2b15090df7b9
# ╠═e10f41f4-739d-4f30-8b85-b8b87bc02635
# ╠═ac97b423-45cd-45d5-94be-528fc40f3f86
