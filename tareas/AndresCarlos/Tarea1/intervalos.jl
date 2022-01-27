module Intervalos

export Intervalo, intervalo_vacio

export ⪽, ⊔

using Markdown

using InteractiveUtils

	
	"""
	             Intervalo
	La siguiente estructura definira un intervalo, que es un conjunto cerrado continuo donde el ´inf´ denota al valor minimo del intervalo y el ´sup´ el valor maximo del mismo.
	"""
struct Intervalo{T<:Real} #Definimos la estructura, tendra un subtipo menor a Real
		infimo :: T #TDefinimos el tipo de las variables que tendra, en este caso el 
		            #inf
		supremo :: T #Definimos el tipo de la variabla sup, que sera de tipo T
		#mismo :: T #Definimos el tipo de la variable punto que sera tipo T
		
############################################################################################################################
		
		function Intervalo(infimo::T, supremo::T) where {T<:Union{Float64, BigFloat}}#Definimos la función
			
			if isnan(infimo)
				return new{T}(NaN, NaN)
				
			elseif infimo ≤ supremo #Hacemos la afirmación de inf menor a sup
				return new{T}(infimo, supremo) #Nos regresa un intervalo y de tipo T
				
			else "No es correcto, asi que no se cumple la desigualdad de que infimo < supremo"

			end
			
		end
		
end
		
##########################################################################################
		
		function Intervalo(infimo::T, supremo::R) where {T<:Real, R<:Real} #Definimos la función
			i, s = promote(infimo, supremo, 1.0) #No necesariamente tiene que tener 
			                                     #los mismos tipos
			return Intervalo(i,s) #con Promote hacemos que sean del mismo tipo de 
		end                       #mayor jererquia y nos regresa la función 
		                          #intervalo anterior
		
		function Intervalo(mismo::T) where{T<:Real} #Definimos la función para un 
			                                        #punto
			return Intervalo(mismo, mismo)     #nos regresa el intervalo del punto
		end
	

############################################################################################

	
		###### Intervalo vacio ######
	
		function intervalo_vacio()     #Intervalo vacio
			return Intervalo(NaN)      #Regresamos un intervalo de tipo NaN
		end
			
		function intervalo_vacio(T::Type{<:Real}) #Para los casos donde reciba un 
			                                      #argumento
			A = promote_type(T, Float64) #Definimos una función que hara una promoción
			                             #Entre lo ingresado y float64 en comun
			return Intervalo(A(NaN), A(NaN))
		end
		
		function intervalo_vacio(x::T) where {T<:Real}#caso numero real
			A = promote_type(T, Float64) #Definimos una función que hara una promoción
			                             #Entre el tipo ingresado y float64
			return Intervalo(A(NaN), A(NaN))
		end
	
		function intervalo_vacio(I::Intervalo{T}) where {T<:Real} #Definimos una 
			#función para el vacio donde el valor ingresado es de tipo intervalo y el 
			#cual toma valores de tipo menor o igual a Real
			return Intervalo(T(NaN), T(NaN)) #Aqui devolvemos un intervalo "vacio"
		end

		
	
######################################################################################################

		###### Vemos si algun conjunto es vacio ########
		
		function esvacio(a::Intervalo)

			if a.infimo == Inf && a.supremo == Inf || isnan(a.infimo) || isnan(a.supremo)
				return true
     		else 
         		return false
     		end 
			
		end
		

	#### Igualdad de intervalos ####
	
	import Base: == #No se lo entiendo del todo pero me pedia importar :V
	
	function ==(a::Intervalo, b::Intervalo) #Definimos la función de igualdad
			if isnan(a.infimo) && isnan(b.infimo) && isnan(b.supremo) && isnan(a.supremo)
				return true
			else
				return a.infimo == b.infimo && a.supremo == b.supremo
			end
		
	end
	
