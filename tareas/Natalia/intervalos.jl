### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ 2f4f8fe0-43f3-11ec-0ab9-873924050de7
begin

"""
Intervalo.
	
Estructura básica de un intervalo, dado su ínfimo = mínimo y supremo = máximo (intervalos cerrados), dónde infimo ≤ supremo. Son subconjuntos *cerrados* y
*acotados* de la recta real.

"""
struct Intervalo{T <: Real}
		
    infimo :: T
    supremo :: T
	
	#Si el Intervalo no está correctamente definido: 
		
    function Intervalo(infimo::T, supremo::T) where {T<:Real}
			@assert infimo ≤ supremo 
            return new{T}(infimo, supremo)
    end
		
	#Si el supremos = infimo (Intervalo[a,a]):
	
	#=function Intervalo(infimo::T, supremo::T) where {T<:Real}
			
			if supremo == infimo 	
				
				return new{T}(supremo, supremo) 
			else 
	 
				return new{T}(infimo, supremo)
			end
	end =#
		
	#Si ingresamos un sólo parámetro (Intervalo[a]):
		
    function Intervalo(real::T) where {T<:Real}
            return new{T}(real, real)
    end	 
end 
   # Para promover los argumentos de mi intervalo: 
	
   Intervalo(infimo::T, supremo::R) where{T<:Real, R<:Real} =
   Intervalo(promote(infimo, supremo)...)
end

# ╔═╡ d091ba0b-b93d-4c97-9a92-a0be5ff52fda
#Intervalo vacío 

function intervalo_vacio(T::Type)

            return Intervalo(T(NaN))
end

# ╔═╡ feaf749b-6c4b-4059-a767-95d16774e9e9
# UNIÓN ∪ 

#Sólo funciona cuando los intervalos NO son separados

begin 
	        import Base. :∪
            function ∪(A::Intervalo, B::Intervalo) 
	
			I = min(A.infimo, B.infimo)
	        S = max(A.supremo, B.supremo)
	
            return Intervalo(I, S)
end
end 

# ╔═╡ 1504550f-aabf-4470-8fff-399be3618658
# Hull ⊔ 

#Sólo funciona cuando los intervalos NO son separados

begin 
	        import Base. :⊔
            function ⊔(A::Intervalo, B::Intervalo) 
	
			I = min(A.infimo, B.infimo)
	        S = max(A.supremo, B.supremo)
	
            return Intervalo(I, S)
end
end 

# ╔═╡ 6bd6f710-2ddd-4514-8fbf-9dc49b3bee58
# INTERSECCIÓN ∩ 

begin
	
	import Base. :∩ 
	
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
end 

# ╔═╡ 255eae6c-d39d-4801-a721-8c8469ddb247
# Pertenece a (∈)
begin
	import Base. :∈
    
	function ∈(x::Real, I::Intervalo)
	
    if I.infimo ≤ x && x ≤ I.supremo
        
		return true
    else
        
		return false
    end
end
end

# ╔═╡ 75ccfd4f-f2fd-427c-acaf-ef655b7a91e0
# Contención propia (⪽)
begin 
	
	import Base. :⪽
	
    function ⪽(A::Intervalo, B::Intervalo)
	
    if A.infimo > B.infimo && B.supremo > A.supremo
        
		return true
    else
        return false
    end
end
end

# ╔═╡ 65be1970-66d8-4084-9c3c-2382c5f9687a
# Contención propia (⊂)
begin 
	
	import Base. :⊂
	
    function ⊂(A::Intervalo, B::Intervalo)
	
    if A.infimo > B.infimo && B.supremo > A.supremo
        
		return true
    else
        return false
    end
end
end

# ╔═╡ 898d8b66-05a7-46a8-8024-e55687d06bc6
# Contención impropia (⊆)

begin
	import Base. :⊆
	
    function ⊆(A::Intervalo, B::Intervalo)
	
    if A.infimo ≥ B.infimo && B.supremo ≥ A.supremo
        
		return true
    else
        return false
    end
end
end 

