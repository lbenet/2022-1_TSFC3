### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ 14c2fd39-bfd3-4d1b-a453-817a80077a4b
begin
	using PlutoUI
	using Gaston
end

# ╔═╡ 1db04a08-4ae6-4b12-b057-dfcac26a2924
PlutoUI.TableOfContents(aside=true)

# ╔═╡ 41ecfebc-0820-11ec-1e5f-a77ecab1f5d4
md"# Ejemplos"

# ╔═╡ faad2468-31a4-49f0-8513-80125a3f526d
md"## El orden de las operaciones"

# ╔═╡ 351f0204-4144-4d8c-bdd9-88165c45efdd
md"""
Consideren los vectores:
```julia
a = [1e20, 2.0, -1e22, 1e13, 2111, 1e16]
b = [1e20, 1223, 1e18, 1e15, 3, -1e12]
```
La pregunta es cuánto vale el producto punto de estos vectores.
"""

# ╔═╡ 3176f352-ff43-448f-9023-39dc9a0e16f1


# ╔═╡ c7744601-73df-47ff-8aa6-8e73ee68d6b5
md"""
Podemos hacer lo mismo reagrupando las operaciones. En particular, recalculen lo mismo reagrupando primero las cosas, de tal manera que obtienen
```julia
a[1] * b[1] + a[3] * b[3], a[4] * b[4] + a[6] * b[6]
```
y
```julia
a[2] * b[2] + a[5] * b[5]
```
separadamente, y después su suma."""

# ╔═╡ afab0fab-2b25-4cd6-9b62-654aeec8e2f2


# ╔═╡ b81f6636-92f9-4d38-8369-b0a20c334fb6
md"""
## Las magnitudes relativas
"""

# ╔═╡ 5bafea58-4f0e-40f2-b173-37bdd686f2aa
md"""
Consideremos la función $$f(x,y) = 333.75 y^6 + x^2(11x^2y^2-y^6-121y^4-2)+5.5y^8+x/(2y)$$. La pregunta es ¿cuál es el valor (¡correcto!) de $f(x,y)$ en el punto $(77617,33096)$?

Hagan esto definiendo las siguientes funciones:
```julia
f₁(x,y) = 333.75*y^6 + x^2*(11*x^2*y^2-y^6-121*y^4-2)
f₂(x,y) = 5.5*y^8
f(x,y) = f₁(x,y) + f₂(x,y) + x/(2*y)
```
"""

# ╔═╡ 3809d38d-6a57-4594-95c3-08b9595a5790


# ╔═╡ a09fcfb4-7645-4bf1-b4eb-3f35be8bd0fd
md"Procedamos por el camino más sencillo: Evaluemos *directamente* `f(77617, 33096)`"

# ╔═╡ f3d23910-0330-4c33-bd41-4d3488081522


# ╔═╡ 23ab13df-ee6b-4549-b3c7-8d212f15039e
md"Ahora, hagamos el cálculo en precisión extendida:"

# ╔═╡ 0ad25169-b2d0-4dba-9ea8-e4133de523a1


# ╔═╡ f29be56d-08a9-4df7-a22e-c4ba23fe01a5
md"""
La pregunta es ¿cuál es el resultado correcto? Para averiguarlo, procederomos así:

1. Evalúen, de manera separada:
```julia
f₁(77617, 33096)
f₁(big(77617), big(33096))
```
y
```julia
f₂(77617, 33096)
f₂(big(77617), big(33096))
```

2. Evalúen, separadamente:
```
f₁(77617, 33096) + f₂(77617, 33096)
f₁(big(77617), big(33096)) + f₂(big(77617), big(33096))
```

3. De los resultados parciales anteriores obtengan el resultado (correcto) para `f(77617, 33096)`.
"""

# ╔═╡ 301ed648-fe6e-4248-ad8e-b946755fc235


# ╔═╡ 103a739d-bcb4-45ff-8345-c465d52aedbe
md"## La forma de escribir las funciones"

