### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ 4b284cea-50cb-11ec-35ae-37833d8ea5c5
module Intervalos

export Intervalo, intervalo_vacio

export ⪽, ⊔, division_extendida, /

#using Markdown

#using InteractiveUtils



begin 
	
	"""
	             Intervalo
	La siguiente estructura definira un intervalo, que es un conjunto cerrado continuo donde el ´inf´ denota al valor minimo del intervalo y el ´sup´ el valor maximo del mismo.
	"""
struct Intervalo{T<:Real} #Definimos la estructura, tendra un subtipo menor a Real
		infimo :: T #TDefinimos el tipo de las variables que tendra, en este caso el 
		            #inf
		supremo :: T #Definimos el tipo de la variabla sup, que sera de tipo T
		#mismo :: T #Definimos el tipo de la variable punto que sera tipo T
		
		###############################
		
		function Intervalo(infimo::T, supremo::T) where {T<:AbstractFloat}#Definimos la función
			
			if isnan(infimo) || isnan(supremo)
				return new{T}(NaN, NaN)
				
			else 
				#@assert infimo ≤ supremo #Hacemos la afirmación de inf menor a sup
				return new{T}(infimo, supremo) #Nos regresa un intervalo y de tipo T

			end
			
		end
		

		
		###########################
		
		function Intervalo(infimo::T, supremo::R) where {T<:Real, R<:Real} #Definimos la función
			i, s, l = promote(infimo, supremo, 1.0) #No necesariamente tiene que tener 
			                                     #los mismos tipos
			return Intervalo(i,s) #con Promote hacemos que sean del mismo tipo de 
		end                       #mayor jererquia y nos regresa la función 
		                          #intervalo anterior
		
		function Intervalo(mismo::T) where{T<:Real} #Definimos la función para un punto
			
			return Intervalo(mismo, mismo)     #nos regresa el intervalo del punto
		end
	
end
	
#end

########

begin      ###### Intervalo vacio ######
		
		function intervalo_vacio()    #Para el caso sin argumentos 
			return Intervalo(NaN)      
		end
			
		function intervalo_vacio(T::Type{<:Real}) #Donde recibe un
			A = promote_type(T, Float64)          #argumento
			return Intervalo(A(NaN), A(NaN))
		end
		
		function intervalo_vacio(x::T) where {T<:Real}#Donde recibe un
			A = promote_type(T, Float64) 			  #valor real
			return Intervalo(A(NaN), A(NaN))
		end
	
		function intervalo_vacio(I::Intervalo{T}) where {T<:Real} #Recibe un
			return Intervalo(T(NaN), T(NaN))                      #intervalo
		end
end
		
	
########			########			#######
begin
		###### Vemos si algun conjunto es vacio ########
		
		function esvacio(a::Intervalo)

			if a.infimo == Inf && a.supremo == Inf || isnan(a.infimo) || isnan(a.supremo)
				return true
     		else 
         		return false
     		end 
			#¿Es necesario continuar con los infinitos o solo con ifnan()?
		end
		
end
	

	
begin
	
	#### Igualdad de intervalos ####
	
	import Base: == #No se lo entiendo del todo pero me pedia importar :V
	
	function ==(a::Intervalo, b::Intervalo) #Definimos la función de igualdad
			if isnan(a.infimo) && isnan(b.infimo) && isnan(b.supremo) && isnan(a.supremo)
				return true
			else
				return a.infimo == b.infimo && a.supremo == b.supremo
			end
		
	end
	
end


begin
	#Union de intervalos
	
	import Base: ∪
	
	function ∪(a::Intervalo, b::Intervalo) #Definimos la operación union#
		
		if esvacio(a) && esvacio(b)
			return intervalo_vacio()
		elseif esvacio(b)
			return a
		elseif esvacio(a)
			return b
		else 
			CotI=min(a.infimo, b.infimo)                        
			CotS=max(a.supremo, b.supremo)
			return Intervalo(CotI, CotS) 
		end
		
	    
    end
	
end


begin 
	const ⊔ = ∪  
	const hull = ∪ 
end
	

