module Intervalos

export Intervalo, intervalo_vacio, isinterior, ⪽, hull, ⊔, division_extendida

struct Intervalo{T<:Real} <: Real
	
	infimo::T;   supremo::T
	
# To promote every subtype of Real to AbstractFloat, and then promote them to the one with more hierarchy, like Float64 or BigFloat
	function Intervalo(infimo::T1, supremo::T2) where {T1<:Real, T2<:Real}
		inf, sup, _ = promote(infimo, supremo, 1.0)
		return Intervalo(inf, sup)
	end

# To check that the interval satisfy the condition a ≤ b for Intervalo(a,b) ≡ [a,b]	
	function Intervalo(infimo::T, supremo::T) where {T<:AbstractFloat}
		if isnan(infimo) || isnan(supremo)
			return new{T}(NaN, NaN)
		else
			@assert infimo ≤ supremo
			return new{T}(infimo, supremo)
		end
	end

# To allow that Intervalo(a) ≡ [a] → [a, a] also work
	function Intervalo(same::T) where {T<:Real}
		return Intervalo(same, same)
	end
end

### Empty interval
function intervalo_vacio()   ### Without argument
	return Intervalo(NaN)
end
function intervalo_vacio(arg::T) where {T<:Real}   ### A type Real 'number' arg
	T₀ = promote_type(T, Float64)
	return Intervalo(T₀(NaN), T₀(NaN))
end
function intervalo_vacio(T::Type{<:Real})   ### A 'type' arg
	T₀ = promote_type(T, Float64)
	return Intervalo(T₀(NaN), T₀(NaN))
end
function intervalo_vacio(I::Intervalo{T}) where {T<:Real}   ### An 'Interval' arg
	return Intervalo(T(NaN), T(NaN))
end

### Checking if an interval I is the empty interval
import Base: isempty
function isempty(I::Intervalo)
	return isnan(I.infimo)
end

### [a,b] == [c,d] ⇒ a = b && b = d
import Base: ==
function ==(I1::Intervalo, I2::Intervalo)
	if isempty(I1) && isempty(I2)   ### Empty interval cases
		return true
	else
		inf1, inf2, sup1, sup2 = promote(I1.infimo, I2.infimo, I1.supremo, I2.supremo)
		return (inf1 == inf2) && (sup1 == sup2)
	end
end

### [a,b] ⊆ [c,d] ⇒ c ≤ a && b ≤ d
import Base: ⊆
function ⊆(I1::Intervalo, I2::Intervalo)
	if isempty(I1)   ### Empty I case
		return true
	elseif (I2.infimo ≤ I1.infimo) && (I1.supremo ≤ I2.supremo)
		return true
	else
		return false
	end
end

### [a,b] ⊂ [c,d] ⇒ c ≤ a && b ≤ d   so that   (c = a && b = d) == false
function ⊂(I1::Intervalo, I2::Intervalo)
	if isempty(I1)   ### Empty I case
		return true
	elseif (I2.infimo ≤ I1.infimo) && (I1.supremo ≤ I2.supremo)
		if (I2.infimo == I1.infimo) && (I1.supremo == I2.supremo)
			return false
		else
			return true
		end
	else
		return false
	end
end
function ⊃(I1::Intervalo, I2::Intervalo)
	if isempty(I2)   ### Empty I case
		return true
	elseif (I1.infimo ≤ I2.infimo) && (I2.supremo ≤ I1.supremo)
		if (I1.infimo == I2.infimo) && (I2.supremo == I1.supremo)
			return false
		else
			return true
		end
	else
		return false
	end
end   ### Note: There were no methods for this symbols

### [a,b] ⪽ [c,d] ⇒ c < a && b < d
function isinterior(I1::Intervalo, I2::Intervalo)
	if isempty(I1)   ### Empty I case
		return true
	elseif (I2.infimo < I1.infimo) && (I1.supremo < I2.supremo)
		return true
	else
		return false
	end
end
const ⪽ = isinterior

### x ∈ [a,b] ⇒ a ≤ x ≤ b
import Base: ∈
function ∈(x::Real, I::Intervalo)
	return (I.infimo ≤ x) && (x ≤ I.supremo)
end

### [a,b] ⊔ [c,d] = [min(a,c), max(b,d)]
function hull(I1::Intervalo, I2::Intervalo)
	if isempty(I1)   ### Empty interval cases
		return I2
	elseif isempty(I2)
		return I1
	elseif isempty(I1) && isempty(I2)
		return I1
	else
		m = min(I1.infimo, I2.infimo)
		s = max(I1.supremo, I2.supremo)
		return Intervalo(m, s)
	end
end
const ⊔ = hull   ### Note: There were no methods for this symbol

