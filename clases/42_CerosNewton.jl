#-
# # Ceros de funciones 2

#-
# > Referencias:
# >
# > W. Tucker, Validated Numerics: A Short Introduction to Rigorous Computations, Princeton University Press, 2011
# >
# > Inspirado en: [Newton method for interval root finding](https://juliaintervals.github.io/pages/explanations/explanationNewton/)
# >

#-
using Pkg
Pkg.activate("..")
#Pkg.instantiate()

# ## El método de Newton: funciones reales

# A partir de ahora, supondremos que la función es diferenciable. Iniciaremos describiendo
# el método de Newton para funciones reales, para distinguirlo del caso
# que explota aritmética de intervalos.

#-
# Sea $f:[x]\to\mathbb{R}$ una función continua y diferenciable en $[x]$, y $x^*\in[x]$
# una raíz de $f(x)$, es decir, $f(x^*)=0$. El método de Newton (usual) consiste en, a partir de
# un valor inicial $x_0\in[x]$, encontrar la intersección con el eje $x$ de la tangente
# a $f(x)$ que pasa por $(x_0, f(x_0))$. La tangente viene dada por
# $t(x) = f(x_0) + f^\prime(x_0) (x - x_0)$, por lo que su intersección con el eje x es
# ```math
# x_1 = x_0 - \frac{f(x_0)}{f^\prime(x_0)}.
# ```
# Repitiendo esto mismo de manera sucesiva, escribimos
# ```math
# x_k = x_{k-1} - \frac{f(x_{k-1})}{f^\prime(x_{k-1})}.
# ```

#-
# **Teorema**. Supongamos que $f:[x]\to\mathbb{R}$ es dos veces continua y diferenciable,
# con $f^\prime(x)\neq 0$ para toda $x\in[x]$, y que $f(x)$ tiene una raíz única y simple
# en $x^*\in[x]$. Entonces, si $x_0$ es *suficientemente cercana* a $x^*$, la secuencia
# $\{x_k\}_{k=0}^\infty$ converge cuadráticamente rápido a $x^*$, es decir,
# $\lim_{k\to\infty} x_k = x^*$, y
# ```math
# |x_{k+1}-x^*|\leq C |x_k-x^*|^2,
# ```
# con $C>0$ constante.

#-
# Si las hipótesis del teorema no se cumplen, y en este sentido la condición sobre la cercanía
# entre el valor inicial y la raíz es importante, la secuencia entonces puede no converger.
# Esto puede ocurrir cuando los iterados forman una órbita periódica, o simplemente si
# saltan de una manera errática.

#-
# Para ilustrar el método, consideraremos la función $f(x)=\sin(x) - 0.1*x^2 + 1$, cuya derivada
# es $f^\prime(x)=\cos(x) - 0.2*x$, y como punto inicial consideraremos $x_0=1.75$.

using Plots

#-
#Definiciones e inicializaciones
f(x) = sin(x) - 0.1*x^2 + 1
f′(x) = cos(x) - 0.2*x
t(x, x₀) = f(x₀) + f′(x₀)*(x-x₀)
dom_tot = -6:0.125:6

#-
x₀ = 1.75
anim1 = @animate for _ = 1:5
    #Iniciamos
    x₁ = x₀ - f(x₀)/f′(x₀)
    plot(dom_tot, f.(dom_tot), label="\$f(x)\$", color=:red, legend=:topleft,
        xlabel="\$x\$", ylabel="\$y\$") # f(x)
    plot!(dom_tot, zero.(dom_tot), label=:none, color=:black, linewidth=2) # eje x
    xlims!(-6.5, 6.5)
    ylims!(-3, 3)
    #Dibujamos el iterado
    plot!([x₀, x₀], [0.0, f(x₀)], label="\$x_{k}\$", color=:green,
        markershape=:circle, linestyle=:dot)  # x_k
    plot!([x₀, x₁], x->t.(x, x₀), label="\$t(x)\$", color=:blue,
        markershape=:circle, linestyle=:dash) # recta tangente
    plot!([x₁, x₁], [0.0, f(x₁)], label="\$x_{k+1}\$", color=:blue,
        markershape=:circle, linestyle=:dot)  # x_{k+1}
    global x₀ = x₁
end
gif(anim1, "anim1.gif", fps = 1)

#-
x₀

#-
# Claramente, cada nuevo iterado se acerca más y más de *una* raíz de $f(x)$, que en el caso
# que se ilustra es próximo a $\pi$. Sin embargo, uno puede verificar que si uno
# cambia ligeramente la condición inicial $x_0$, los iterados *pueden* converger a otra
# raíz, e incluso no converger. El punto es, en el mejor de los casos, el método de Newton
# *usual* permite obtener una raíz de $f(x)$, sin dar más información que eso.