# ╔═╡ 9e785d5a-e460-4ed6-a37f-1874191418c3
md"""
La idea es, a partir de la gráfica del polinomio $p(t)=t^6-6t^5+15t^4-20t^3+15t^2-6t+1$ cerca de 1, estimar el número de ceros del polinomio.
"""

# ╔═╡ e4d308d1-63e6-444f-ad68-5d06af14dc01
md"""
Para graficar usaremos la librería `Gaston.jl` que permite graficar usando `Gnuplot`. Graficaremos $p(t)$ en el intervalo $[0.9951171875, 1.0048828125]$ usando pasos de $1/2^{16}$; la idea de usar estos números es que son exactamente representables en la computadora.

Graficaremos usando el siguiente código
```julia
begin
	p(t) = t^6 - 6t^5 + 15t^4 - 20t^3 + 15t^2 - 6t + 1

	local x = 1-5/2^10:1/2^16:1+5/2^10
	set(termopts="size 600,400")
	plot(x, p.(x),
		curveconf="w l lc 'blue'",
		Axes(title=:off, key=:off))
end
```
"""

# ╔═╡ b8bbc551-cd3a-4251-8851-8743f6596272


# ╔═╡ 4375208b-8ffb-4211-9347-18b369bc2e59
md"""
Grafiquen ahora *el mismo polinomio* escrito ahora como $p(t)=(t-1)^6$.
"""

# ╔═╡ 19f3e069-129a-46f5-8e46-bb0bb538e96e


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Gaston = "4b11ee91-296f-5714-9832-002c20994614"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Gaston = "~1.0.4"
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "9995eb3977fbf67b86d0a0a0508e83017ded03f2"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.14.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Gaston]]
deps = ["ColorSchemes", "DelimitedFiles", "Random"]
git-tree-sha1 = "ef62952980d19c98d00bd44d2266a98f8e9c7178"
uuid = "4b11ee91-296f-5714-9832-002c20994614"
version = "1.0.4"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "438d35d2d95ae2c5e8780b330592b6de8494e779"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.3"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╠═14c2fd39-bfd3-4d1b-a453-817a80077a4b
# ╠═1db04a08-4ae6-4b12-b057-dfcac26a2924
# ╟─41ecfebc-0820-11ec-1e5f-a77ecab1f5d4
# ╠═faad2468-31a4-49f0-8513-80125a3f526d
# ╠═351f0204-4144-4d8c-bdd9-88165c45efdd
# ╠═3176f352-ff43-448f-9023-39dc9a0e16f1
# ╠═c7744601-73df-47ff-8aa6-8e73ee68d6b5
# ╠═afab0fab-2b25-4cd6-9b62-654aeec8e2f2
# ╠═b81f6636-92f9-4d38-8369-b0a20c334fb6
# ╠═5bafea58-4f0e-40f2-b173-37bdd686f2aa
# ╠═3809d38d-6a57-4594-95c3-08b9595a5790
# ╟─a09fcfb4-7645-4bf1-b4eb-3f35be8bd0fd
# ╠═f3d23910-0330-4c33-bd41-4d3488081522
# ╟─23ab13df-ee6b-4549-b3c7-8d212f15039e
# ╠═0ad25169-b2d0-4dba-9ea8-e4133de523a1
# ╠═f29be56d-08a9-4df7-a22e-c4ba23fe01a5
# ╠═301ed648-fe6e-4248-ad8e-b946755fc235
# ╠═103a739d-bcb4-45ff-8345-c465d52aedbe
# ╠═9e785d5a-e460-4ed6-a37f-1874191418c3
# ╠═e4d308d1-63e6-444f-ad68-5d06af14dc01
# ╠═b8bbc551-cd3a-4251-8851-8743f6596272
# ╠═4375208b-8ffb-4211-9347-18b369bc2e59
# ╠═19f3e069-129a-46f5-8e46-bb0bb538e96e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