### [a,b] ∩ [c,d] ⇒ [max(a,c), min(b,d)]
import Base: ∩
function ∩(I1::Intervalo, I2::Intervalo)
	if I1.infimo < I2.infimo && I1.supremo < I2.infimo   ### Disjoint intervals
		return intervalo_vacio()
	elseif I2.infimo < I1.infimo && I2.supremo < I1.infimo
		return intervalo_vacio()
	elseif isempty(I1)   ### Empty interval cases
		return intervalo_vacio()
	elseif isempty(I2)
		return intervalo_vacio()
	elseif isempty(I1) && isempty(I2)
		return intervalo_vacio()
	else   ### The rest of the cases
		return Intervalo(max(I1.infimo,I2.infimo), min(I1.supremo,I2.supremo))
	end
end

### [a,b] ∪ [c,d] ⇒ [min(a,c), max(b,d)]
import Base: ∪
function ∪(I1::Intervalo, I2::Intervalo)
	if isempty(I1)   ### Empty interval cases
		return I2
	elseif isempty(I2)
		return I1
	elseif isempty(I1) && isempty(I2)
		return I1
	elseif I1.infimo ≤ I2.infimo && I2.infimo ≤ I1.supremo   ### Normal cases
		return Intervalo(I1.infimo, max(I2.supremo, I1.supremo))
	elseif I2.infimo ≤ I1.infimo && I1.infimo ≤ I2.supremo
		return Intervalo(I2.infimo, max(I1.supremo, I2.supremo))
	end
end   ### Note: Doesn't work with disjoint sets

### [a,b] + [c,d] = [a+c, b+d]   Rounded
import Base: +
function +(I1::Intervalo, I2::Intervalo)
	return Intervalo(prevfloat(I1.infimo+I2.infimo), nextfloat(I1.supremo+I2.supremo))
end
function +(I::Intervalo, r::Real)   ### [a,b] + x = [a+x, b+x]
	return Intervalo(prevfloat(I.infimo+r), nextfloat(I.supremo+r))
end
function +(r::Real, I::Intervalo)   ### x + [a,b] = [x+a, x+a]
	return Intervalo(prevfloat(r+I.infimo), nextfloat(r+I.supremo))
end
function +(I::Intervalo)   ### +[a,b] = [+a,+b]
	return Intervalo(+(I.infimo), +(I.supremo))
end

### [a,b] - [c,d] = [a-d, b-c]   Rounded
import Base: -
function -(I1::Intervalo, I2::Intervalo)
	return Intervalo(prevfloat(I1.infimo-I2.supremo), nextfloat(I1.supremo-I2.infimo))
end
function -(I::Intervalo, r::Real)   ### [a,b] - x = [a-x, b-x]
	return Intervalo(prevfloat(I.infimo-r), nextfloat(I.supremo-r))
end
function -(r::Real, I::Intervalo)   ### x - [a,b]= [x-b, x-a] ???
	return Intervalo(prevfloat(r-I.supremo), nextfloat(r-I.infimo))
end
function -(I::Intervalo)   ### -[a,b] = [-b,-a]
	return Intervalo(-(I.supremo), -(I.infimo))
end

### [a,b]*[c,d] = [min(a*c,a*d,b*c,b*d), max(a*c,a*d,b*c,b*d)]   Rounded
import Base: *
function *(I1::Intervalo, I2::Intervalo)
	if isempty(I1)   ### Empty intervals cases
		return I1
	elseif isempty(I2)
		return I2
	elseif I1 == Intervalo(-Inf, Inf) && I2 == Intervalo(0.0)
		return I2
	else   ### rest cases
		p1 = I1.infimo*I2.infimo
		p2 = I1.infimo*I2.supremo
		p3 = I1.supremo*I2.infimo
		p4 = I1.supremo*I2.supremo
		return Intervalo(prevfloat(min(p1, p2, p3, p4)), nextfloat(max(p1, p2, p3, p4)))
	end
end
function *(r::Real, I::Intervalo)   ### x*[a,b] = [x*a, x*b]
	if isempty(I)   ### Empty interval case
		return I
	else
		if 0 ≤ r
			return Intervalo(prevfloat(r*I.infimo), nextfloat(r*I.supremo))
		else
			return Intervalo(prevfloat(r*I.supremo), nextfloat(r*I.infimo))
		end
	end
end
function *(I::Intervalo, r::Real)   ### [a,b]*x = [a*x, b*x]
	if isempty(I)   ### Empty interval case
		return I
	else
		if 0 ≤ r
			return Intervalo(prevfloat(I.infimo*r), nextfloat(I.supremo*r))
		else
			return Intervalo(prevfloat(I.supremo*r), nextfloat(I.infimo*r))
		end
	end
end