##################################	Union de intervalos    ################################################
	
	import Base: ∪
	
	function ∪(a::Intervalo, b::Intervalo) #Definimos la operación union#
		
		if esvacio(a) && esvacio(b)
			return intervalo_vacio()
		elseif esvacio(b)
			return a
		elseif esvacio(a)
			return b
		else 
			CotI=min(a.infimo, b.infimo) #Definimos la cota minima de los dos 
			                             #intervalos
			CotS=max(a.supremo, b.supremo) #Definimos la cota maxima de los dos 
										   #intervalos
			return Intervalo(CotI, CotS) #Regresamos la función intervalo con esas cotas
		end
		
	    
    end
	

	const ⊔ = ∪  
	const hull = ∪ 

######################################        Intersección de intervalos    ######################################
	
	import Base: ∩
	
	function ∩(a::Intervalo, b::Intervalo) #definimos la función de intersección 
		if esvacio(a) || esvacio(b)
			return intervalo_vacio()
		elseif a.supremo < b.infimo    #Vemos que el intervalo a y b son ajenos con a.sup < b.inf
			return intervalo_vacio() #de ser el caso nos arroja el vacio
		elseif b.supremo < a.infimo  #Vemos que sean ajenos para el otro caso que a este a la 
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
	

	#⊔

##############################   Pertenencia de elementos     ################################# 
	
	import Base: ∈
	
	function ∈(x::Real, j::Intervalo) #Definimos el operador logico ∈ ¨creo¨
		if esvacio(j)
			return false
		else
			return j.infimo ≤ x ≤ j.supremo 
		end
		
	end
	

#################################################     Contención de elementos       #################################################
	
	function ⪽(a::Intervalo, b::Intervalo) 
		if esvacio(a)
			return true
		else 
			return a.infimo > b.infimo && a.supremo < b.supremo
		end
		
	end
	
#################################################     Contención inversa      #################################################
	
	function ⊃(a::Intervalo, b::Intervalo) #Definimos el operador logico ⊃
		if esvacio(b)
			return true
		else
			return b.infimo > a.infimo && b.supremo < a.supremo 
		end
		
	end
	

#################################################    contenido o igual      #################################################
	
	import Base: ⊆
	
	function ⊆(a::Intervalo, b::Intervalo) #Definimos el operador logico ⊆
		if esvacio(a)
			return true
		else
			return a.infimo ≥ b.infimo && a.supremo ≤ b.supremo 
		end
	
	end
	
	

###################################################       Suma de intervalos      ################################################
	
	import Base: + 
	
	function +(a::Intervalo, b::Intervalo)  #Definimos la suma
		if esvacio(a) && !esvacio(b) && b.infimo !== 0.0 && b.supremo !== 0.0
			return b
		elseif esvacio(b) && !esvacio(a) && a.infimo !== 0.0 && a.supremo !== 0.0
			return a
		else
	    	suminf = a.infimo + b.infimo        #sumamos infimos
	    	sumsup = a.supremo + b.supremo        #Sumamos supremos
	    	return Intervalo(suminf, sumsup)  #Regresamos el intervalo supremo
		end
		
    end
		
	
	
	import Base: + 
	
	function +(a::Intervalo, c::T) where{T<:Real} #Definimos la suma
			
		if esvacio(a)
			return intervalo_vacio()
				
		elseif !esvacio(a)
			suminf = a.infimo + c
			sumsup = a.supremo + c
			return Intervalo(suminf, sumsup)
		end
		
	end
		

	
	import Base: + 
	
	function +(c::T, b::Intervalo) where{T<:Real}  #Definimos la suma
		if esvacio(b) 
			return intervalo_vacio()
		elseif !esvacio(b)
			suminf = b.infimo + c
			sumsup = b.supremo + c
			return Intervalo(suminf, sumsup)
		end
		
	end
		
	
	import Base: + 
	
	function +(a::Intervalo)  #Definimos la suma
		if esvacio(a)
			return intervalo_vacio()
		elseif !esvacio(a)
			return a
		end
		
	end
	
