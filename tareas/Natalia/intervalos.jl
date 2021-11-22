
module Intervalos

import Base. ∪; import Base. ∩; import Base. ∈; import Base. ⊆; import Base. ==; import Base. +; import Base. -; import Base. *; import Base. /; import Base. ^;  import Base. isempty;

export Intervalo; export intervalo_vacio; export isint; export hull; export  ⪽; export ⊔; export inv; export mag; export mig; 

"""
Intervalo.
	
Estructura básica de un intervalo, dado su ínfimo = mínimo y supremo = máximo (intervalos cerrados), dónde infimo ≤ supremo. Son subconjuntos *cerrados* y
*acotados* de la recta real.

"""
struct Intervalo{T <: Real}
		
    infimo :: T
    supremo :: T 
	
    #Si el Intervalo no está correctamente definido: 
		
    function Intervalo(infimo::T, supremo::T) where {T<:AbstractFloat}
	@assert infimo ≤ supremo 
                I,S,_= promote(infimo, supremo, 1.0)

                return new{T}(I, S)
    end
     
    #Si ingresamos un sólo parámetro (Intervalo[a]):
		
     function Intervalo(real::T) where {T<:Real}
                     r,_=promote(real,1.0)
                return new{T}(r, r)
            
     end	 
end 

# Para promover los argumentos de mi intervalo

function Intervalo(infimo::T, supremo::R) where{T<:Real, R<:Real} 

      I,S,_= promote(infimo, supremo, 1.0)
      return Intervalo(I,S)

end 
	
#Intervalo(infimo::T, supremo::R) where{T<:Int64, R<:Int64} = Intervalo(promote(convert(Float64,infimo), convert(Float64,supremo))...)



#########################

#INTERVALO VACÍO 

#########################



#Intervalo vacio

function intervalo_vacio(T::Type)

            return Intervalo(T(Inf))
end


# Intervalo vacio otra vez 

function intervalo_vacio(z::Intervalo{T}) where {T<:Real} 
             
            return Intervalo(T(Inf))
end


#Función que checa si mi intervalo es vacío

function isempty(B::Intervalo)

     if B.infimo == Inf && B.supremo == Inf

            return true
     else 

         return false

     end 
end

#########################

#OPERACIONES DE CONJUNTOS  

#########################

# UNIÓN ∪ 

#Sólo funciona cuando los intervalos NO son separados

function ∪(A::Intervalo, B::Intervalo) 
	        
                   if isempty(B)

                            I = A.infimo 
                            S=A.supremo

                   elseif isempty(A)

                           I = B.infimo
                           S= B.supremo

                   else 

	        I = min(A.infimo, B.infimo)
	        S = max(A.supremo, B.supremo)

	   end 

                 return Intervalo(I, S)
end


# Hull ⊔ 

#Sólo funciona cuando los intervalos NO son separados

            function hull(A::Intervalo, B::Intervalo) 
	
                   if isempty(B)

                            I = A.infimo 
                            S=A.supremo

                   elseif isempty(A)

                           I = B.infimo
                           S= B.supremo
                   else 

	           I = min(A.infimo, B.infimo)
	           S = max(A.supremo, B.supremo)

	   end 

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
	
               if isempty(A)

                     return true 

               elseif A.infimo > B.infimo && B.supremo > A.supremo

                    return true 

             else 

                  return false 

               end 
         end

const ⪽ = isint


# Contención impropia (⊆)

        function ⊆(A::Intervalo, B::Intervalo)
           
             if isempty(A)

                   return true 

             elseif A.infimo ≥ B.infimo && B.supremo ≥ A.supremo

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

function *(A::Intervalo, B::Intervalo)

                if isempty(A) || isempty(B)

                     return intervalo_vacio(BigFloat)

                else 

                     return Intervalo(min(A.infimo*B.infimo,A.supremo*B.infimo,A.infimo*B.supremo,A.supremo*B.supremo),max(A.infimo*B.infimo,A.supremo*B.infimo,A.infimo*B.supremo,A.supremo*B.supremo))
                
               end 
end 

	*(A::Intervalo, x::Real) = Intervalo(x*A.infimo,x*A.supremo) #Caso c*[a,b]
	*(x::Real, A::Intervalo) = Intervalo(x*A.infimo,x*A.supremo) #Caso [a,b]*c


#División de intervalos /

function /(A::Intervalo, B::Intervalo)
              
               if isempty(A) || isempty(B)

                     return intervalo_vacio(BigFloat)

               elseif A.infimo == B.infimo == 0 && A.supremo == B.supremo == 0

                     return intervalo_vacio(BigFloat)

               elseif 1/B.supremo > 1/B.infimo 
                
                    return Intervalo(-Inf,Inf)

              else 

                     return A*Intervalo(1/B.supremo,1/B.infimo)

               end 
end 
	
	/(x::Real, B::Intervalo)=x*Intervalo(1/B.supremo,1/B.infimo)
	/(A::Intervalo, x::Real)=A*Intervalo(1/x,1/x)


#Función inverso inv(a)

import Base. inv

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

	function ^(A::Intervalo,n::Int64)
	
	if n == 0
			
	    I = Intervalo(1,1)
    
	    return I 
		
                elseif isempty(A)
       
                         return A

	elseif 0 ∈ A

                        if n%2 == 0 

                             return Intervalo(0, mag(A)^n)

                        else 

                            return  Intervalo(A.infimo^n, A.supremo^n)

                        end

                elseif mod(n,2) == 0
			    
		I = Intervalo(mig(A)^n, mag(A)^n) #PAR
	         
                           return I
                else 
		
		I = Intervalo(A.infimo^n, A.supremo^n) #IMPAR
                          
                           return I 
			
                end	
end 

end 