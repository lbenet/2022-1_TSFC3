# # Números en la computadora

#-
#Los preliminares
using Pkg
Pkg.activate("..")  # Activa el directorio "." respecto al lugar donde estamos
#Lo siguiente es un cambio importante; normalmente ya está incluido en los archivos del curso
#Pkg.add("Gaston")   # Instala "Gaston.jl"
using Gaston

#-
# Aquí veremos las cuestiones básicas de la aritmética implementada en la
# computadora, qué números se representan, cómo se guardan y cómo se manipulan,
# cuestiones que van más allá del lenguaje concreto que se utiliza. La idea es
# mostrar por qué algunas operaciones dan resultados sensillamente *incorrectos*
# en el contexto de los números reales.

# ## Notación posicional
#
# Empezaremos recordando la notación posicional para los números reales
# $\mathbb{R}$, con una *base* arbitraria $\beta\ge 2$ (donde $\beta$
# es un número entero). Cualquier número real puede ser escrito como una
# cadena infinita de la forma:
#
# ```math
# \begin{equation*}
# x = (-1)^\sigma \left( b_n b_{n-1}\dots b_0 . b_{-1} b_{-2} \dots \right)_\beta\ .
# \end{equation*}
# ```
#
# Aquí, $\sigma=\{0,1\}$ sirve para definir el signo de $x$, y
# $b_n, b_{n-1}, \dots$ son números *enteros* tales que $0 \le b_i \le \beta-1$
# para todo $i$.

#-
# De aquí, el número real $x$ se puede reescribir como:
#
# ```math
# \begin{align*}
# x &= (-1)^\sigma \sum_{i=-\infty}^n b_i \,\beta^i\\
#   &= (-1)^\sigma ( b_n \beta^n + b_{n-1} \beta^{n-1} + \dots + b_0 + b_{-1}\beta^{-1} + b_{-2}\beta^{-2} + \dots).
# \end{align*}
# ```

#-
# En la notación posicional además se utilizan una serie de reglas de conveniencia,
# esencialmente para evitar redundancias en la representación. Por ejemplo, si hay
# una cola infinita de ceros, ésta se omite; de igual manera, se omiten los ceros
# que están antes (a la izquierda) la parte entera.
#
# A pesar de esto, la representación tiene problemas en cualquier base $\beta$,
# dado que hay números reales que no tienen una representación única. Por
# ejemplo, $(3.1415999999\dots)_{10}\,$, con una cola infinita de ceros, es
# igual a $(3.1416)_{10}\,$. Esta redundancia se puede eliminar si, además, se
# añade el requisito de que $0\le b_i \le \beta-2$, para un número *infinito*
# de $i$. Esto es, se eliminan las colas de $\beta-1$ infinitas.

#-
# ## Números de punto flotante

#-
# Los *números de punto flotante* proporcionan una manera conveniente de representar
# los números reales, donde el lugar del punto "decimal" es importante. Los números
# de punto flotante se representan como:
#
# ```math
# \begin{equation*}
# x = (-1)^\sigma \, m \times \beta^\varepsilon,
# \end{equation*}
# ```
#
# donde $\sigma$ se relaciona con el signo igual que antes, $m$
# es la *mantisa* (o *significante*) y $\varepsilon$ es un exponente.
# Para los números de punto flotante el lugar del punto "decimal" se fija:
# sigue después del primer dígito de $m$:
#
# ```math
# \begin{equation*}
# m=(b_0.b_{1}b_{2}\dots)_\beta,
# \end{equation*}
# ```
#
# donde los subíndices de la parte *fraccionaria* de la mantisa se etiquetan
# con enteros positivos (antes usábamos enteros negativos).

#-
# El conjunto de números descritos de esta manera se conoce como los *números
# de punto flotante* en base $\beta$, y se representan con $\mathbb{F}_\beta$.
# Igual que antes, $\beta\ge 2$ es un entero, $\sigma=\{0,1\}$, el exponente
# $\varepsilon$ es algún entero, $0\leq b_i \leq \beta-1$ para todo $i$, y
# $0\leq b_i \leq \beta-2$ y para un número infinito de $i$, a fin de evitar
# las colas infinitas de $\beta-1$.


#-
# ## Números normales y subnormales

#-
# Los números de punto flotanto descritos antes introducen una nueva redundancia,
# por ejemplo, $(42)_{10}$ es igual que $(0.0042)_{10}\times 10^4$ y también
# a $(42000)_{10}\times 10^{-3}$. Para evitar esta redundancia, se pide que la
# parte entera del número consista de un "dígito", $b_0$, que es el dígito que
# está inmediatamente antes del punto "decimal", y que éste sea distinto de cero;
# la única excepción es en el caso especial $x=0$. Este requisito adicional hace
# que el exponente $\varepsilon$ sea único, y de hecho, el mínimo que hace que
# $b_0$ sea distinto de cero. Los números de punto flotante que satisfacen este
# requisito se llaman *normalizados*.