begin
	#Intersección de intervalos
	
	import Base: ∩
	
	function ∩(a::Intervalo, b::Intervalo) 
		#definimos la función de intersección 
		if esvacio(a) || esvacio(b)
			return intervalo_vacio()
		elseif a.supremo < b.infimo && a.infimo < b.infimo   #Vemos que el intervalo a y b son ajenos con a.sup < b.inf
			return intervalo_vacio() #de ser el caso nos arroja el vacio
		elseif b.supremo < a.infimo && b.infimo < a.infimo #Vemos que sean ajenos para el otro caso que a este a la 
		                  #derecha de b
			return intervalo_vacio() #De ser el caso nos arroja el intervalo vacio
		elseif b.supremo < a.supremo && b.supremo > a.infimo  #vemos un primer caso de la intersección
			CotMin= max(a.infimo, b.infimo)  #como b esta atrapado en a, b.sup < a.sup, la cota
			return Intervalo(CotMin, b.supremo) #minima estara denotada por la maxima de los 
		                                #inf
		elseif a.supremo < b.supremo && a.supremo > b.infimo #El otro caso donde a.sup < b.sup
			CotMin= max(a.infimo, b.infimo)   #Vemos la cota inf adecuada para la intersección
		    return Intervalo(CotMin, a.supremo) #Nos regresa la intersección
		
		end
	
	end 
	
end
	

begin
	#⊔
	##### Pertenencia de elementos ####
	
	import Base: ∈
	
	function ∈(x::Real, j::Intervalo) 
		#Definimos el operador logico ∈ ¨pertenencia¨
		if esvacio(j)
			return false
		else
			return j.infimo ≤ x ≤ j.supremo 
		end
		
	end
	
end
	
begin
	##### Contención de elementos ####
	
	function ⪽(a::Intervalo, b::Intervalo)
		#definimos la función "si es interior"
		if esvacio(a)
			return true
		elseif a.infimo > b.infimo && a.supremo < b.supremo
			return true
		else 
			return false
		end
		
	end
	
end
	
begin
	
	#### Contención inversa ####
	
	function ⊃(a::Intervalo, b::Intervalo) #Definimos el operador logico ⊃
		if esvacio(b)
			return true
		elseif b.infimo > a.infimo && b.supremo < a.supremo 
			if a.infimo == b.infimo && a.supremo == b.supremo 
				return false
			else 
				return true
			end
		else
			return false
		end
		
	end
	
end
	
begin
	### contenido o igual ####
	
	import Base: ⊆
	
	function ⊆(a::Intervalo, b::Intervalo) #Definimos el operador logico ⊆
		if esvacio(a)
			return true
		elseif a.infimo ≥ b.infimo && a.supremo ≤ b.supremo 
			return true
		else
			return false
		end
	
	end
	
end
	
begin
	#### Suma de intervalos ####
	
	import Base: + 
	
	function +(a::Intervalo, b::Intervalo)  #Definimos la suma
		if esvacio(a) && !esvacio(b) && b.infimo !== 0.0 && b.supremo !== 0.0
			return b
		elseif esvacio(b) && !esvacio(a) && a.infimo !== 0.0 && a.supremo !== 0.0
			return a
		else
	    	suminf = prevfloat(a.infimo + b.infimo )       #sumamos infimos
	    	sumsup = nextfloat(a.supremo + b.supremo)      #Sumamos supremos
	    	return Intervalo(suminf, sumsup)  #Regresamos el intervalo supremo
		end
		
    end
		
end
	
begin
	
	
	import Base: + 
	
	function +(a::Intervalo, c::T) where{T<:Real} #Definimos la suma
			
		if esvacio(a)
			return intervalo_vacio()
				
		elseif !esvacio(a)
			suminf = prevfloat(a.infimo + c)
			sumsup = nextfloat(a.supremo + c)
			return Intervalo(suminf, sumsup)
		end
		
	end
		
end
	
begin
	
	
	import Base: + 
	
	function +(c::T, b::Intervalo) where{T<:Real}  #Definimos la suma
		if esvacio(b) 
			return intervalo_vacio()
		elseif !esvacio(b)
			suminf = prevfloat(b.infimo + c)
			sumsup = nextfloat(b.supremo + c)
			return Intervalo(suminf, sumsup)
		end
		
	end
		
end
	
begin
	
	
	import Base: + 
	
	function +(a::Intervalo)  #Definimos la suma
		if esvacio(a)
			return intervalo_vacio()
		elseif !esvacio(a)
			return Intervalo(+a.infimo, +a.supremo)
		end
		
	end
	
end