# ╔═╡ fbd3988c-898b-4cc0-8be9-a4d39d78e2bb
##Igualdad de conjuntos ==

begin 
	import Base. :(==)
	function ==(A::Intervalo, B::Intervalo)
	
    if A.infimo == B.infimo && A.supremo == B.supremo
        
		return true
    else
        return false
    end
end
end

# ╔═╡ 09829aa1-1acc-408d-9666-842bead1700d
#Suma de intervalos +

begin
	import Base. :+
	
	+(A::Intervalo, B::Intervalo)=Intervalo(A.infimo + B.infimo, A.supremo + B.supremo) 
	+(A::Intervalo, x::Real) = A + Intervalo(x) #Caso [a,b] + x
	+(x::Real, A::Intervalo) = Intervalo(x) + A #Caso x + [a,b]
	+(A::Intervalo) = Intervalo(0,0) + A #Caso x + [a,b]
end


# ╔═╡ 85797823-9093-473f-870c-bd4685ada3b5
#Resta de intervalos -

begin
	import Base. :-
	-(A::Intervalo, B::Intervalo)=Intervalo(A.infimo - B.supremo, A.supremo - B.infimo)
	-(A::Intervalo, x::Real) = A - Intervalo(x) #Caso [a,b] - x 
	-(x::Real, A::Intervalo) = Intervalo(x) - A #Caso x - [a,b]
	-(A::Intervalo) = 0 - A #Caso x + [a,b]
end

# ╔═╡ 668c3149-60ba-4d49-87b1-bfc376e30b42
#Multiplicación de intervalos x

begin
	import Base. :*
	*(A::Intervalo, B::Intervalo)=Intervalo(min(A.infimo*B.infimo,A.supremo*B.infimo,A.infimo*B.supremo,A.supremo*B.supremo),max(A.infimo*B.infimo,A.supremo*B.infimo,A.infimo*B.supremo,A.supremo*B.supremo))
	*(A::Intervalo, x::Real) = Intervalo(x*A.infimo,x*A.supremo) #Caso c*[a,b]
	*(x::Real, A::Intervalo) = Intervalo(x*A.infimo,x*A.supremo) #Caso [a,b]*c
end

# ╔═╡ 337f69eb-51a1-42de-afb7-9e0b2dead2fa
#División de intervalos -

begin
	import Base. :/
	/(A::Intervalo, B::Intervalo)=A*Intervalo(1/B.supremo,1/B.infimo)
	/(x::Real, B::Intervalo)=x*Intervalo(1/B.supremo,1/B.infimo)
end


# ╔═╡ ab59f640-7825-4482-b947-0e9537a5189f
#Función inverso inv(a)
begin
	function inv(A::Intervalo)
		I = 1*Intervalo(1/A.supremo,1/A.infimo)
	return I
end
end 

# ╔═╡ Cell order:
# ╠═2f4f8fe0-43f3-11ec-0ab9-873924050de7
# ╠═d091ba0b-b93d-4c97-9a92-a0be5ff52fda
# ╠═feaf749b-6c4b-4059-a767-95d16774e9e9
# ╠═1504550f-aabf-4470-8fff-399be3618658
# ╠═6bd6f710-2ddd-4514-8fbf-9dc49b3bee58
# ╠═255eae6c-d39d-4801-a721-8c8469ddb247
# ╠═75ccfd4f-f2fd-427c-acaf-ef655b7a91e0
# ╠═65be1970-66d8-4084-9c3c-2382c5f9687a
# ╠═898d8b66-05a7-46a8-8024-e55687d06bc6
# ╠═fbd3988c-898b-4cc0-8be9-a4d39d78e2bb
# ╠═09829aa1-1acc-408d-9666-842bead1700d
# ╠═85797823-9093-473f-870c-bd4685ada3b5
# ╠═668c3149-60ba-4d49-87b1-bfc376e30b42
# ╠═337f69eb-51a1-42de-afb7-9e0b2dead2fa
# ╠═ab59f640-7825-4482-b947-0e9537a5189f