#-
# Dado que la memoria de la computadora es finita, no podemos representar a
# $\mathbb{R}$ en la computadora, ni tampoco a $\mathbb{F}_\beta$. Es por
# esto que debemos limitarnos a un nuevo subconjunto de números que sirvan para
# aproximar a los números reales, pero que sean un conjunto *finito*.

#-
# En primer lugar, restringimos el número de "dígitos" que representan la
# mantisa $m$ a un número finito, es decir, $m=(b_0.b_1 b_2 \dots b_p)_\beta$;
# el número $p$ se conoce como *precisión*. Vale la pena notar que la restricción
# de que $0\leq b_i \leq \beta-2$ se vuelve irrelevante con precisión finita, ya
# que no puede haber colas infinitas de ningún tipo. El conjunto que resulta, que
# representamos como $\mathbb{F}_{\beta,p}$, se puede demostrar que es un conjunto
# contable infinito (es un subconjunto de los racionales), por lo que aún debemos
# restringirlo más.

#-
# Para obtener un conjunto finito y útil para la computadora, fijamos la precisión
# $p$ a un valor finito, y además acotamos (por arriba y abajo) los posibles
# valores del exponente $\varepsilon$, es decir, $e_- \le \varepsilon \le e_+$.
# Al conjunto (finito) definido de esta manera lo denotaremos por
# $\mathbb{F}_{\beta,p}^{e_-, e_+}$.

#-
# La cardinalidad de $\mathbb{F}^{e_-,e_+}_{\beta,p}$, es decir, el número de
# elementos que tiene un conjunto, es
#
# ```math
# \begin{equation*}
# \#\{\mathbb{F}^{e_-,e_+}_{\beta,p}\} = 1 + 2(e_+-e_-+1)(\beta-1)\beta^{\,p-1}.
# \end{equation*}
# ```

#-
# El valor más pequeño, $x_\min$, distinto de cero, se obtiene con la mantisa
# $(1.0)_\beta$ y el exponente $\varepsilon=e_-$. De manera similar, el valor
# más grande del conjunto, $x_\max$, tiene mantisa con todos los "dígitos"
# iguales a $1$, $b_0=\dots=b_{p-1}=1$, y con el máximo exponente
# $\varepsilon=e_+$. Estos valores vienen dados por:
#
# ```math
# \begin{align*}
# x_\min &= (1.0)_\beta \beta^{\,e_-} = \beta^{\,e_-},\\
# x_\max &= (1.1\dots1)_\beta \beta^{\,e_+} = (\beta-1)\beta^{\,e_+}\sum_{i=0}^{p-1}\beta^{\,-i} \\
    #    &= \beta^{\,e_++1-p}(\beta^{\,p}-1).
# \end{align*}
# ```

#-
# Para ilustrar la construcción, usaremos como ejemplo $\mathbb{F}^{-1,2}_{2,3}$.
# De las expresiones anteriores tenemos que $\#\{\mathbb{F}^{-1,2}_{2,3}\}=33$,
# $x_\min=0.5$ y $x_\max=7$.
# Podemos obtener en este caso, explícitamente, todos los elementos de este conjunto.

#-
#Generamos todos los números normales dados e_-, e_+, prec, para beta=2
𝔽 = Float64[0.0]
b₀ = 1.0
for ee = -1:2
	for b₁=0:1
		for b₂=0:1
			x = (b₀ + b₁*2^(-1) + b₂*2^(-2))*2.0^ee
			push!(𝔽, x, -x)
		end
	end
end
sort!(𝔽)

#-
# Una representación gráfica de este conjunto se observa en la siguiente gráfica.

#-
#Usamos Gaston.jl (que es muy parecido a gnuplot) para representar este conjunto
xmax = maximum(𝔽)
err = 0.5 * one.(𝔽)
set(termopts="size 600,100")
plot(𝔽, zero.(𝔽), supp = err, plotstyle=:errorlines,
	curveconf="w p lc 'blue' ps 5",
	Axes(xrange=(-xmax-0.5, xmax+0.5), yrange=(-1,1),
		xtics=-xmax:xmax, ytics=:off,
		title=:off, key=:off, border=:off)
)
plot!([-xmax-0.5, xmax+0.5], [0.0, 0.0],
	curveconf="w l lc 'black'")