begin
	#### Resta de intervalos ####
	
	import Base: -   #importamos de Base el -
	
	function -(a::Intervalo, b::Intervalo) #Definimos la resta
		if esvacio(a)
			return Intervalo(min(-b.supremo, -b.infimo),max(-b.infimo, -b.supremo))
		elseif esvacio(b)
			return Intervalo(min(-a.supremo, -a.infimo),max(-a.infimo, -a.supremo))
		else
	    	restinf = prevfloat(a.infimo - b.supremo)   #Hacemos el infimo de la resta
	    	restsup = nextfloat(a.supremo - b.infimo)   #Hacemos el supremo de la resta
	    	return Intervalo(restinf, restsup)  #Devolvemos el intervalo resta
		end
		
    end
	
	function -(a::Intervalo, c::T) where{T<:Real} #Definimos la suma
		if esvacio(a)
			return intervalo_vacio()
		else
			suminf = prevfloat(a.infimo - c)
			sumsup = nextfloat(a.supremo - c)
			return Intervalo(suminf, sumsup)
		end
		
	end
	
	function -(c::T, b::Intervalo) where{T<:Real}  #Definimos la suma
		if esvacio(b)
			return intervalo_vacio()
		else
			suminf = prevfloat(c + min(-b.supremo, -b.infimo))
			sumsup = nextfloat(c + max(-b.infimo, -b.supremo))
			return Intervalo(suminf, sumsup)
		end
		
	end
	
	function -(a::Intervalo) #Definimos la suma
		return Intervalo( min(-a.supremo, -a.infimo) , max(-a.infimo, -a.supremo) ) 
	end
	
end

begin
	
	#### Multiplicación de intervalos ####
	
	import Base: * #importamos de Base el *
	
	function *(a::Intervalo, b::Intervalo) #Definimos el producto
		if esvacio(a) || esvacio(b)
			return intervalo_vacio()
					
		elseif a == Intervalo(-Inf, Inf) && b == Intervalo(0.0)
			return b 
		else
			producinf = min(a.infimo*b.infimo, a.infimo*b.supremo, a.supremo*b.infimo, a.supremo*b.supremo)
			producsup = max(a.infimo*b.infimo, a.infimo*b.supremo, a.supremo*b.infimo, a.supremo*b.supremo) 
			return Intervalo( prevfloat(producinf),  nextfloat(producsup) ) #Devolvemos el producto 
		end
		
    end
	
	function *(a::Intervalo, c::T) where{T<:Real}#Definimos el producto
			if esvacio(a)
				return intervalo_vacio()
			else 
				producinf = min(a.infimo*c, a.supremo*c)
	    		producsup = max(a.infimo*c, a.supremo*c) 
	    		return Intervalo( prevfloat(producinf),  nextfloat(producsup) ) #Devolvemos el producto 
			end
		
    end
	
	function *(c::T, a::Intervalo) where{T<:Real}#Definimos el producto
		if esvacio(a)
			return intervalo_vacio()
		else
	    	producinf = min(a.infimo*c, a.supremo*c)
	    	producsup = max(a.infimo*c, a.supremo*c) 
	    	return Intervalo( prevfloat(producinf), nextfloat(producsup) ) #Devolvemos el producto 
		end
		
    end
	
end
	
	#### División de intervalos ####
	
begin
        import Base: /
		function /( r::R, a::Intervalo ) where{R<:Real}
			if a == Intervalo(0.0)
				return intervalo_vacio()
			elseif r ≥ 0
				return Intervalo( prevfloat(r/a.supremo), nextfloat(r/a.infimo) )
			else 
				return Intervalo( prevfloat(r/a.infimo), nextfloat(r/a.supremo) )
			end
			
		end
		
end
	
begin
		import Base: /
		function /(a::Intervalo, b::Intervalo)
			if esvacio(b)
				return intervalo_vacio()
			elseif 0.0 ∈ b
				if b == Intervalo(0.0)
					return intervalo_vacio()
				elseif b.infimo < 0.0 < b.supremo
					return Intervalo(-Inf, Inf)
				elseif b.infimo == 0.0 < b.supremo 
					c = Intervalo(1/b.supremo, Inf)
					return Intervalo( prevfloat(min(a.infimo*c.infimo, a.supremo*c.infimo) ), Inf )
				elseif b.infimo ≤ 0.0 ≤ b.supremo 
					c = Intervalo( -Inf, 1/b.infimo )
					return Intervalo( -Inf, nextfloat( max(a.infimo*c.supremo, a.supremo*c.supremo) ) )
				end
			else 
				c = Intervalo(1/b.supremo, 1/b.infimo)
				return Intervalo( prevfloat( min( a.infimo*c.infimo, a.infimo*c.supremo, a.supremo*c.infimo , a.supremo*c.supremo) ), nextfloat( max( a.infimo*c.infimo, a.infimo*c.supremo, a.supremo*c.infimo , a.supremo*c.supremo)) )
			end
			
		end
		
end
	
begin
		
	import Base: inv
	
	function inv(a::Intervalo)
		return Intervalo(1.0)/a
	end
	