#-
# ### Explotando *diferenciación automática*

#-
# En lo que hemos hecho arriba, una *incomodidad* es tener que proveer no sólo $f(x)$ sino
# además su derivada $f^\prime(x)$. Esto abre la posibilidad de cometer errores, ya sea en el
# cálculo de $f^\prime(x)$, o en su propia implementación. Una manera posible de salir de
# esta situación es explotando los métodos de
# [*diferenciación automática*](https://en.wikipedia.org/wiki/Automatic_differentiation).

# Sin entrar mucho en los detalles, lo que esencialmente se hace para implementar
# diferenciación automática es definir una estructura apropiada que contiene dos campos, el
# de la función evaluada en el punto de interés, y el de su derivada evaluada en el mismo punto.
# Al igual que lo hicimos con la estructura `Intervalo`, uno debe sobrecargar las operaciones
# aritméticas y también las funciones estándar. Esto no lo haremos aquí, por falta de tiempo,
# y simplemente explotaremos que este tipo de cosas ya existe en Julia, utilizando en
# concreto la paquetería [`ForwardDiff.jl`](https://github.com/JuliaDiff/ForwardDiff.jl).

# A continuación usaremos `ForwardDiff.jl` en el ejemplo que desarrollamos antes, lo que
# permite simplificar la implementación del método de Newton (dentro de ciertos límites).

#-
using ForwardDiff

#-
# Primero, checamos que las cosas funcionan, utilizando la misma función $f$ que usamos
# arriba:

x₀ = 1.75
ForwardDiff.derivative(f, x₀)

#-
f′(x₀)

#-
# La misma animación que hicimos antes, la podemos rehacer explotando diferenciación
# automática.

#-
anim1b = @animate for _ = 1:5
    #Iniciamos
    x₁ = x₀ - f(x₀)/ForwardDiff.derivative(f, x₀)
    plot(dom_tot, f.(dom_tot), label="\$f(x)\$", color=:red, legend=:topleft,
        xlabel="\$x\$", ylabel="\$y\$") # f(x)
    plot!(dom_tot, zero.(dom_tot), label=:none, color=:black, linewidth=2) # eje x
    xlims!(-6.5, 6.5)
    ylims!(-3, 3)
    #Dibujamos el iterado
    plot!([x₀, x₀], [0.0, f(x₀)], label="\$x_{k}\$", color=:green,
        markershape=:circle, linestyle=:dot)  # x_k
    plot!([x₀, x₁], x->t.(x, x₀), label="\$t(x)\$", color=:blue,
        markershape=:circle, linestyle=:dash) # recta tangente
    plot!([x₁, x₁], [0.0, f(x₁)], label="\$x_{k+1}\$", color=:blue,
        markershape=:circle, linestyle=:dot)  # x_{k+1}
    global x₀ = x₁
end
gif(anim1b, "anim1b.gif", fps = 1)

#-
# ## El método de Newton para intervalos

#-
# Igual que para el método usual de Newton, supondremos que $f:[x]\to\mathbb{R}$ es
# continuamente diferenciable en $[x]$, que $x^*\in[x]$ satisface $f(x^*)=0$, que
# existe y está bien definida la extensión intervalar de $f^\prime(x)$, y que
# $0\notin F^\prime([x])$. Las hipótesis que hemos hecho permiten usar el Teorema del
# Valor Medio, y entonces tenemos que $f(x) = f(x^*)+f^\prime(\zeta)(x-x^*)$, para
# alguna $\zeta$ entre $x$ y $x^*$. De aquí, podemos despejar $x^*$,
# ```math
# \begin{equation*}
# x^* = x - \frac{f(x)}{f^\prime(\zeta)} \in x - \frac{f(x)}{F^\prime([x])} \equiv N([x]; x).
# \end{equation*}
# ```
#
# Dado que $x^*\in[x]$, entonces tenemos además que $x^*\in N([x]; x) \cap [x]$, lo que
# se cumple *para toda* $x\in[x]$. La cota obtenida al considerar $x=m=\textrm{mid}([x])$
# se conoce como *operador de Newton*:
# ```math
# \begin{equation*}
# N([x]) \equiv N([x];m) = m - \frac{f(m)}{f^\prime(\zeta)}.
# \end{equation*}
# ```

