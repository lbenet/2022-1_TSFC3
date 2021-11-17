### A Pluto.jl notebook ###
# v0.16.1

module Intervalos

import Base. ∩; import Base. ∈; import Base. ⊆; import Base. ==; import Base. :+; import Base. -; import Base. *; import Base. /; import Base. ^; 

export Intervalo; export intervalo_vacio; export isint; export hull; 

"""
Intervalo.
	
Estructura básica de un intervalo, dado su ínfimo = mínimo y supremo = máximo (intervalos cerrados), dónde infimo ≤ supremo. Son subconjuntos *cerrados* y
*acotados* de la recta real.

"""
struct Intervalo{T <: Real}
		
    infimo :: T
    supremo :: T
	
	
	function Intervalo(infimo::T, supremo::T) where {T<:Real}
			
			if  infimo == Inf 
				
				return new{T}(Inf,-Inf) 
			
			elseif infimo ≤ supremo
	 
				return new{T}(infimo, supremo)
			else 
				 Main.throw(Main.AssertionError("No se admite infimo > supremo"))
			end
	end 
	
            #Si ingresamos un sólo parámetro (Intervalo[a]):
		
            function Intervalo(real::T) where {T<:Real}
                     
                     return new{T}(real, real)
            
            end	 
end 

   # Para promover los argumentos de mi intervalo: 
	
   Intervalo(infimo::T, supremo::R) where{T<:Real, R<:Real} =
   Intervalo(promote(infimo, supremo)...)


#Intervalo vacio

function intervalo_vacio(T::Type)

            return Intervalo(Inf,-Inf)
		
   end

# Intervalo vacio otra vez 

function intervalo_vacio(A::Intervalo)

            return Intervalo(Inf,-Inf)
		
end

#########################

#OPERACIONES DE CONJUNTOS  

########################

# Hull ⊔ 

#Sólo funciona cuando los intervalos NO son separados

            function hull(A::Intervalo, B::Intervalo) 
	
	        I = min(A.infimo, B.infimo)
	        S = max(A.supremo, B.supremo)
	
                        return Intervalo(I, S)
            end

const ⊔ = hull

# INTERSECCIÓN ∩ 

                function ∩(A::Intervalo, B::Intervalo) 
	   
	   #Caso  Intersección vacía para I1 = [a,b] I2 =[c,d] con a < c 
	
	if A.infimo < B.infimo && A.supremo < B.infimo  
		
		return intervalo_vacio(BigFloat)
		
	   #Caso Intersección vacía para I1 = [a,b] I2 =[c,d] con c < a 
		
	elseif B.infimo < A.infimo && B.supremo < A.infimo
		
		return intervalo_vacio(BigFloat)
	  
	   #Caso Intersección no vacía tanto para a < c como para c < a
		
	else 
		 I = max(B.infimo,A.infimo)
		 S = min(B.supremo,A.supremo)
		
		return Intervalo(I,S)
	end 
end

# Pertenece a (∈)

            
            function ∈(x::Real, I::Intervalo)
	
                return I.infimo ≤ x && x ≤ I.supremo
            
            end

# Para ⪽

           function isint(A::Intervalo, B::Intervalo)
	
               return A.infimo > B.infimo && B.supremo > A.supremo
           
           end

const ⪽ = isint

# Contención impropia (⊆)

        function ⊆(A::Intervalo, B::Intervalo)
	
             if A.infimo ≥ B.infimo && B.supremo ≥ A.supremo
        
		return true
             else 
		return false
             end
      
         end


##Igualdad de conjuntos ==

       
       function ==(A::Intervalo, B::Intervalo)
	
           return A.infimo == B.infimo && A.supremo == B.supremo

end

#########################

#OPERACIONES ARITMÉTICAS 

########################

#Suma de intervalos +

	
	
	+(A::Intervalo, B::Intervalo)=Intervalo(A.infimo + B.infimo, A.supremo + B.supremo) 
	+(A::Intervalo, x::Real) = A + Intervalo(x) #Caso [a,b] + x
	+(x::Real, A::Intervalo) = Intervalo(x) + A #Caso x + [a,b]
	+(A::Intervalo) = A #Caso x + [a,b]

#Resta de intervalos -

	
	-(A::Intervalo, B::Intervalo)=Intervalo(A.infimo - B.supremo, A.supremo - B.infimo)
	-(A::Intervalo, x::Real) = A - Intervalo(x) #Caso [a,b] - x 
	-(x::Real, A::Intervalo) = Intervalo(x) - A #Caso x - [a,b]
	-(A::Intervalo) = Intervalo(-A.supremo, -A.infimo) #Caso x + [a,b]


#Multiplicación de intervalos x


	
	*(A::Intervalo, B::Intervalo)=Intervalo(min(A.infimo*B.infimo,A.supremo*B.infimo,A.infimo*B.supremo,A.supremo*B.supremo),max(A.infimo*B.infimo,A.supremo*B.infimo,A.infimo*B.supremo,A.supremo*B.supremo))
	*(A::Intervalo, x::Real) = Intervalo(x*A.infimo,x*A.supremo) #Caso c*[a,b]
	*(x::Real, A::Intervalo) = Intervalo(x*A.infimo,x*A.supremo) #Caso [a,b]*c


#División de intervalos -


	
	/(A::Intervalo, B::Intervalo)=A*Intervalo(1/B.supremo,1/B.infimo)
	/(x::Real, B::Intervalo)=x*Intervalo(1/B.supremo,1/B.infimo)
	/(A::Intervalo, x::Real)=A*Intervalo(1/x,1/x)


#Función inverso inv(a)


	function inv(A::Intervalo)
		I = Intervalo(1/A.supremo,1/A.infimo)
	         return I
                end


#Función mag

function mag(A::Intervalo)
	I = max(abs(A.infimo),abs(A.supremo))
	return I
end 

#Función mig

function mig(A::Intervalo)
	
	if A == Intervalo(0,0)
	    I = 0
	else 
		I = min(abs(A.infimo),abs(A.supremo))
	end 
	
	return I 
end

# Potencias enteras y no negativas jeje 


	function ^(A::Intervalo,n)
	
	if n == 0
			
	    I = Intervalo(1,1)
			
	elseif mod(n,2) == 0
			    
		I = Intervalo(mig(A)^n, mag(A)^n) #PAR
	
	else 
		
		I = Intervalo(A.infimo^n,A.supremo^n) #IMPAR
			
	end	
	return I 
end 


end 