end
	
	
begin
	#### Potencias de intervalos ####
	
	import Base: ^
	
	function ^(a::Intervalo, m::Int64)
		
		if rem(m, 2) == 0 && m > 0#Vemos si la potencia es par y positiva
			
		    if a.infimo < 0 && a.supremo > 0
				if m==0
				    potinf = a.infimo^m
				    potsup = a.supremo^m
					return Intervalo(prevfloat(potinf), nextfloat(potsup))
					#break
				else
					potinf = zero(a.infimo)
				    potsup = max(a.infimo^m,a.supremo^m)
					return Intervalo(prevfloat(potinf), nextfloat(potsup))
				end
					
				
			else
				potinf = min(a.infimo^m,a.supremo^m)
				potsup = max(a.infimo^m,a.supremo^m)
				return Intervalo(prevfloat(potinf), nextfloat(potsup))
				
		    end
				
		elseif m < 0
			
			return Intervalo( prevfloat(a.infimo^-m), nextfloat(a.supremo^-m))
				
		elseif m == 1
			return a
		elseif esvacio(a)
			return intervalo_vacio()
			
		else rem(m, 2) != 0 && m >0 #Vemos si la potencia es impar
			potinf = min( a.infimo^m, a.supremo^m )
			potsup = max( a.infimo^m, a.supremo^m)
			return Intervalo(prevfloat(potinf), nextfloat(potsup))
		end
		
	end
	
end	
		
begin
	#### División de intervalos extendida ####
	
	
	function division_extendida(a::Intervalo, b::Intervalo) 
			#Definimos la función división
		
		if b.supremo < 0 || 0 < b.infimo
	    	divinf = min(a.infimo*(1/b.supremo), a.infimo*(1/b.infimo), a.supremo*(1/b.supremo), a.supremo*(1/b.infimo) )
			divsup = max(a.infimo*(1/b.supremo), a.infimo*(1/b.infimo), a.supremo*(1/b.supremo), a.supremo*(1/b.infimo) )
	    	return ( Intervalo( prevfloat(divinf), nextfloat(divsup) ), ) ##### Salida #####
		elseif (a.infimo ≤ 0 && 0 ≤ a.supremo) && (b.infimo ≤ 0 && 0 ≤ b.supremo)
			return ( Intervalo(-Inf, Inf), ) ##### Salida #####
		
		elseif a.supremo < 0 && b.infimo < b.supremo == 0
			return ( Intervalo( prevfloat(a.supremo/b.infimo), Inf), ) ##### Salida #####
		elseif a.supremo < 0 && b.infimo < 0 < b.supremo
			return ( Intervalo(-Inf, nextfloat(a.supremo/b.supremo)), Intervalo( prevfloat(a.supremo/b.infimo), Inf) ) ##### Salida #####
		elseif a.supremo < 0 && 0 == b.infimo < b.supremo
			return ( Intervalo(-Inf, nextfloat(a.supremo/b.supremo) ), ) ##### Salida #####
		elseif 0 < a.infimo && b.infimo < b.supremo == 0
			return ( Intervalo( -Inf, nextfloat(a.infimo/b.infimo) ), ) ##### Salida #####
		elseif 0 < a.infimo && b.infimo < 0 < b.supremo
			return (Intervalo(-Inf, nextfloat(a.infimo/b.infimo) ), Intervalo( prevfloat(a.infimo/b.supremo), Inf) ) # ( Intervalo(-Inf, nextfloat(a.infimo/b.infimo) ), Intervalo( prevfloat(a.infimo/b.supremo), Inf) )
		elseif 0 < a.infimo && 0 == b.infimo < b.supremo 
			return ( Intervalo(prevfloat(a.infimo/b.supremo), Inf), ) ##### Salida #####
		
		elseif (a.supremo < 0 || a.infimo > 0) && b.infimo == 0 && b.supremo == 0
			return ( intervalo_vacio(), )  ##### Salida #####
		elseif isnan(b.infimo) && isnan(b.supremo)
			return ( intervalo_vacio(), )  ##### Salida #####
		
		end
		
    end
	
	end
	
end

end

# ╔═╡ 9dc7e62e-09d9-434f-b049-9b998f80a87a
#=
begin
	
u = Intervalo(1.0)
z = Intervalo(0.0)
a = Intervalo(1.5, 2.5)
b = Intervalo(1, 3)
c = Intervalo(BigFloat("0.1"), big(0.1))
d = Intervalo(-1, 1)
emptyFl = intervalo_vacio(Float64)
emptyB = intervalo_vacio(BigFloat)
	
