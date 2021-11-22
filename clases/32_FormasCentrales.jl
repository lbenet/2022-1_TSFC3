#-
# # Análisis con intervalos 1

#-
# > Ref: W. Tucker, Validated Numerics: A Short Introduction to Rigorous Computations, Princeton University Press, 2011

#-
# ## Formas centrales

# En ciertas ocasiones, uno puede mejorar la sobreestimación del rango, es decir,
# hacer que tienda a cero más rápido que lineal a medida de que el dominio disminuye. Esto es
# posible si la función $f(x)$ satisface el Teorema del Valor Medio.

#-
# **Teorema** (Teorema del valor medio). Si la función $f$ es continua en $[a,b]$ y
# diferenciableen $(a,b)$, entonces existe un valor $\zeta \in [a,b]$ tal que
# $f^\prime(\zeta) = (f(b)-f(a))/(b-a)$.

#-
# Suponiendo que la función $f:[x]\to\mathbb{R}$ satisface las hipótesis del Teorema del Valor Medio,
# entonces si $x$ y $c$ son puntos en el intervalo $[x]$, existe un punto $\zeta$ entre $x$ y $c$
# tal que
# ```math
# \begin{equation*}
# f(x) = f(c) + f'(\zeta) (x-c).
# \end{equation*}
# ```
# Si tenemos una extensión de intervalos para la derivada, $F'([x])$, entonces
# ```math
# \begin{align*}
# f(x) &= f(c) + f'(\zeta) (x-c) \in f(c) + F'([x]) (x-c)\\
# &\subseteq f(c) + F'([x]) ([x]-c),
# \end{align*}
# ```
# donde la última expresión es independiente de $x$ y $\zeta$. Entonces, para toda
# $x$ y $c$ en $[x]$ tenemos
# ```math
# \begin{equation*}
# R(f; [x]) \subseteq f(c) + F'([x]) ([x]-c) \equiv F([x];c).
# \end{equation*}
# ```

#-
# La extensión de intervalos $F([x]; c)$ se conoce como *forma central*, y la elección
# más típica para $c$ es el $\textrm{mid}([x])$, lo que produce la forma del valor medio
# $F_m([x])$ dada por
# ```math
# \begin{equation*}
# F_m([x]) = F(m) + F'([x]) ([x]-m) = F(m) + F'([x]) [-r,r],
# \end{equation*}
# ```
# donde $m$ es el punto medio y $r$ es el radio del intervalo.

#-
# **Teorema** (Teorema de la cota de la forma central). Consideremos $f:I\to\mathbb{R}$ que
# satisface las hipótesis del Teorema del Valor Medio, y sea $F'$ la extensión a intervalos
# de $f'(x)$ de tal manera que $F'([x])$ está bien definida para algún $[x]\subseteq I$.
# Entonces, si $c \in [x]$ tenemos
# ```math
# \begin{equation*}
# R(f; [x]) \subseteq F([x]; c)
# \end{equation*}
# ```
# y
# ```math
# \begin{equation*}
# \textrm{rad}\Big(F([x];c))\Big) \leq \textrm{rad}\big(R(f; [x])\big) +
# 4\textrm{rad}\big(F'([x])\big)\, \textrm{rad}([x]).
# \end{equation*}
# ```
# Si la forma central se usa, el factor 4 debe reemplazarse por 2.

#-
# Como ejemplo consideraremos $f(x) = (x^2+1)/x$, de donde
# $f'(x)=(x^2-1)/x^2$ y evaluaremos en el intervalo $[x]=[1,2]$.

using IntervalArithmetic

#-
f(x) = (x^2+1)/x
f′(x) = (x^2-1)/x^2
xI = 1 .. 2

#-
fxI = f(xI)

#-
diam(fxI)

#-
"""
    centrla_form(f, f′, I)
Calcula el rango de `f` en `I` usando la forma central; requiere
la forma funcional de la derivada de `f`, dada en `f′`.
"""
function central_form(f, f′, I)
    c = IntervalArithmetic.atomic(Interval{Float64}, mid(I))
    return f(c) + f′(I)*(I-c)
end

fc = central_form(f, f′, xI)

#-
diam(fc)

#-
# La forma central `fc` da un resultado menos ancho que `fxI`, que es
# la manera *ingenua* # de evaluar el rango de $f(x)$ usando aritmética
# de intervalos directamente. Sin embargo, uno puede observar que el
# límite inferior de `fxI` es *mejor* que el dado por la forma central
# `fc`, en el sentido de que es mayor que el ínfimo producido por `fc`.
# Entonces, una mejor cota para el rango puede obtenerse de la
# intersección de ambos intervalos, `fxI ∩ fc`:

fxI ∩ fc

#-
# ## Monotonicidad a través de la derivada

#-
# Anteriormente vimos que la monotonicidad permite obtener cotas estrechas
# del rango. La monotonicidad se puede inferir a partir de la derivada, la cual
# es requerida para calcular la forma central. Entonces, si $f\prime([x])$
# cumple ser mayor/menor o igual a cero (el cero sólo puede ocurrir en los
# extremos del intervalo $[x]$), tenemos que la función $f(x)$ es creciente/decreciente
# en $[x]$, y en este caso el rango de la función es:
# ```math
# R(f; [x]) = \begin{cases}
# \begin{align*}
# &[f(\underline{x}), f(\overline{x})], &\textrm{ si } \min\big(F\prime([x])\big)\geq 0,\\
# &[f(\overline{x}), f(\underline{x})], &\textrm{ si } \min\big(F\prime([x])\big)\leq 0.
# \end{align*}
# \end{cases}
# ```

#-
# Usando el ejemplo anterior, tenemos que

f′(xI) ≥ 0

# de donde el rango de $f(x)$ a partir de los límites del intervalo $[x]$:

Interval( f(xI.lo), f(xI.hi) )

# Claramente, el rango obtenido es el más estrecho de los anteriores y corresponde al
# rango de $f(x)$. Esto ilustra un hecho más general: cuánto más conozcamos de la función,
# en general, podemos acotar de mejor manera la función.