#-
# Como se puede observar de la gráfica, la distancia entre puntos vecinos de
# $\mathbb{F}_{2,3}^{-1,2}$ es constante por segmentos. Estos segmentos están
# separados por potencias consecutivas de $\beta$ obtenidas al variar $\varepsilon$,
# y la distancia entre números consecutivos disminuye a medida que el exponente
# $\varepsilon$ disminuye, excepto en torno al $0$.
# Esta "propiedad" hace que haya una gran pérdida de *exactitud* cuando se aproximan
# números muy pequeños. De hecho, también hace que ciertas propiedades aritméticas
# no se cumplan en la computadora.
#
# Una manera de evitar estos problemas, al menos de manera parcial, es permitir tener
# números que no son *normales*. Los números de punto flotante en
# $\mathbb{F}_{\beta,p}^{e_-,e_+}$ con $b_0=0$ y $\varepsilon=e_-$ se llaman
# *subnormales*.

#-
#Generamos todos los números subnormales para beta=2 y se los añadimos a los normales
s𝔽 = copy(𝔽)
ee = -1
b₀ = 0.0
for b₁=0:1
	for b₂=0:1
		x = ( b₀ + b₁*2^(-1) + b₂*2^(-2))*2.0^ee
		push!(s𝔽, x, -x)
	end
end
sort!(s𝔽)

#-
#Representación gráfica de s𝔽
xmax = 2.0^(2+1-3) * (2.0^3-1)
err = @. 0.5 * one(s𝔽)
set(termopts="size 600,100")
plot(s𝔽, zero.(s𝔽), supp = err, plotstyle=:errorlines,
	curveconf="w p lc 'blue' ps 5",
	Axes(xrange=(-xmax-0.5, xmax+0.5), yrange=(-1,1),
		xtics=-xmax:xmax, ytics=:off,
		title=:off, key=:off, border=:off)
)
plot!([-xmax-0.5, xmax+0.5], [0.0, 0.0],
	curveconf="w l lc 'black'")

#-
# Incluyendo los números subnormales junto con los números normales (de punto flotante)
# permiten que haya una transición gradual hacia $0$. Además, uno puede demostrar
# que la representación de todos los números (normales y subnormales) distintos de
# cero es única.
#
# El conjunto $\mathbb{F}_{\beta,p}^{e_-,e_+}$, entendido como los números de punto
# flotante normales y subnormales, son esencialmente los que la computadora utiliza.


#-
# Sólo nos falta entonces establecer la manera de mapear $\mathbb{R}$ a $\mathbb{F}$."

#-
# ## Redondeo

#-
# El mapeo que se encarga de pasar de $\mathbb{R}$ a $\mathbb{F}$ es el *redondeo*.
# Obviamente, este mapeo no puede ser invertible.

#-
# Antes de definir el mapeo (o de hecho *los mapeos*) es útil extender el dominio y
# el rango de los conjuntos en $\mathbb{R}^*=\mathbb{R}\cup\{-\infty,\infty\}$ y de
# la misma manera $\mathbb{F}^*=\mathbb{F}\cup\{-\infty,\infty\}$. Esto permite
# representar los números que son más grandes que el mayor de los números de
# punto flotante.

#-
# Pedimos que una operación de redondeo $\bigcirc$ satisfaga las siguientes
# dos propiedades:
#
# - (R1) $x\in\mathbb{F}^* \Rightarrow \bigcirc(x)=x,$
# - (R2) $x,y\in\mathbb{F}^*$ y $x\le y$ $\Rightarrow \bigcirc(x)\le \bigcirc(y).$
#
# Con estas propiedades se puede demostrar que el redondeo es de *calidad máxima*:
# el interior del intervalo que se puede definir con $x$ y
# $\bigcirc(x)$ no contiene puntos de $\mathbb{F}^*$.

#-
# ### Redondeo a cero

#-
# La manera más sencilla de redondear es el modo conocido como redondeo a cero.
# Este modo es equivalente al truncamiento, es decir, a omitir todos los "dígitos"
# de la mantisa que están más allá de la precisión. De esta manera definimos
#
# ```math
# \begin{equation*}
# \square_z(x) = \textrm{sign}(x) \max\left(y\in\mathbb{F}^*: y\le |x|\right).
# \end{equation*}
# ```
#
# En este caso, si escribimos $x=(-1)^\sigma(b_0.b_1b_2\dots)_\beta\,\beta^e$,
# entonces el redondeo a cero corresponde a
# $\square_z(x) = (-1)^\sigma(b_0.b_1b_2\dots b_{p-1})_\beta\,\beta^e$.
#
# El redondeo a cero es una función impar.

