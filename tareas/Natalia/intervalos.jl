
module Intervalos

import Base: ∪, ∩, ∈, ⊆, ==, +, -, *, /, ^, isempty, one, zero
export Intervalo, intervalo_vacio, isint, hull, ⪽, ⊔, inv, mag, mig, division_extendida, esmonotona, mid, diam

"""
Intervalo.
	
Estructura básica de un intervalo, dado su ínfimo = mínimo y supremo = máximo (intervalos cerrados), dónde infimo ≤ supremo. Son subconjuntos *cerrados* y
*acotados* de la recta real.

"""
struct Intervalo{T <: Real} <: Real
		
    infimo :: T
    supremo :: T 
	
    #Si el Intervalo no está correctamente definido: 
		
    function Intervalo(infimo::T, supremo::T) where {T<:AbstractFloat}
	
                @assert infimo ≤ supremo 
               
                return new{T}(infimo, supremo)
    end
     
    #Si ingresamos un sólo parámetro (Intervalo[a]):
		
     function Intervalo(real::T) where {T<:Real}
                     
                return new{T}(real, real)
            
     end	
 
     # Para promover los argumentos de mi intervalo

      function Intervalo(infimo::T, supremo::R) where{T<:Real, R<:Real} 

      I,S,_= promote(infimo, supremo, 1.0)
      return Intervalo(I,S)

end 

end 


#########################

#######INTERVALO VACÍO#######

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

###OPERACIONES DE CONJUNTOS###  

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

####OPERACIONES ARITMÉTICAS#### 

########################

#Suma de intervalos +
	
                 function +(A::Intervalo, B::Intervalo)
		
		if isempty(A) 
			
			return A
			
		elseif isempty(B)
			
			return B
			
		else 
			return Intervalo(prevfloat(A.infimo + B.infimo), nextfloat( A.supremo + B.supremo))
	                end 
	end 

                function +(A::Intervalo, x::Real) 
                             
                                  I = A + Intervalo(x) #Caso [a,b] + x
                          
                                  return I
                end 
                
	+(x::Real, A::Intervalo) = Intervalo(x) + A #Caso x + [a,b]
	+(A::Intervalo) = A #Caso x + [a,b]


#Resta de intervalos -

	
	-(A::Intervalo, B::Intervalo)=Intervalo(prevfloat(A.infimo - B.supremo), nextfloat(A.supremo - B.infimo))
	-(A::Intervalo, x::Real) = A - Intervalo(x) #Caso [a,b] - x 
	-(x::Real, A::Intervalo) = Intervalo(x) - A #Caso x - [a,b]
	-(A::Intervalo) = Intervalo(-A.supremo, -A.infimo) #Caso x + [a,b]


#Multiplicación de intervalos x

function *(A::Intervalo, B::Intervalo)

                if isempty(A) || isempty(B)

                     return intervalo_vacio(BigFloat)
 
	elseif A == Intervalo(-Inf,Inf) && B == Intervalo(0,0)  
		             
	     return B
		
                else 

                     return Intervalo(prevfloat(min(A.infimo*B.infimo,A.supremo*B.infimo,A.infimo*B.supremo,A.supremo*B.supremo)),nextfloat(max(A.infimo*B.infimo,A.supremo*B.infimo,A.infimo*B.supremo,A.supremo*B.supremo)))
                
               end 
end 


*(A::Intervalo, x::Real) = Intervalo(prevfloat(x*A.infimo),nextfloat(x*A.supremo)) #Caso c*[a,b]
*(x::Real, A::Intervalo) = Intervalo(prevfloat(x*A.infimo),nextfloat(x*A.supremo)) #Caso [a,b]*c


#División de intervalos /

function /(A::Intervalo, B::Intervalo)
              
               if isempty(A) || isempty(B)

                     return intervalo_vacio(BigFloat)

               elseif A.infimo == B.infimo == 0 && A.supremo == B.supremo == 0

                     return intervalo_vacio(BigFloat)

               elseif 1/B.supremo > 1/B.infimo 
                
                    return Intervalo(-Inf, Inf)
              else 
                        I = A*Intervalo(1/B.supremo,1/B.infimo)
			
	       return I

               end 
