### A Pluto.jl notebook ###
# v0.17.1

module Intervalos

export Intervalo;   export intervalo_vacio;   export isinterior;   export ⪽;   export hull;   export ⊔;   export inv

# ╔═╡ e10c21a0-3c58-11ec-0af3-41dfd66e5d26
struct Intervalo{T<:Real}
	
	infimo::T;   supremo::T
	
# To promote every subtype of Real to AbstractFloat, and then promote them to the one with more hierarchy
	function Intervalo(infimo::T1, supremo::T2) where {T1<:Real, T2<:Real}
		if T1<:Integer && T2<:Integer
			return new{Float64}(infimo, supremo)
		elseif T1<:Rational && T2<:Rational
			return new{Float64}(infimo, supremo)
		elseif T1<:Integer && T2<:AbstractFloat
			infi = Float64(infimo)
			inf, sup = promote(infi, supremo)
			return Intervalo(inf, sup)
		elseif T1<:AbstractFloat && T2<:Integer
			supre = Float64(supremo)
			inf, sup = promote(infimo, supre)
			return Intervalo(inf, sup)
		elseif T1<:AbstractFloat && T2<:AbstractFloat
			inf, sup = promote(infimo, supremo)
			return Intervalo(inf, sup)
		end
	end

# To check that the interval satisfy the condition a ≤ b for Intervalo(a,b) ≡ [a,b]
	function Intervalo(infimo::T, supremo::T) where {T<:AbstractFloat}
		@assert infimo ≤ supremo
		return new{T}(infimo, supremo)
	end

# To allow that [a] ≡ Intervalo(a, a) ≡ [a, a] also work
	function Intervalo(same::T) where {T<:Real}
		if T<:Integer
			return new{Float64}(same, same)
		elseif T<:Rational
			return new{Float64}(same, same)
		elseif T<:AbstractFloat
			return new{T}(same, same)
		end
	end
end

# ╔═╡ ad3ab7ec-de0f-4a25-8acd-611e3db4eb12
begin   ### [a,b] == [c,d] ⇒ a = b && b = d
	import Base: ==
	function ==(I1::Intervalo, I2::Intervalo)
		if typeof(I1) == typeof(I2)
			if (I1.infimo == I2.infimo) && (I1.supremo == I2.supremo)
				return true
			else
				return false
			end
		elseif typeof(I1) != typeof(I2)
			inf1, inf2 = promote(I1.infimo, I2.infimo)
			sup1, sup2 = promote(I1.supremo, I2.supremo)
			if (inf1 == inf2) && (sup1 == sup2)
				return true
			else
				return false
			end
		end
	end
end

# ╔═╡ b03dc9d7-eca2-4ac3-ae5f-20d3a18d2db8
begin   ### x ∈ [a,b] ⇒ a ≤ x ≤ b
	import Base: ∈
	function ∈(x::Real, I::Intervalo)
		if I.infimo ≤ x && x ≤ I.supremo
			true
		else
			false
		end
	end
end

# ╔═╡ eda9c77d-e724-4633-a4db-4ca3f305c3c7
begin   ### [a,b] + [c,d] = [a+c, b+d]
	import Base: +
	function +(I1::Intervalo, I2::Intervalo)
		return Intervalo(I1.infimo+I2.infimo, I1.supremo+I2.supremo)
	end
	function +(I::Intervalo, r::Real)   ### [a,b] + x = [a+x, b+x]
		return Intervalo(I.infimo+r, I.supremo+r)
	end
	function +(r::Real, I::Intervalo)   ### x + [a,b] = [x+a, x+a]
		return Intervalo(r+I.infimo, r+I.supremo)
	end
	function +(I::Intervalo)   ### +[a,b] = [+a,+b]
		return Intervalo(+(I.infimo), +(I.supremo))
	end
end

# ╔═╡ 52c665ab-42ac-441e-939e-518e1fd32431
begin   ### [a,b] - [c,d] = [a-d, b-c]
	import Base: -
	function -(I1::Intervalo, I2::Intervalo)
		return Intervalo(I1.infimo-I2.supremo, I1.supremo-I2.infimo)
	end
	function -(I::Intervalo, r::Real)   ### [a,b] - x = [a-x, b-x]
		return Intervalo(I.infimo-r, I.supremo-r)
	end
	function -(I::Intervalo)   ### -[a,b] = [-a,-b]
		return Intervalo(-(I.infimo), -(I.supremo))
	end
end

# ╔═╡ aef78ea7-00db-4f69-a67a-3090b1f72e26
begin   ### Benet's empty interval definition. At the end, I think it works better
	function intervalo_vacio(arg)
		if arg == Float64
			return Intervalo(-Inf, Inf)
		elseif arg == BigFloat
			return Intervalo(big(-Inf), big(Inf))
		else
			return Intervalo(-Inf, Inf)
		end
	end
	function intervalo_vacio()
		return Intervalo(-Inf, Inf)
	end
