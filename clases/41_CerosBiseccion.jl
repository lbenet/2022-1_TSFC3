#-
# # Ceros de funciones 1

#-
# > Referencias:
# >
# > W. Tucker, Validated Numerics: A Short Introduction to Rigorous Computations, Princeton University Press, 2011
# >
# > W. Tucker, [Validated Numerics for Pedestrians](http://www2.math.uu.se/~warwick/main/papers/ECM04Tucker.pdf), 4th European
# > Congress of Mathematics (2005), European Mathematical Society. 851-860.
# >

# ## El método de bisección intervalar

# A menudo, las aplicaciones requieren calcular los ceros de una función $f$
# en un dominio $D$. Un ejemplo son problemas de optimización, en donde se busca obtener
# la localización de un mínimo o máximo (global), lo que corresponde a los ceros de la derivada
# de la función que define el proceso de optimización.
# En esta sección veremos el método más ingenuo para localizar los ceros de una función en un
# intervalo dado, que es el método de bisección.
# Lo único que supondremos es que la función $f$ es continua en $D$.

#-
# El método de bisección para números reales (o números de punto flotante),
# requiere de dos valores iniciales, $a_0$ y $b_0$, tales que tengan la función
# $f$ evaluada en estos puntos resulte en signos contrarios, es decir,
# $f(a_0) f(b_0) < 0$. A partir de esto, que en sí puede ser difícil, uno considera
# el punto medio, $c=(a_0+b_0)/2$. (i) Si $f(c)=0$, la raíz es $c$, y se termina
# el procedimiento. (ii) Si $f(c)$ tiene el mismo signo que $a_0$ entonces
# $a_1=c$ y $b_1=b$, o (iii) si $f(c)$ tiene el mismo signo que $b_0$, entonces
# $a_1=b$ y $b_1=c$; en ambos casos, se vuelve al inicio del método
# con los nuevos valores. El método se itera hasta que la distancia
# $|a_k-b_k|<\tau$, donde $\tau$ es una tolerancia para aproximar el cero de la función.

# El método descrito claramente converge, y lo hace exponencialmente, ya que la distancia entre
# los puntos $a_k$ y $b_k$ disminuye como $1/2^k$. Sin embargo, como mencionamos, encontrar
# los puntos iniciales $a_0$ y $b_0$ puede no ser sencillo, y el método sólo permite obtener un
# cero de la función.

#-
# Si $f$ es continua en $[x]\subseteq D$ y si $F([x])$ existe, sabemos que
# $R(f; [x])\subseteq F([x])$. La formulación *negativa* de este resultado es que si
# $y\notin F([x])$ entonces $y\notin R(f; [x])$. Por lo tanto, para encontrar los ceros
# de una función, lo que haremos es verificar si el cálculo de $F([x])$ contiene al cero:
# si no contiene a cero desechamos al intervalo $[x]$; si sí lo contiene, bisectamos
# $[x]$, y volvemos al inicio, aplicando el método a cada uno de los subintervalos. Esta
# subdivisión sucesiva la debemos hacer hasta que se cumpla cierta condición de *tolerancia*,
# al igual que antes, esto es que el *ancho* (diámetro) de los subintervalos (candidatos a
# contener al cero) sea menor que cierto valor.

#-
using IntervalArithmetic

"""
    ceros_biseccion(f, dom::Interval; tol::AbstractFloat=1/1024, nmax::Int = 15)

Busca los ceros de `f` usando el método de bisección, dentro del intervalo
`dom`. El argumento `tol` fija la tolerancia, es decir, el ancho máximo de cada
intervalo candidato a contener ceros.
"""
function ceros_biseccion(f, dom::Interval; tol::AbstractFloat=1/1024)
    bz = !(0 ∈ f(dom))
    v_candidatos = [dom]  # Este vector incluirá al resultado

    #Bifurca sucesivamente hasta que se cumpla la condición de salida
    while !bz
        biseccion!(v_candidatos, f, tol)
        bz = maximum(diam.(v_candidatos)) < tol # Esto evita problemas
    end

    #Filtra los intervalos que no incluyan al 0
    vind = findall(0 .∈ f.(v_candidatos))
    return v_candidatos[vind]
end

#-
"""
    biseccion!(vdom, f, tol)

Implementa el método de bisección en el vector de intervalos `vdom`, para la función `f`,
con tolerancia `tol`. `vdom` es modificado dentro de la función, de tal manera que este vector
incluye los subintervalos que se mantienen como candidatos a tener un cero de `f`.

Esto se hace verificando si `0 ∈ f(dom)` para cada elemeno de `vdom`: si
el resultado es `false` se desecha de `vdom`. Si se obtiene `true`, se verifica el diámetro
del intervalo para ver si es mayor que `tol`, en cuyo caso se bisecta `dom` y se actualiza
`vdom`, o si no se conserva dentro de `vdom`.
"""
function biseccion!(vdom, f, tol)
    for _ in eachindex(vdom)
        dom = popfirst!(vdom)  # Extraemos y borramos la primer entrada de `vdom`
        vf = f(dom)
        0 ∉ vf && continue
        if diam(dom) < tol
            push!(vdom, dom)   # Se incluye a `dom` (al final de `vdom`)
        else
            append!(vdom, bisecta(dom)) # Se bisecta e incluye en `vdom`
        end
    end
    return nothing
end

#-
"""
    bisecta(dom::Interval)

Bisecta `dom` (en el punto medio) y devuelve los intervalos que se obtienen.
"""
function bisecta(dom::Interval)
    m = mid(dom)
    return Interval(dom.lo, m), Interval(m, dom.hi)
end

#-
# Para ejemplificar el método, calcularemos los ceros de la función $f(x) = \sin(x)\big(x - \cos(x)\big)$,
# en el intervalo $D=[-10,10]$. Los ceros corresponden a los ceros de $\sin(x)$, es decir, 0,
# $\pm\pi$, $\pm 2\pi$, $\pm 3\pi$ (7 raíces), y al *único* cero de $x = \cos(x)$.

#-
f(x) = sin(x)*(x - cos(x))
dom = -10 .. 10

#-
raices = ceros_biseccion(f, dom, tol=1/2.0^10)

#-
#Verificamos...
all(0 .∈ f.(raices))

#-
# La raíz 0 está incluida en dos intervalos, en `raices[4]` y `raices[5]`, precisamente en uno
# de los bordes. Esto se debe a que el dominio usado es simétrico respecto a 0, y además
# $f(0)=0$. Entonces, si uno rehace el ejercicio, con un dominio ligeramente
# asimétrico, las 8 raíces aparecen con claridad.

ceros_biseccion(f, Interval(-10,10.1), tol=1/2.0^10)

#-
# Vale la pena notar que, si uno tiene acceso a la derivada $f^\prime(x)$, entonces uno
# puede saber si $f$ es monótona en el intervalo $[\tilde{x}]\subseteq D$, lo que ocurre si
# $0\notin F^\prime([\tilde{x}])$. La monotonía de $f$ permite entonces saber si el cero
# contenido en $[\tilde{x}]$ es único, es decir, el cero es una raíz simple.

f′(x) = cos(x) * (x-cos(x)) + sin(x) * (1+sin(x))
all(0 .∈ f′.(raices))

# El último resultado implica que todos los ceros son raíces únicas (simples).