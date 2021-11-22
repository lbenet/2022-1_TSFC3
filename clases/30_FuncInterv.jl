#-
# # Análisis con intervalos 1

#-
# > Ref: W. Tucker, Validated Numerics: A Short Introduction to Rigorous Computations, Princeton University Press, 2011

#-
# ## Funciones evaluadas en intervalos

#-
# Uno de los objetivos principales de la aritmética de intervalos es obtener una cota
# del *rango* de una función $f$ a partir de un dominio (intervalo). El rango de una función
# $f$ sobre $D\subset \mathbb{R}$, que denotaremos por $R(f; D)$, es el conjunto de puntos que se obtiene
# al evaluar $f(x)$ para todo $x\in D$.

# Como primer paso, extenderemos la definición de una función a funciones de intervalos.
# Esencialmente, esto corresponde a extender las funciones a tomar y devolver intervalos en
# lugar de números (reales).
# Esto lo podemos hacer con lo que hemos desarrollado hasta ahora para funciones racionales
# sin singularidades,
# es decir, $f(x)=p(x)/q(x)$, donde $p(x)$ y $q(x)$ son polinomios en $x$ ($q(x)\neq 0$ para toda
# $x\in [x]$), simplemente al
# sustituir $x$ por $[x]$, gracias a que hemos extendido las operaciones aritméticas elementales
# incluyendo las potencias con exponentes enteros. De esta manera podemos hablar de la
# extensión *natural* a intervalos $F([x])$, y tenemos que $R(f; [x])\subseteq F([x])$
# por la propiedad de monotonicidad isotónica.

#-
# La propiedad importante que utilizaremos para extender otras funciones a intervalos es
# la monotonicidad por segmentos. En efecto, si una función $f$ es monotóna (creciente o
# decreciente) en un intervalo $[x]$, entonces podemos extender $f(x)$ a $F([x])$ con la propiedad
# de que el rango puede obtenerse al evaluar $f$ en los extremos del intervalo, es decir,
# $R(f,[x]) = F([x])$. En este caso, la extensión a intervalos es *estrecha* en el sentido de
# que se cumple la igualdad, y esto lo conseguimos usando la evaluación en los bordes de $[x]$.

# Dado que las *funciones estándar* que usamos ($\sqrt{x}$, $\exp(x)$, $\log(x)$, $x^{p/q}$,
# $\sin(x)$, $\cos(x)$, $\tan(x)$, $\dots$, $\arcsin(x)$, $\arccos(x)$, $\arctan(x)$, $\dots$,
# $\sinh(x)$, $\cosh(x)$, $\dots$, $\textrm{arcsinh}(x)$, $\textrm{arccosh}(x)$, $\dots$) justamente tienen
# la propiedad de ser monótonas *por segmentos*, entonces las usaremos como los elementos básicos
# para construir otras más complejas, que es lo que llamaremos las *funciones elementales*, y
# que se obtienen a partir de la composición de funciones estándar y de operaciones aritméticas.

#-
# Entonces, podemos definir la extensión a intervalos como:
# ```math
# \begin{align*}
# \sqrt{[x]} & = [\sqrt{\underline{x}}, \sqrt{\overline{x}}], & \underline{x}\ge 0,\\
# \exp([x]) & = [\exp(\underline{x}), \exp(\overline{x})], & \\
# \log([x]) & = [\log(\overline{x}), \log(\underline{x})], & \underline{x} > 0, \\
# \arctan([x]) & = [\arctan(\underline{x}), \arctan(\overline{x})]. &
# \end{align*}
# ```

#-
# Para funciones estándar que no son estrictamente monótonas, como $\sin(x)$,
# descompondremos primero el dominio
# en segmentos que cumplen la monotonicidad y usamos en cada uno de estos segmentos para
# obtener el rango apropiado a ese segmento; esto equivale, en algún sentido, a localizar
# los máximos y mínimos de la función. Y, finalmente, usamos la cáscara (*hull*)
# de los distintos segmentos.