end =#

# ╔═╡ a5007748-66b3-41b9-bbdf-af88f7a350ba
#=typeof(a) == Intervalo{Float64}
getfield(a, :infimo) == 1.5
getfield(a, :supremo) == 2.5

typeof(b) == Intervalo{Float64}
    @test getfield(b, :infimo) == 1.0
    @test getfield(b, :supremo) == 3.0

    @test typeof(c) == Intervalo{BigFloat}
    @test getfield(c, :infimo) == BigFloat("0.1")
    @test getfield(c, :supremo) == big(0.1)

    @test typeof(emptyFl) == Intervalo{Float64}
    @test typeof(emptyB) == Intervalo{BigFloat}

    @test u == Intervalo(1.0)
    @test z == Intervalo(0.0)
    @test z == Intervalo(big(0.0)) =#

# ╔═╡ 6213641c-e283-46de-8101-e228e7c3eb67
#=@test a == a
    @test a !== b
    @test c == c
    @test emptyFl == emptyB
    @test a ⊆ a
    @test a ⊆ b
    @test emptyFl ⊆ b
    @test b ⊇ a
    @test c ⊆ c
    @test !(c ⊆ b) && !(b ⊆ c)
    @test a ⪽ b
    @test emptyFl ⪽ b
    @test !(c ⪽ c)
    @test a ∪ b == b
    @test a ⊔ b == b
    @test a ∪ emptyFl == a
    @test c ⊔ emptyB == c
    @test a ∩ b == a
    @test a ∩ emptyFl == emptyFl
    @test a ∩ c == emptyB
    @test 0 ∈ z
    @test 2 ∈ a
    @test 3 ∉ a
#0.1 ∈ c
end
=#

# ╔═╡ 62facbc9-8804-47e3-9915-c785153847b8
### "Operaciones aritméticas" begin
#emptyFl + z == emptyFl
#z + z == Intervalo(prevfloat(0.0), nextfloat(0.0))
#u + z == u + 0.0
#z - u == 0.0-u
#-u ⪽ z - u
#b + 1 == 1.0 + b == Intervalo(prevfloat(2.0), nextfloat(4.0))
#d ⪽ 2*(a - 2)
#c - 0.1 !== z
#emptyFl * z == emptyFl
#Intervalo(0.1, 0.1) ⪽ 0.1 * u
#Intervalo(-0.1, 0.1) ⪽ d * 0.1
#d * (a + b) ⊆ d*a + d*b
#d^1 == d   
#d^2 == Intervalo(0, nextfloat(1.0))
#emptyB^2 == emptyB
#emptyFl^3 == emptyFl

# ╔═╡ c63b3b84-d536-4d42-9697-a21d7fa2b79c
#Intervalo(0,Inf) * u == Intervalo(prevfloat(0.0), Inf)
#Intervalo(-Inf,Inf) * z == z
#emptyFl * z == emptyFl
#d ⪽ d*d
#d ⪽ d^3
#d^4 == d^2
#a / emptyFl == emptyFl
#emptyB / c == emptyB
#emptyFl / emptyFl == emptyFl
#u/d == Intervalo(-Inf, Inf)
#inv(Intervalo(0.0)) == emptyFl
#0.5 ∈ u/a
#1 ∈ a/a
#c^(-1) == 1/c 
#inv(a) == 1/a
#(a-1)*(a-2) ⪽ (a*a -3*a + 3)
#a/d == Intervalo(-Inf, Inf)
#z/z == intervalo_vacio(z)
#u ⪽ 1/u

##########

#all(division_extendida(u,z) .== (emptyFl,))        
#all(division_extendida(z,z) .== (Intervalo(-Inf,Inf),))
#all(division_extendida(u,u) .== (u/u,)) 
#all(division_extendida(u, Intervalo(0,1)) .== (u/Intervalo(0,1),)) 
##########

#division_extendida(u, Intervalo(0,1)) == u/Intervalo(0,1)
#all(division_extendida(u,d) .== (u/Intervalo(-1,0), u/Intervalo(0,1)))

# ╔═╡ Cell order:
# ╠═4b284cea-50cb-11ec-35ae-37833d8ea5c5
# ╠═9dc7e62e-09d9-434f-b049-9b998f80a87a
# ╠═a5007748-66b3-41b9-bbdf-af88f7a350ba
# ╠═6213641c-e283-46de-8101-e228e7c3eb67
# ╠═62facbc9-8804-47e3-9915-c785153847b8
# ╠═c63b3b84-d536-4d42-9697-a21d7fa2b79c
