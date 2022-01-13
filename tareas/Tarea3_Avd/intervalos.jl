### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ 6a13438f-43df-42ac-861f-e3522b35b9a1
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

# ╔═╡ d5778f58-7fd7-4763-b10a-1ab0df5e9b2f
begin ### Empty interval
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
end

# ╔═╡ 707aaa8a-df8d-424a-8555-1e63eadd45a7
begin   ### Checking if an interval I is the empty interval
	import Base: isempty
	function isempty(I::Intervalo)
		return isnan(I.infimo)
	end
end

# ╔═╡ d5dd2e80-03a2-41f3-9919-6f88bf385887
begin   ### [a,b] == [c,d] ⇒ a = b && b = d
	import Base: ==
	function ==(I1::Intervalo, I2::Intervalo)
		if isempty(I1) && isempty(I2)   ### Empty interval cases
			return true
		else
			inf1, inf2, sup1, sup2 = promote(I1.infimo, I2.infimo, I1.supremo, I2.supremo)
			return (inf1 == inf2) && (sup1 == sup2)
		end
	end
end

# ╔═╡ 21ee3561-710b-4f31-9cbe-dd4d6539f627
begin   ### [a,b] ⊆ [c,d] ⇒ c ≤ a && b ≤ d
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
end

# ╔═╡ 829eb20a-b46a-4f54-a20c-8831802e2fa1
begin   ### [a,b] ⊂ [c,d] ⇒ c ≤ a && b ≤ d   so that   (c = a && b = d) == false
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
	end
end   ### Note: There were no methods for this symbols

# ╔═╡ e94fbbe6-c740-4fa8-8c44-5d009a1d6c34
begin   ### [a,b] ⪽ [c,d] ⇒ c < a && b < d
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
end

# ╔═╡ b03dc9d7-eca2-4ac3-ae5f-20d3a18d2db8
begin   ### x ∈ [a,b] ⇒ a ≤ x ≤ b
	import Base: ∈
	function ∈(x::Real, I::Intervalo)
		return (I.infimo ≤ x) && (x ≤ I.supremo)
	end
end

# ╔═╡ 313975d8-9c31-4217-a284-e4ffbd29563a
begin   ### [a,b] ⊔ [c,d] = [min(a,c), max(b,d)]
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
	const ⊔ = hull
end   ### Note: There were no methods for this symbol

# ╔═╡ a1963843-e33b-4d64-8a81-12015f5c6551
begin   ### [a,b] ∩ [c,d] ⇒ [max(a,c), min(b,d)]
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
end

# ╔═╡ 4cf8364c-2b9f-47f0-ace5-8c44a4cf2677
begin   ### [a,b] ∪ [c,d] ⇒ [min(a,c), max(b,d)]
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
	end
end   ### Note: Doesn't work with disjoint sets

# ╔═╡ eda9c77d-e724-4633-a4db-4ca3f305c3c7
begin   ### [a,b] + [c,d] = [a+c, b+d]   Rounded
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
end

# ╔═╡ 52c665ab-42ac-441e-939e-518e1fd32431
begin   ### [a,b] - [c,d] = [a-d, b-c]   Rounded
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
end

# ╔═╡ 45297b5b-5d4d-43bc-8a80-c8f03aa8b905
begin   ### [a,b]*[c,d] = [min(a*c,a*d,b*c,b*d), max(a*c,a*d,b*c,b*d)]   Rounded
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
end

# ╔═╡ a18c8e6a-f815-488c-b155-ba8f1f6c5e1c
begin   ### [a,b]/[c,d] = [min(a*1/d, a*1/c, b*1/d, b*1/c), max(a*1/d, a*1(c, b*1/d, b*1/c)]   Rounded
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
end

# ╔═╡ 81728a49-6e73-4a13-8ddc-1e34f902df39
begin   ### [a,b]^n = x^n for all x ∈ [a,b]   Rounded
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
end

# ╔═╡ e05b819a-0881-4c84-a997-6ddf20bf2425
begin
	import Base: inv
	function inv(I::Intervalo)
		return 1/I
	end
end

# ╔═╡ e90c7275-d490-4c46-ab7c-5f7ee930c296
begin   ### Rounded
	function division_extendida(I1::Intervalo, I2::Intervalo)
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
end

# ╔═╡ d317ce68-c353-46f1-9696-9489fd42b66f
begin   ### Neccesary for the use of ForwardDiff, .derivative() in particular.
	import Base: one
	function one(I::Intervalo)
		return Intervalo(1.0)
	end
end

# ╔═╡ 448b4e4f-c412-4722-beaa-7053ba14bf41
begin   ### Neccesary for some tests, not sure exactly which ones
	import Base: zero
	function zero(I::Intervalo)
		return Intervalo(0.0)
	end
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[deps]
"""

# ╔═╡ Cell order:
# ╠═6a13438f-43df-42ac-861f-e3522b35b9a1
# ╠═d5778f58-7fd7-4763-b10a-1ab0df5e9b2f
# ╠═707aaa8a-df8d-424a-8555-1e63eadd45a7
# ╠═d5dd2e80-03a2-41f3-9919-6f88bf385887
# ╠═21ee3561-710b-4f31-9cbe-dd4d6539f627
# ╠═829eb20a-b46a-4f54-a20c-8831802e2fa1
# ╠═e94fbbe6-c740-4fa8-8c44-5d009a1d6c34
# ╠═b03dc9d7-eca2-4ac3-ae5f-20d3a18d2db8
# ╠═313975d8-9c31-4217-a284-e4ffbd29563a
# ╠═a1963843-e33b-4d64-8a81-12015f5c6551
# ╠═4cf8364c-2b9f-47f0-ace5-8c44a4cf2677
# ╠═eda9c77d-e724-4633-a4db-4ca3f305c3c7
# ╠═52c665ab-42ac-441e-939e-518e1fd32431
# ╠═45297b5b-5d4d-43bc-8a80-c8f03aa8b905
# ╠═a18c8e6a-f815-488c-b155-ba8f1f6c5e1c
# ╠═81728a49-6e73-4a13-8ddc-1e34f902df39
# ╠═e05b819a-0881-4c84-a997-6ddf20bf2425
# ╠═e90c7275-d490-4c46-ab7c-5f7ee930c296
# ╠═d317ce68-c353-46f1-9696-9489fd42b66f
# ╠═448b4e4f-c412-4722-beaa-7053ba14bf41
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