#-
# El método de Newton intervalar consiste entonces en tomar $[x_0]=[x]$ como el
# *iterado inicial* para encontrar $x^*$, y definimos la secuencia de intervalos
# ```math
# \begin{equation*}
# [x_{k+1}] = N([x_k])\cap [x_k], k=0,1,2,\dots.
# \end{equation*}
# ```

#-
# A manera de ilustración del método de Newton intervalar, consideraremos la función
# $g(x) = \textrm{atan}(x)$ en el intervalo $[x]=[-1,3]$, que incluye a la única raíz
# de la función, $x^*=0$.

#Definiciones e inicializaciones
using IntervalArithmetic

g(x) = atan(x)
dom_tot = -10.5:0.125:10.5
dom0 = -1 .. 3
y0 = -3/16
y1 = -1/16
y2 = -2/16

#-
#Verificamos que el denominador no incluye al cero
0 ∉ ForwardDiff.derivative(g, dom0)

#-
"""
    N(f, dom)

Operador de Newton intervalar, aplicado para la función `f` en el dominio `dom`.
Se asume (y verifica) que 0 ∉ f′.
"""
function N(f, dom)
    f′ = ForwardDiff.derivative(f, dom)
    @assert 0 ∉ f′
      m = mid(dom)
    md = m .. m
    Nm = md - f(md)/f′
    return Nm
end

#-
#Iniciamos
plot(dom_tot, g.(dom_tot), label="\$g(x)\$", color=:red, legend=:topleft,
    xlabel="\$x\$", ylabel="\$y\$") # f(x)
plot!(dom_tot, zero.(dom_tot), label=:none, color=:black, linewidth=2) # eje x
xlims!(dom_tot[1], dom_tot[end])
ylims!(-1.5, 1.5)

#Intervalo [x_0]
plot!([dom0.lo, dom0.hi], [y0, y0], label="\$[x_0]\$", color=:blue,
    linewidth=2) # [x_0]

#Intervalo N([x_0])
xmid = mid(dom0)
g_xmid = g(xmid)
n0 = N(g, dom0) # N([x_0])
#Para evitar problemas al dibujar con Inf's
if n0.lo == -Inf
    n0 = -1000 .. n0.hi
end
if n0.hi == Inf
    n0 = n0.lo .. 1000
end
#Posibles intersecciones con el eje x dadas por N([x])
polyg = Shape([(n0.lo, 0.0), (xmid, g_xmid), (n0.hi, 0.0)])
plot!(polyg, fillcolor=:grey, label=nothing, alpha=0.2)

#Intervalo [x_1]
dom1 = n0 ∩ dom0
plot!([n0.lo, n0.hi], [y1, y1], label="\$N([x_0])\$", color=:green, linewidth=2) # N([x_0])
plot!([dom1.lo, dom1.hi], [y2, y2], label="\$N([x_0])\\cap x_0\$", color=:red,
    linewidth=2) # [x_1]
#Intersecciones con el eje x
polyg = Shape([(dom1.lo, 0.0), (xmid, g_xmid), (dom1.hi, 0.0)])
plot!(polyg, fillcolor=:grey, label=nothing, alpha=0.4) # Posibles intersecciones eje x

#Punto medio
plot!([xmid, xmid], [y0, g_xmid], color=:gray, linestyle=:dot, markershape=:circle,
    label=nothing, alpha=0.8)

#-
# Claramente, si $x^*\in [x_0]$, entonces, $x^*\in [x_k]$ para
# toda $k$. Por otro lado, si $[x_0]$ no contiene ninguna raíz, típicamente obtendremos
# $N([x_k])\cap [x_k] = \emptyset$, lo que tiene una interpretación clara y directa.

#-
# Las observaciones anteriores son consecuencia de los siguientes resultados.
#
# **Teorema** (Método de Newton intervalar). Supongamos que $N([x_0])$ está bien definido.
# Si $[x_0]$ contiene una raíz $x^*$ de $f$, entonces para todos los iterados
# se tiene que $x^*\in [x_k]$. Además, los iterados forman una secuencia anidada
# que converge a $x^*$.
#
# **Teorema**. Sea $f\in C^2([x], \mathbb{R})$, y supongamos que $N([x])$ está bien definido.
# Entonces:
# 1. si $N([x])\cap [x] = \emptyset$, entonces $[x]$ no contiene a ninguna raíz de $f$;
# 2. si $N([x])\subseteq [x]$, entonces $[x]$ contiene exactamente una raíz de $f$.
#

#-
# ## El método de Newton intervalar extendido