# Un ejemplo de esto es la extensión de la función $\sin(x)$. Partiendo de la
# definición de $S_+=\{ 2\pi k + \pi/2: k\in \mathbb{Z}\}$ y
# $S_-=\{ 2\pi k - \pi/2: k\in \mathbb{Z}\}$, que corresponden a los conjuntos donde
# se localizan los máximos y mínimos de $\sin(x)$, entonces escribimos:
# ```math
# \sin([x]) = \begin{cases}
# \begin{align*}
# & [-1,1],
# & \textrm{si } [x]\cap S_+ \neq [\emptyset] \textrm{ y } S_- \neq [\emptyset],\\
# & [-1, \max(\sin(\underline{x}), \sin(\overline{x}))],
# & \textrm{si } [x]\cap S_+ = [\emptyset] \textrm{ y } S_- \neq [\emptyset],\\
# & [\min(\sin(\underline{x}), \sin(\overline{x})), 1],
# & \textrm{si } [x]\cap S_+ \neq [\emptyset] \textrm{ y } S_- = [\emptyset],\\
# & [\min(\sin(\underline{x}), \sin(\overline{x})), \max(\sin(\underline{x}), \sin(\overline{x}))],
# & \textrm{si } [x]\cap S_+ = [\emptyset] \textrm{ y } S_- = [\emptyset].\\
# \end{align*}
# \end{cases}
# ```

#-
# La evaluación de funciones elementales se hace, como lo haríamos a mano, descomponiendo la
# función en un árbol de subexpresiones más sencillas, que descomponemos sucesivamente, hasta
# llegar a la evaluación de funciones estándar, lo que se conoce como el grafo directo
# acíclico (DAG, por sus siglas en inglés).

# Para ejemplificar el concepto del DAG, utilizaremos la paquetería
# [`TreeView.jl`](https://github.com/JuliaTeX/TreeView.jl)
# junto con [`TikzGraphs.jl`](https://github.com/JuliaTeX/TikzGraphs.jl).
# Nos interesa visualizar el DAG de f$(x) = (x^2 - \sin(x)) * (x^7 + 3\sin(x^2))$.

using Pkg
Pkg.activate("..") # estamos en el directorio `clases`
Pkg.instantiate()  # Hay nuevos paquetes que usaremos

#-
# Primero representamos simplemente el árbol de las operaciones

using TreeView
@tree (x^2 - sin(x)) * (x^7 + 3sin(x^2))

#-
# Ahora mostramos el DAG:

@dag (x^2 - sin(x)) * (x^7 + 3sin(x^2))

#-
# La idea, entonces, es substituir $x$ por el intervalo $[x]$ en cada subexpresión.
# Sin embargo, y por las propiedades intrínsecas de los intervalos (el problema de la
# dependencia), la extensión a intervalos $F$ depende de la representación particular de $f$.
# Esencialmente lo que esto impone es que, si la variable $x$ aparece más de una vez,
# podemos espera que el problema de la dependencia aparecerá, y el rango de la función
# estará contenido en $F([x])$, pero no de manera estrecha. El punto importante es que
# el rango $R(f; x)$ está contenido en la extensión a intervalos $F([x])$
# por la inclusión isotónica.

#-
# **Teorema** (Teorema fundamental de la aritmética de intervalos). Dada una función
# elemental $f$ y su extensión natural a intervalos $F$ de tal manera que $F([x])$ está
# bien definida para algún $[x]\in \mathbb{IR}$, entonces se cumple
# 1. $[z]\subseteq [z']\subseteq [x] \Rightarrow F([z])\subseteq F([z'])$, (inclusión monótona),
# 1. $R(f; x) \subseteq F([x])$, (inclusión de rango).

#-
# La importancia de este teorema es que tenemos una manera de acotar el rango de funciones
# elementales, ya que si bien $R(f;[x])$ es difícil de obtener, el rango estará contenido
# en la extensión a intervalos de la función $F([x])$.
# Este resultado puede ser explotado considerando su negativo: Si $y\notin F([x])$ entonces
# $y\notin R(f;[x])$. Esta última forma de formular las cosas será muy útil cuando busquemos,
# los ceros de una función $f(x)$, ya que si $0\notin F([x])$ entonces sabremos que $[x]$ no
# incluye ningún punto tal que $f(x)=0$.