end   ### I think I can make it a little bit better

# ╔═╡ 21ee3561-710b-4f31-9cbe-dd4d6539f627
begin   ### [a,b] ⊆ [c,d] ⇒ c ≤ a && b ≤ d
	import Base: ⊆
	function ⊆(I1::Intervalo, I2::Intervalo)
		if (I1.infimo == -Inf) && (I1.supremo == Inf)   ### Empty I case
			return true
		elseif I2.infimo ≤ I1.infimo && I1.supremo ≤ I2.supremo
			true
		else
			false
		end
	end
end

# ╔═╡ e94fbbe6-c740-4fa8-8c44-5d009a1d6c34
begin   ### [a,b] ⪽ [c,d] ⇒ c < a && b < d
	function isinterior(I1::Intervalo, I2::Intervalo)
		if (I1.infimo == -Inf) && (I1.supremo == Inf)   ### Empty I case
			true
		elseif I2.infimo < I1.infimo && I1.supremo < I2.supremo
			true
		else
			false
		end
	end
end

# ╔═╡ 4a501677-af00-43a7-9abd-8fba8c1774ec
begin
	import Base: ⪽
	const ⪽ = isinterior
end

# ╔═╡ 313975d8-9c31-4217-a284-e4ffbd29563a
begin   ### [a,b] ⊔ [c,d] = [min(a,c), max(b,d)]
	function hull(I1::Intervalo, I2::Intervalo)
		if (I1.infimo == -Inf) && (I1.supremo == Inf)   ### Empty interval cases
			return I2
		elseif (I2.infimo == -Inf) && (I2.supremo == Inf)
			return I1
		elseif (I1.infimo == I2.infimo == -Inf) && (I1.supremo == I2.supremo == Inf)
			return I1
		else
			m = min(I1.infimo, I2.infimo)
			s = max(I1.supremo, I2.supremo)
			return Intervalo(m, s)
		end
	end
end   ### Note: There were no methods for this symbol

# ╔═╡ d2bad49b-212c-4c12-bffa-3f1c3c63f4d6
begin
	import Base: ⊔
	const ⊔ = hull
end

# ╔═╡ a1963843-e33b-4d64-8a81-12015f5c6551
begin   ### [a,b] ∩ [c,d] ⇒ [max(a,c), min(b,d)]
	import Base: ∩
	function ∩(I1::Intervalo, I2::Intervalo)
		if I1.infimo < I2.infimo && I1.supremo < I2.infimo   ### Disjoint intervals
			return intervalo_vacio(0)
		elseif I2.infimo < I1.infimo && I2.supremo < I1.infimo
			return intervalo_vacio(0)
		elseif (I1.infimo == -Inf) && (I1.supremo == Inf)   ### Empty interval cases
			return intervalo_vacio(0)
		elseif (I2.infimo == -Inf) && (I2.supremo == Inf)
			return intervalo_vacio(0)
		elseif (I1.infimo == I2.infimo == -Inf) && (I1.supremo == I2.supremo == Inf)
			return intervalo_vacio(0)
		else   ### The rest of the cases
			return Intervalo(max(I1.infimo,I2.infimo), min(I1.supremo,I2.supremo))
		end
	end
end

# ╔═╡ 4cf8364c-2b9f-47f0-ace5-8c44a4cf2677
begin   ### [a,b] ∪ [c,d] ⇒ [min(a,c), max(b,d)]
	import Base: ∪
	function ∪(I1::Intervalo, I2::Intervalo)
		if (I1.infimo == -Inf) && (I1.supremo == Inf)   ### Empty interval cases
			return I2
		elseif (I2.infimo == -Inf) && (I2.supremo == Inf)
			return I1
		elseif (I1.infimo == I2.infimo == -Inf) && (I1.supremo == I2.supremo == Inf)
			return I1
		elseif I1.infimo ≤ I2.infimo && I2.infimo ≤ I1.supremo   ### Normal cases
			return Intervalo(I1.infimo, max(I2.supremo, I1.supremo))
		elseif I2.infimo ≤ I1.infimo && I1.infimo ≤ I2.supremo
			return Intervalo(I2.infimo, max(I1.supremo, I2.supremo))
		end
	end
end   ### Note: Doesn't work with disjoint sets