end 
	function /(x::Real, B::Intervalo)
		
		I = x*Intervalo(1/B.supremo,1/B.infimo)
		
		return I
		
	end 
	
	function /(A::Intervalo, x::Real)
		
		I = A*Intervalo(1/x,1/x)	
		
		return I
		
	end 


#Función inverso inv(a)

import Base. inv

	function inv(A::Intervalo)
		
	       if A == Intervalo(0,0)

		 return intervalo_vacio(BigFloat)

       	      else 
		I = Intervalo(prevfloat(1/A.supremo), nextfloat(1/A.infimo))

	                return I

	     end 
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

	function ^(A::Intervalo, n::Int64)
	
	if n == 0
			
	    I = Intervalo(1,1)
    
	    return I 
		
    elseif isempty(A)
       
         return A

	elseif n == 1
			
	         I = A
			
	        return A
	
	elseif n == -1
			
	        return inv(A)
	
	elseif 0 ∈ A

                       if n%2 == 0 

                          return Intervalo(0, nextfloat(mag(A)^n))

                       else 

                         return  Intervalo(prevfloat(A.infimo^n), nextfloat(A.supremo^n))

                      end

               elseif mod(n,2) == 0
			    
	         I = Intervalo(prevfloat(mig(A)^n), nextfloat(mag(A)^n)) #PAR
	         
             return I
     else 
		
	I = Intervalo(prevfloat(A.infimo^n), nextfloat(A.supremo^n)) #IMPAR
                          
             return I 		
     end	
end  


#División extendida 

function division_extendida(A::Intervalo, B::Intervalo)
		
		if 0 ∉ B
			I = A*Intervalo(1/B.supremo,1/B.infimo)
			
			return (I,)
			
		elseif 0 ∈ A && 0 ∈ B
			
			return (Intervalo(-Inf,Inf),)

                               elseif A.supremo < 0 && B.infimo<B.supremo == 0
 
                                               return (Intervalo(prevfloat(A.supremo/B.infimo),Inf),)
			
		elseif (A.supremo < 0) && (B.infimo < 0 < B.supremo) 
			
			return (Intervalo(-Inf,nextfloat(A.supremo/B.supremo)),Intervalo(prevfloat(A.supremo/B.infimo),Inf),)
		
		elseif A.supremo < 0 && 0 == B.infimo < B.supremo
			
			return (Intervalo(-Inf, nextfloat(A.supremo/B.supremo)),)
			
		elseif 0 < A.infimo && 0 == B.supremo > B.infimo 
			
			return (Intervalo(-Inf, nextfloat(A.infimo/B.infimo)),)
			
		elseif (0 < A.infimo) && (B.infimo < 0 < B.supremo)

                                              if  1/B.supremo > 1/B.infimo 
                
                                                    return (Intervalo(-Inf, Inf), Intervalo(prevfloat(A.infimo/B.supremo), Inf),)

                                              else 
			
		                return (Intervalo(-Inf, nextfloat(A.infimo/B.infimo)), Intervalo(prevfloat(A.infimo/B.supremo), Inf),)
			
                                              end
 
		elseif B.infimo == B.supremo == 0 && 0 ∉ A 
			
			return (intervalo_vacio(BigFloat),)
			
		else 
			
			return (Intervalo(prevfloat(A.infimo/B.supremo), Inf),)
		
		end 
	end 

#ONE 

    one(I::Intervalo{T}) where T<:Real = Intervalo(one(T))

#CERO 
   
   zero(I::Intervalo{T}) where T<:Real = Intervalo(zero(T))


#FUNCIÓN PARA VERIFICAR QUE F SEA MONÓTONA

	function esmonotona(f::Function,D::Intervalo)
		R=ForwardDiff.derivative(f,D)
	                (R.infimo < 0 && R.supremo > 0) || (R.infimo > 0 && R.supremo < 0) && return false
		return true
               end 

#EN ESTA PARTE AGREGAMOS MÁS FUNCIONES QUE SE USARÁN EN EL MÉTODO DE NEWTON

#Función diam que nos da el diámetro o longitud de un intervalo 

function diam(I::Intervalo)
           d = I.supremo - I.infimo
           return d 
end 

#Función mid que calcula el punto medio de un intervalo y da el intervalo asociado  a ese punto medio 

function mid(I::Intervalo)
	m = (I.supremo + I.infimo)/2 
	Im = Intervalo(m)
	return Im 
end 


end 