### [a,b]/[c,d] = [min(a*1/d, a*1/c, b*1/d, b*1/c), max(a*1/d, a*1(c, b*1/d, b*1/c)]   Rounded
import Base: /
function /(I1::Intervalo, I2::Intervalo)
	if 0.0 ∈ I2
		if I2 == Intervalo(0.0)   ### [a,b]/[0,0]
			return intervalo_vacio()
		elseif I2.infimo < 0.0 < I2.supremo   ### [a,b]/[c,d] so that c < 0.0 < d
			return Intervalo(-Inf, Inf)
		elseif I2.infimo == 0.0 < I2.supremo   ### [a,b]/[0,d]
			I3 = Intervalo(1/I2.supremo, Inf)
			p1 = I1.infimo*I3.infimo;   p3 = I1.supremo*I3.infimo
			return Intervalo(prevfloat(min(p1, p3)), Inf)
		elseif I2.infimo < 0.0 == I2.supremo   ### [a,b]/[c,0]
			I3 = Intervalo(-Inf, 1/I2.infimo)
			p2 = I1.infimo*I3.supremo;   p4 = I1.supremo*I3.supremo
			return Intervalo(-Inf, nextfloat(max(p2, p4)))
		end
	elseif isempty(I2)   ### [a,b]/[]
		return intervalo_vacio()
	else   ### [a,b]/[c,d]
		I3 = Intervalo(1/I2.supremo, 1/I2.infimo)
		p1 = I1.infimo*I3.infimo;   p2 = I1.infimo*I3.supremo
		p3 = I1.supremo*I3.infimo;   p4 = I1.supremo*I3.supremo
		return Intervalo(prevfloat(min(p1, p2, p3, p4)), nextfloat(max(p1, p2, p3, p4)))
	end
end
function /(r::Real, I::Intervalo)
	if I == Intervalo(0.0)
		return intervalo_vacio()
	elseif 0 ≤ r   ### x/[a,b] = [x/b, x/a] for r ≥ 0
		return Intervalo(prevfloat(r/I.supremo), nextfloat(r/I.infimo))
	else   ### x/[a,b] = [x/a, x/b] for r < 0
		return Intervalo(prevfloat(r/I.infimo), nextfloat(r/I.supremo))
	end
end

### [a,b]^n = x^n for all x ∈ [a,b]   Rounded
import Base: ^
function ^(I::Intervalo, n::Int64)
	if isempty(I)   ### Empty interval case
		return I
	elseif n == 1   ### Like do not operate? (an exception?)
		return I
	elseif n < 0.0   ### Directing first to division?
		return 1/(I^n)
	elseif 0.0 < I.infimo   ### [a,b] such that 0 < a case
		return Intervalo(prevfloat(I.infimo^n), nextfloat(I.supremo^n))
	elseif I.supremo < 0.0   ### [a,b] such that b < 0 case
		p_inf = I.infimo^n;   p_sup = I.supremo^n
		if p_inf ≤ p_sup
			return Intervalo(prevfloat(p_inf), nextfloat(p_sup))
		else
			return Intervalo(prevfloat(p_sup), nextfloat(p_inf))
		end
	elseif 0.0 ∈ I   ### 0 ∈ [a,b] case
		p_inf = I.infimo^n;   p_sup = I.supremo^n
		if n%2 == 0   ### even power case
			return Intervalo(0.0, nextfloat(p_sup))
		else   ### odd power case
			return Intervalo(prevfloat(p_inf), nextfloat(p_sup))
		end
	end
end

import Base: inv
function inv(I::Intervalo)
	return 1/I
end

function division_extendida(I1::Intervalo, I2::Intervalo)   ### Rounded
	if 0.0 ∉ I2
		return (I1/I2,)
	elseif (0.0 ∈ I1) && (0.0 ∈ I2)
		return (Intervalo(-Inf, Inf),)
	elseif (I1.supremo < 0.0) && (I2.infimo < I2.supremo == 0.0)
		return (Intervalo(prevfloat(I1.supremo/I2.infimo), Inf),)
	elseif (I1.supremo < 0.0) && (I2.infimo < 0.0 < I2.supremo)
		return (Intervalo(-Inf, nextfloat(I1.supremo/I2.supremo)), Intervalo(prevfloat(I1.supremo/I2.infimo), Inf),)
	elseif (I1.supremo < 0.0) && (0.0 == I2.infimo < I2.supremo)
		return (Intervalo(-Inf, nextfloat(I1.supremo/I2.supremo)),)
	elseif (0.0 < I1.infimo) && (I2.infimo < I2.supremo == 0.0)
		return (Intervalo(-Inf, nextfloat(I1.infimo/I2.infimo)),)
	elseif (0.0 < I1.infimo) && (I2.infimo < 0.0 < I2.supremo)
		return (Intervalo(-Inf, nextfloat(I1.infimo/I2.infimo)), Intervalo(prevfloat(I1.infimo/I2.supremo), Inf),)
	elseif (0.0 < I1.infimo) && (0.0 == I2.infimo < I2.supremo)
		return (Intervalo(prevfloat(I1.infimo/I2.supremo), Inf),)
	elseif (0.0 ∉ I1) && (I2 == Intervalo(0.0))
		return (intervalo_vacio(),)
	end
end

import Base: one   ### Neccesary for the use of ForwardDiff, .derivative() in particular
function one(I::Intervalo)
	return Intervalo(1.0)
end

import Base: zero   ### Necessary for some tests, not sure exactly which ones
function zero(I::Intervalo)
	return Intervalo(0.0)
end

include("raices.jl")

include("optimizacion.jl")

end