# ╔═╡ 45297b5b-5d4d-43bc-8a80-c8f03aa8b905
begin   ### [a,b]*[c,d] = [min(a*c,a*d,b*c,b*d), max(a*c,a*d,b*c,b*d)]
	import Base: *
	function *(I1::Intervalo, I2::Intervalo)
		if (I1.infimo == -Inf) && (I1.supremo == Inf)   ### Empty intervals cases
			return I1
		elseif (I2.infimo == -Inf) && (I2.supremo == Inf)
			return I2
		else   ### rest cases
			p1 = I1.infimo*I2.infimo
			p2 = I1.infimo*I2.supremo
			p3 = I1.supremo*I2.infimo
			p4 = I1.supremo*I2.supremo
			return Intervalo(min(p1, p2, p3, p4), max(p1, p2, p3, p4))
		end
	end
	function *(r::Real, I::Intervalo)   ### x*[a,b] = [x*a, x*b]
		@assert 0 ≤ r
		if (I.infimo == -Inf) && (I.supremo == Inf)
			return I
		else
			return Intervalo(r*I.infimo, r*I.supremo)
		end
	end
	function *(I::Intervalo, r::Real)   ### [a,b]*x = [a*x, b*x]
		@assert 0 ≤ r
		if (I.infimo == -Inf) && (I.supremo == Inf)
			return I
		else
			return Intervalo(I.infimo*r, I.supremo*r)
		end
	end
end

# ╔═╡ a18c8e6a-f815-488c-b155-ba8f1f6c5e1c
begin   ### [a,b]/[c,d] = [min(a/d, a/c, b/d, b/c), max(a/d, a/c, b/d, b/c)]
	import Base: /
	function /(I1::Intervalo, I2::Intervalo)
		if 0 ∈ I2
			return Intervalo(-Inf, Inf)
		else
			I3 = Intervalo(1/I2.supremo, 1/I2.infimo)
			p1 = I1.infimo*I3.infimo
			p2 = I1.infimo*I3.supremo
			p3 = I1.supremo*I3.infimo
			p4 = I1.supremo*I3.supremo
			return Intervalo(min(p1, p2, p3, p4), max(p1, p2, p3, p4))
		end
	end
	function /(r::Real, I2::Intervalo)   ### x/[a,b] = [x/b, x/a]
		@assert 0 ≤ r
		return Intervalo(r/I2.supremo, r/I2.infimo)
	end
end

# ╔═╡ 81728a49-6e73-4a13-8ddc-1e34f902df39
begin   ### [a,b]^n = x^n for all x ∈ [a,b]
	import Base: ^
	function ^(I::Intervalo, n::Int64)
		if (I.infimo == -Inf) && (I.supremo == Inf)   ### Empty interval case
			return I
		elseif 0 < I.infimo   ### [a,b] such that 0 < a case
			return Intervalo(I.infimo^n, I.supremo^n)
		elseif I.supremo < 0   ### [a,b] such that b < 0 case
			p_inf = I.infimo^n;   p_sup = I.supremo^n
			if p_inf ≤ p_sup
				return Intervalo(p_inf, p_sup)
			else
				return Intervalo(p_sup, p_inf)
			end
		elseif 0 ∈ I   ### 0 ∈ [a,b] case
			p_inf = I.infimo^n;   p_sup = I.supremo^n
			if n%2 == 0   ### even power case
				return Intervalo(0, p_sup)
			else   ### odd power case
				return Intervalo(p_inf, p_sup)
			end
		end
	end
end

# ╔═╡ e05b819a-0881-4c84-a997-6ddf20bf2425
begin
	import Base: inv
	function inv(I::Intervalo)
		1/I
	end
end

# ╔═╡ Cell order:
# ╠═e10c21a0-3c58-11ec-0af3-41dfd66e5d26
# ╠═a5ae2693-3721-46d3-9eb8-cd8991257327
# ╠═aef78ea7-00db-4f69-a67a-3090b1f72e26
# ╠═ad3ab7ec-de0f-4a25-8acd-611e3db4eb12
# ╠═21ee3561-710b-4f31-9cbe-dd4d6539f627
# ╠═829eb20a-b46a-4f54-a20c-8831802e2fa1
# ╠═e94fbbe6-c740-4fa8-8c44-5d009a1d6c34
# ╠═4a501677-af00-43a7-9abd-8fba8c1774ec
# ╠═b03dc9d7-eca2-4ac3-ae5f-20d3a18d2db8
# ╠═313975d8-9c31-4217-a284-e4ffbd29563a
# ╠═d2bad49b-212c-4c12-bffa-3f1c3c63f4d6
# ╠═a1963843-e33b-4d64-8a81-12015f5c6551
# ╠═4cf8364c-2b9f-47f0-ace5-8c44a4cf2677
# ╠═eda9c77d-e724-4633-a4db-4ca3f305c3c7
# ╠═52c665ab-42ac-441e-939e-518e1fd32431
# ╠═45297b5b-5d4d-43bc-8a80-c8f03aa8b905
# ╠═a18c8e6a-f815-488c-b155-ba8f1f6c5e1c
# ╠═81728a49-6e73-4a13-8ddc-1e34f902df39
# ╠═e05b819a-0881-4c84-a997-6ddf20bf2425

end