#-
# ### Redondeo dirigido

#-
# Podemos definir dos modos de redondeo dirigido:
# ```math
# \begin{align*}
# x\in\mathbb{R}^* &\Rightarrow \bigcirc(x)\le x, &(a)\\
# x\in\mathbb{R}^* &\Rightarrow \bigcirc(x)\ge x. &(b)\\
# \end{align*}
# ```

#-
# El redondeo que satisface $(a)$ se llama *redondeo hacia menos infinito* (o
# redondeo hacia abajo), y el que satisface $(b)$ es el *redondeo hacia más infinito*
# (redondeo hacia arriba). Estos redondeos se definen de manera formal como:
# ```math
# \begin{align*}
# \bigtriangledown(x) &= \max\left(y\in\mathbb{F}^*:y\le x\right),\\
# \bigtriangleup(x) &= \max\left(y\in\mathbb{F}^*:y\ge x\right).  \\
# \end{align*}
# ```
#
# En este caso, el intervalo $[\bigtriangledown(x), \bigtriangleup(x)]$ es de
# máxima calidad.
#
# Estos redondeos satisfacen la propiedad:
# ```math
# \begin{equation*}
# \bigtriangledown(x) = -\bigtriangleup(-x),
# \end{equation*}
# ```
# lo que permite obtener un redondeo en términos del otro.

#-
# ### Redondeo (al par) más cercano"

#-
# Tanto el redondeo a cero como los redondeos dirigidos mapean el interior de un
# intervalo formado por dos puntos consecutivos de $\mathbb{F}^*$ a un punto de
# $\mathbb{F}^*$. Esto significa que el error que se comete a través de estos
# tipos de redondeo es del orden de la longitud del intervalo definido por los
# dos puntos consecutivos de $\mathbb{F}^*$, i.e., la longitud de
# $[\bigtriangledown(x),\bigtriangleup(x)]$. Una forma de redonde que resulta en
# errores menores es el *redondeo al punto flotante más cercano*.

#-
# Para todo punto $x\in\mathbb{R}^*$ podemos acotarlo en $\mathbb{F}^*$ usando el
# intervalo $[\bigtriangledown(x),\bigtriangleup(x)]$, es decir
# ```math
# \begin{equation*}
# \bigtriangledown(x) \le x \le \bigtriangleup(x).
# \end{equation*}
# ```
#
# La idea entonces del redondeo al punto flotante más cercano es la siguiente: Para
# todo punto $|x| \le x_\max$, definimos el punto medio del intervalo de puntos de
# $\mathbb{F}^*$ que los acota como $\mu=(\bigtriangledown(x) + \bigtriangleup(x))/2$;
# si $|x| > x_\max$ entonces definimos $\mu=\textrm{sign}(x) |x_\max|$. Entonces,
# el redondeo al punto flotante más cercano regresa $\bigtriangledown(x)$ si
# $x < \mu$ y $\bigtriangleup(x)$ si $x > \mu$. En el caso en que $x=\mu$, las
# distintas maneras de resolver el empate definen los distintos modos del redondeo
# al punto más cercano.

#-
# Una manera *sin sesgo* en el error, es decir, que el error esté centrado alrededor
# de cero es usando lo que se llama el *redondeo al par más cercano*, y que denotaremos
# como $\square$. Esta manera de redondear es la que se encuentra de manera más común.
#
# Escribimos la mantisa de los números de punto flotante que acotan $x$ como
# $(a_0.a_1a_2\dots a_{p-1})_\beta$ y $(b_0.b_1b_2\dots b_{p-1})_\beta$. Entonces,
# si $x\notin \mathbb{F}^*$, definimos este modo como
#
# ```math
# \begin{align*}
# x>0 \Rightarrow \square(x) &=
# \begin{cases}
# \bigtriangledown(x), \textrm{if } x\in[\bigtriangledown(x),\mu), \textrm{ or if } x=\mu \textrm{ and } a_{p-1} \textrm{ is even},\\
# \bigtriangleup(x), \textrm{if } x\in(\mu,\bigtriangleup(x)], \textrm{ or if } x=\mu \textrm{ and } b_{p-1} \textrm{ is even},\\
# \end{cases}\\
# x<0 \Rightarrow \square(x) &= - \square(-x).
# \end{align*}
# ```
#
# Un punto importante que vale la pena recalcar es que si $|x|>x_\max$, el redondeo
# al punto flotante par más cercano da como resultado
# $\square(x) = \text{sign}(x)\infty$, que no es el punto flotante más cercano.

#-
# De manera similar uno puede definir el redondeo al punto flotante *impar* más cercano.