##################################################     Resta de intervalos     ###################################################
	
	import Base: -   #importamos de Base el -
	
	function -(a::Intervalo, b::Intervalo) #Definimos la resta
		if esvacio(a)
			return Intervalo(min(-b.supremo, -b.infimo),max(-b.infimo, -b.supremo))
		elseif esvacio(b)
			return Intervalo(min(-a.supremo, -a.infimo),max(-a.infimo, -a.supremo))
		else
	    	restinf = a.infimo - b.supremo   #Hacemos el infimo de la resta
	    	restsup = a.supremo - b.infimo   #Hacemos el supremo de la resta
	    	return Intervalo(restinf, restsup)  #Devolvemos el intervalo resta
		end
		
    end
	
	function -(a::Intervalo, c::T) where{T<:Real} #Definimos la suma
		if esvacio(a)
			return intervalo_vacio()
		else
			suminf = a.infimo - c
			sumsup = a.supremo - c
			return Intervalo(suminf, sumsup)
		end
		
	end
	
	function -(c::T, b::Intervalo) where{T<:Real}  #Definimos la suma
		if esvacio(b)
			return intervalo_vacio()
		else
			suminf = c-b.supremo
			sumsup = c-b.infimo
			return Intervalo(suminf, sumsup)
		end
		
	end
	
	function -(a::Intervalo) #Definimos la suma
		return Intervalo(min(-a.supremo, -a.infimo),max(-a.infimo, -a.supremo))
	end
	
############################################# Multiplicación de intervalos #################################################
	
	import Base: * #importamos de Base el *
	
	function *(a::Intervalo, b::Intervalo) #Definimos el producto
		if esvacio(a) || esvacio(b)
			return intervalo_vacio()
		else
			producinf = min(a.infimo*b.infimo, a.infimo*b.supremo, a.supremo*b.infimo, a.supremo*b.supremo)
			producsup = max(a.infimo*b.infimo, a.infimo*b.supremo, a.supremo*b.infimo, a.supremo*b.supremo) 
			return Intervalo(producinf, producsup) #Devolvemos el producto 
		end
		
    end
	
	function *(a::Intervalo, c::T) where{T<:Real}#Definimos el producto
			if esvacio(a)
				return intervalo_vacio()
			else 
				producinf = min(a.infimo*c, a.supremo*c)
	    		producsup = max(a.infimo*c, a.supremo*c) 
	    		return Intervalo(producinf, producsup) #Devolvemos el producto 
			end
		
    end
	
	function *(c::T, a::Intervalo) where{T<:Real}#Definimos el producto
		if esvacio(a)
			return intervalo_vacio()
		else
	    	producinf = min(a.infimo*c, a.supremo*c)
	    	producsup = max(a.infimo*c, a.supremo*c) 
	    	return Intervalo(producinf, producsup) #Devolvemos el producto 
		end
		
    end
	
############################################ Potencias de intervalos ###############################################
	
	import Base: ^
	
	function ^(a::Intervalo, m::Int64)
		
		if rem(m, 2) == 0 #Vemos si la potencia es par
			
		    if a.infimo < 0 && a.supremo > 0
				if m==0
				    potinf = a.infimo^m
				    potsup = a.supremo^m
					#break
				else
					potinf = 0
				    potsup = max(a.infimo^m,a.supremo^m)
					
				end
					
				
			else
				potinf = min(a.infimo^m,a.supremo^m)
				potsup = max(a.infimo^m,a.supremo^m)
				
		    end
			
		elseif esvacio(a)
			return intervalo_vacio()
			
		else  #Vemos si la potencia es impar
				potinf = a.infimo^m
			    potsup = a.supremo^m
		end
		
		return Intervalo(potinf, potsup)
		
	end
		