#-
# Para ilustrar esto, en el siguiente ejemplo consideraremos la función
# $f(x) = (\sin(x) - x^2 + 1) \cos(x)$ en el intervalo $[0, 1/2]$, y para hacernos la vida
# más sencilla usaremos las paqueterías [`IntervalArithmetic.jl`](https://github.com/JuliaIntervals/IntervalArithmetic.jl)
# (ver [aquí](https://juliaintervals.github.io/pages/tutorials/tutorialArithmetic/) para un
# tutorial) y la paquetería [`Plots.jl`](https://github.com/JuliaPlots/Plots.jl).

using IntervalArithmetic

#-
f(x) = (sin(x) - x^2 + 1)*cos(x) # La función que evaluaremos

#-
a = Interval(0, 0.5)   # Creamos un intervalo; hay distintas formas de hacer esto

#-
Fa = f(a)  # Evaluamos la función en el intervalo `a`

#-
# El resultado anterior demuestra que $f(x)$ en el intervalo $[0,1/2]$, no tiene ceros.

#-
using Plots

#-
box_a = IntervalBox(a, Fa) # creamos una `caja` de intervalos

#-
plot(box_a)
plot!(a.lo:1/128:a.hi, f, lw=2, color=:red)

#-
# Como se muestra en la gráfica anterior, la extensión a intervalos de $f(x)$ produce un
# intervalo demasiado ancho en comparación con el rango de la función. Esta observación
# de que $F([x])$ es exagerada respecto a $R(f; [x])$ es una consecuencia del problema de
# la dependencia. Una manera de mejorar
# esta exageración es *subdividiendo* $[x]$ en intervalos menos anchos; la evaluación de $F$
# en estos subintervalos dará en general cotas menos exageradas para cada uno de ellos, y su unión
# (en el sentido del `hull`)
# resultará en una cota más estrecha para el rango.

a_minced = mince(a, 4)   # dicidimos `a` en 4 intervalos iguales

#-
Fa_minced = f.(a_minced) # evaluamos `f` en cada uno de los subintervalos

#-
plot(box_a)  # Dibujamos la caja inicial
plot!(IntervalBox.(a_minced, Fa_minced), color=:purple)  # Dibujamos las cajas de subintervalos
plot!(a.lo:1/128:a.hi, f, lw=2, color=:red) # Dibujamos una aproximación de f(x)

#-
# Esto se puede formular de manera más
# clara usando el concepto de función Lipschitz: una función $f:D\rightarrow \mathbb{R}$
# es Lipschitz si existe una constante positiva $K$ (la constante de Lipschitz) tal que,
# para todos $x, y\in D$ tenemos $|f(x)-f(y)|\le K|x-y|$. Una función Lipschitz es continua
# pero puede no ser diferenciable; si lo es, el módulo de la derivada está acotado por $K$.

#-
# **Teorema** (Acotamiento del rango). Consideremos $f:I\to\mathbb{R}$ una función
# cuyas subexpresiones son todas Lipschitz, y sea $F$ una extensión de intervalos que
# es monótona isotónica de $f$, tal que $F([x])$ está bien definida para algún
# $[x]\subset I$. Entonces, existe un $K$ que depende de $F$ y de $[x]$ tal que
# si $[x]=\bigcup_{i=1}^k [x^{(i)}]$, entonces
# ```math
# \begin{equation*}
# R(f; [x]) \subseteq \bigcup_{i=1}^k F([x^{(i)}]) \subseteq F([x]),
# \end{equation*}
# $$
# y
# $$
# \begin{equation*}
# \textrm{rad}\Big(\bigcup_{i=1}^k F([x^{(i)}])\Big) \leq \textrm{rad}\big(R(f; [x])\big) +
# K\max_{i=1\dots k} \textrm{rad}\big([x^{(i)}]\big).
# \end{equation*}
# ```

#-
# La segunda propiedad del teorema dice que, si las condiciones se satisfacen, entonces la
# sobreaproximación del rango tiende a cero no más lento que linealmente al contraerse el
# dominio.