#-
# Hasta ahora hemos requerido que el intervalo $[x]$, en el que usamos el método de Newton
# intervalar, y la función $f(x)$ sean tales que $0\notin f^\prime([x])$. El caso en que
# $0\in f^\prime([x])$ da problemas con el método intervalar de Newton ya que, al dividir
# entre un intervalo que contiene a 0 (sin que sea idéntico a 0), el operador de Newton
# corresponde a $[\-infty, \infty]$, y por lo tanto $N([x])\cap[x]=[x]$. Sin embargo,
# esto puede resolverse reemplazando la división que aparece en la
# definición del operador de Newton por la *división extendida* de intervalos. Esta situación
# aparece, por ejemplo, cuando la función $f$ tiene máximos o mínimos en el intervalo $[x]$.

#-
# La división extendida puede devolver uno o dos intervalos (disconexos). Entonces, el método
# de Newton intervalar extendido consiste en el método de Newton intervalar aplicado a cada uno
# de los intervalos producidos por la división extendida, en cada iteración del método.

#
# Para ilustrar la aplicación del método de Newton intervalar extendido, consideraremos
# la función $f(x)= \sin(x) - 0.1*x^2 + 1$, en el intervalo [-6,6], que fue el ejemplo con el
# que ilustramos, y criticamos, el método usual de Newton.

"""
    N_extdiv(f, dom)

Operador de Newton intervalar, aplicado para la función `f` en el dominio `dom`, que
utiliza la división extendida de intervalos (`extended_div`). Regresa una tupla de
intervalos.
"""
function N_extdiv(f, dom)
    f′ = ForwardDiff.derivative(f, dom)
    m = mid(dom)
    md = m .. m
    Nm = md .- [extended_div(f(md), f′)...]
    return Nm
end


#-
dom_tot = -10:0.125:10
dom0 = -6 .. 6

#Iniciamos
plot(dom_tot, f.(dom_tot), label="\$f(x)\$", color=:red, legend=:topleft,
    xlabel="\$x\$", ylabel="\$y\$") # f(x)
plot!(dom_tot, zero.(dom_tot), label=:none, color=:black, linewidth=2) # eje x
xlims!(dom_tot[1], dom_tot[end])
ylims!(-3, 3)

#Intervalo [x_0]
plot!([dom0.lo, dom0.hi], [y0, y0], label="\$[x_0]\$", color=:blue,
    linewidth=2) # [x_0]

#Intervalos Next([x_0])
xmid = mid(dom0)
f_xmid = f(xmid)
n0ext = N_extdiv(f, dom0) # N([x_0])
for n0 in n0ext
    #Para evitar problemas al dibujar con Inf's
    if n0.lo == -Inf
        n0 = -1000 .. n0.hi
    end
    if n0.hi == Inf
        n0 = n0.lo .. 1000
    end
    #Posibles intersecciones con el eje x dadas por N([x])
    polyg = Shape([(n0.lo, 0.0), (xmid, f_xmid), (n0.hi, 0.0)])
    plot!(polyg, fillcolor=:grey, label=nothing, alpha=0.2) # Posibles intersecciones eje x

    #Intervalos [x_1]
    dom1 = n0 ∩ dom0
    plot!([n0.lo, n0.hi], [y1, y1], label="\$N([x_0])\$", color=:green, linewidth=2) # N([x_0])
    plot!([dom1.lo, dom1.hi], [y2, y2], label="\$N([x_0])\\cap x_0\$", color=:red,
        linewidth=2) # [x_1]
    #Intersecciones con el eje x
    polyg = Shape([(dom1.lo, 0.0), (xmid, f_xmid), (dom1.hi, 0.0)])
    plot!(polyg, fillcolor=:grey, label=nothing, alpha=0.4) # Posibles intersecciones eje x
end

plot!([xmid, xmid], [y0, f_xmid], color=:gray, linestyle=:dot, markershape=:circle,
    label=nothing, alpha=0.8)

#-
# Como se observa en la figura anterior, la división extendida produce dos intervalos
# disconexos que se extienden a infinito. Sin embargo, gracias a la intersección con el
# intervalo inicial, los dos intervalos que resultan $[x_1^{(a)}]$ y $[x_1^{(b)}]$
# contienen a *todas* las raíces de la función $f(x)$. Más aún, el hecho de que para el
# intervalo de la derecha se cumpla $[x_1^{(b)}]\subseteq [x_0]$ indica, como se observa,
# que el intervalo contiene a una única raíz (simple) de $f(x)$.

# Esto ilustra cómo el método de Newton intervalar extendido permite desechar intervalos que
# no tienen raíces de la función $f(x)$, y cómo es posible obtener intervalos
# que contienen a *todas* las raíces dentro del intervalo $[x]$.
