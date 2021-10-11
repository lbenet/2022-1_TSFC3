#-
# # Un resultado riguroso con la computadora

using Pkg
Pkg.activate("..")  # Activa el directorio "." respecto al lugar donde estamos
using Gaston

#-
# La idea es obtener el resultado correcto, a 12 posiciones decimales correctas,
# de $S = \sum_{k=1}^\infty k^{-2}$.
#
# (La respuesta exacta, como bien sabemos, es $\pi^2/6$.)
#

#-
# Como no podemos hacer una suma con un número infinito de términos, la estrategia
# será la siguiente: haremos en la computadora) la suma finita hasta $N$, y
# acotaremos (con matemáticas) el resto de la suma:
#
# ```math
# S = S_N+\tilde{S}_N = \sum_{k=1}^N\frac{1}{k^2} + \sum_{k=N+1}^\infty\frac{1}{k^2}.
# ```

#-
# Empezamos primero por acotar la suma $\tilde{S}_N$. Para esto podemos usar que
#
# ```math
# \int_{N+1}^\infty \frac{1}{x^2}\text{d}x < \tilde{S}_N < \int_{N+1}^\infty \frac{1}{(x-1)^2}\text{d}x .
# ```
#
# Esto se puede *ver* de las gráficas de las funciones involucradas.

#-
x = 2:1:100

g(x) = 1 ./ x.^2
plot(x, g(x.-1),
	curveconf = "w filledcu x1 lc '#E69F00' dt 1 t 'g(x)=1/(x-1)^2'",
	Axes(axis = "semilogy",
		style = "fs transparent solid 0.5",
		xlabel = "'x'", ylabel="'g(x)'"
		))
plot!(x, g(x),
	curveconf = "w filledcu x1 lc '#56B4E9' dt 1 t 'g(x)=1/x^2'")

#-
# De aquí obtenemos:
# ```math
# \frac{1}{N+1} < \tilde{S}_N < \frac{1}{N}.
# ```
#
# La *anchura* de esta cota es $\delta_N=\frac{1}{N(N+1)}$. Tomando $N=2\times10^6$
# tenemos $\delta_N<2.5\times10^{-13}$, que es suficiente para lo que queremos.

#-
# Ahora evaluamos $S_N$.

#-
# **NOTA**: En lo que sigue, usaremos `BigFloat`, ya que por el momento Julia
# sólo permite *cambiar* el modo de redondeo para los `BigFloat`. Además,
# cambiaremos la precisión a 53 bits, que es lo que equivale al caso de `Float64`.

#-
#Fijamos la precisión en 53 bits (equivale a Float64)
begin
	oldprecision = precision(BigFloat)
	setprecision(BigFloat,53)
end

#-
kmax = 2_000_000
δN = 1/(kmax * (kmax+1))

#-
#Calculamos, con el modo de redondeo hacia arriba, S_N
sn_up = big(0.0)
oldrounding = rounding(BigFloat)
setrounding(BigFloat, RoundUp)
for k = 1:kmax
	sn_up += big(1)/k^2
end
setrounding(BigFloat, oldrounding)
sn_up

#-
#Calculamos, con el modo de redondeo hacia arriba, S_N
sn_down = big(0.0)
oldrounding = rounding(BigFloat)
setrounding(BigFloat, RoundDown)
for k = 1:kmax
	sn_down += big(1)/k^2
end
setrounding(BigFloat, oldrounding)
sn_down

#-
# La diferencia entre estos resultados, incluyendo la anchura de la cota, es:"

sn_up - sn_down + δN

#-
# El resultado anterior **no** da la precisión que buscábamos ($10^{-12}$). Esto
# se debe a que los primeros sumandos son más grandes que los últimos, y haciendo
# así la suma hay una pérdida de precisión.

#-
# Usando las cotas inferior y la superior de $\tilde{S}_N$, las cotas del
# resultado para $S_N$ que obtenemos son:

sn_down + big(1)/(kmax+1)

#-
sn_up + big(1)/kmax

#-
# Usando la observación anterior de que los primeros sumandos son los más grandes,
# hacemos el mismo cálculo pero haciendo la suma iterando $k$ al revés, de más
# grande a más chico.

#-
sn_up2 = big(0.0)
oldrounding = rounding(BigFloat)
setrounding(BigFloat, RoundUp)
for k = kmax:-1:1
	sn_up2 += big(1)/k^2
end
setrounding(BigFloat, oldrounding)
sn_up2

#-
sn_down2 = big(0.0)
oldrounding = rounding(BigFloat)
setrounding(BigFloat, RoundDown)
for k = kmax:-1:1
	sn_down2 += big(1)/k^2
end
setrounding(BigFloat, oldrounding)
sn_down2

#-
# La diferencia de los resultados obtenido, incluyendo la anchura de la cota, en
# este caso es:

sn_up2 - sn_down2 + δN

#-
# Usando las cotas inferior y la superior de $\tilde{S}_N$ obtenemos:

sn_down2 + big(1)/(kmax+1)

#-
sn_up2 + big(1)/kmax

#-
setprecision(oldprecision)

#-
# El resultado numérico a partir de $\pi^2/6$, tanto en `Float64` como en
# `BigFloat` (con la precisión usal de los `BigFloat`) está entre ambos de los
# valores obtenidos para las cotas.

#-
pi^2/6 # Float64 !!

#-
big(pi)^2/6