########################################### División de intervalos ############################################
	
	import Base: / #Importamos de base el div pero segun yo no es necesario, creo 
	#No, no es necesario xD
	function /(a::Intervalo, b::Intervalo) #Definimos la función división
		#@assert b.infimo < 0 && b.infimo > 0 && b.supremo < 0 && b.supremo > 0 #Que no haya ceros
		if 0 > b.supremo || 0 < b.infimo
	    	divinf = min(a.infimo*(1/b.supremo), a.infimo*(1/b.infimo), a.supremo*(1/b.supremo), a.supremo*(1/b.infimo))
			divsup = max(a.infimo*(1/b.supremo), a.infimo*(1/b.infimo), a.supremo*(1/b.supremo), a.supremo*(1/b.infimo))
	    	return Intervalo(divinf, divsup) #Regresamos el valor de la división calculado}
		elseif a.infimo < 0 < a.supremo && b.infimo < 0 < b.supremo
			return Intervalo(-Inf, Inf)
		elseif a.supremo < 0 && b.infimo < b.supremo == 0
			return Intervalo(a.supremo/b.infimo, Inf)
		elseif a.supremo < 0 && b.infimo < 0 < b.supremo
			return Intervalo(a.supremo/b.infimo, Inf) ∪ Intervalo(-Inf, a.supremo/b.supremo)
		elseif a.supremo < 0 && 0 == b.infimo < b.supremo
			return Intervalo(-Inf, a.supremo/b.supremo)
		elseif 0 < a.infimo && b.infimo < b.supremo < 0
			return Intervalo(-Inf, a.supremo/b.supremo)
		elseif 0 < a.infimo && b.infimo < 0 < b.supremo
			return Intervalo(a.infimo/b.supremo, Inf) ∪ Intervalo(-Inf, a.infimo/b.infimo)
		elseif 0 < a.infimo && 0 < b.infimo < b.supremo 
			return Intervalo(a.infimo/b.supremo, Inf)
		elseif 0 > a.supremo || 0 < a.infimo && b.infimo == 0 && b.supremo == 0
			return intervalo_vacio()
		elseif isnan(b.infimo) && isnan(b.supremo)
			return intervalo_vacio()
		elseif a.supremo == 0.0 && b.supremo == 0.0 && a.infimo == 0.0 && b.infimo == 0.0
			return intervalo_vacio()
		end
		
    end
	

	
#############################################	División de Intervalos	 ##############################################
		
	import Base: /
		
	function /(c::T, b::Intervalo) where{T<:Real} #Definimos la div para un 
													  #intervalo y un real
		a = Intervalo(c)
		if 0 > b.supremo || 0 < b.infimo
	    	divinf = min(a.infimo*(1/b.supremo), a.infimo*(1/b.infimo), a.supremo*(1/b.supremo), a.supremo*(1/b.infimo))
			divsup = max(a.infimo*(1/b.supremo), a.infimo*(1/b.infimo), a.supremo*(1/b.supremo), a.supremo*(1/b.infimo))
	    	return Intervalo(divinf, divsup) #Regresamos el valor de la división calculado}
		elseif a.infimo < 0 < a.supremo && b.infimo < 0 < b.supremo
			return Intervalo(-Inf, Inf)
		elseif a.supremo < 0 && b.infimo < b.supremo == 0
			return Intervalo(a.supremo/b.infimo, Inf)
		elseif a.supremo < 0 && b.infimo < 0 < b.supremo
			return Intervalo(a.supremo/b.infimo, Inf) ∪ Intervalo(-Inf, a.supremo/b.supremo)
		elseif a.supremo < 0 && 0 == b.infimo < b.supremo
			return Intervalo(-Inf, a.supremo/b.supremo)
		elseif 0 < a.infimo && b.infimo < b.supremo < 0
			return Intervalo(-Inf, a.supremo/b.supremo)
		elseif 0 < a.infimo && b.infimo < 0 < b.supremo
			return Intervalo(a.infimo/b.supremo, Inf) ∪ Intervalo(-Inf, a.infimo/b.infimo)
		elseif 0 < a.infimo && 0 < b.infimo < b.supremo 
			return Intervalo(a.infimo/b.supremo, Inf)
		elseif 0 > a.supremo || 0 < a.infimo && b.infimo == 0 && b.supremo == 0
			return intervalo_vacio()
		end
	end
		

##################################################### Inversa de un Intervalo ##############################################################
	

	import Base: inv
	
	function inv(a::Intervalo)
		return Intervalo(1.0)/a
	end
	
###################################################################################################################################################


end
