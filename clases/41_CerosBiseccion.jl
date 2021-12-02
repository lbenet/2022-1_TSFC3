#-
# # Ceros de funciones

#-
# > Ref: W. Tucker, Validated Numerics: A Short Introduction to Rigorous Computations, Princeton University Press, 2011

# ## El método de bisección intervalar

# A menudo, las aplicaciones requieren calcular los ceros de una función $f$
# en un dominio $D$. Un ejemplo son problemas de optimización, en donde se busca obtener
# la localización de un mínimo o máximo (global), lo que corresponde a los ceros de la derivada
# de la función que define el proceso de optimización.
# En esta sección veremos el método más ingenuo para localizar los ceros de una función en un
# intervalo dado, que es el método de bisección.
# Lo único que supondremos es que la función $f$ es continua en $D$.

#-
# Si $f$ es continua en $[x]\subseteq I$ y si $F([x])$ existe, sabemos que
# $R(f; [x])\subseteq F([x])$. La formulación *negativa* de este resultado es que si $y\nin F([x])$
# entonces $y\nin R(f; [x])$. Entonces, para encontrar los ceros de una función, lo que haremos
# es verificar si el cálculo de $F([x])$ contiene al cero: si no contiene a cero, sabemos que no
# hay ceros de la función $f$ en $[x]$; si sí lo contiene, bisectamos $[x]$ en dos subintervalos
# y verificamos nuevamente si cada uno contiene a $0$. Esta subdivisión sucesiva la debemos hacer
# hasta que se cumpla cierta condición de *tolerancia*, esto es, que el *ancho* (diámetro)
# de los subintervalos (que contienen al cero) sea menor que cierto valor.

#-
using IntervalArithmetic

"""
    ceros_biseccion(f, dom::Interval; tol::AbstractFloat=1/1024, nmax::Int = 15)

Busca los ceros de `f` usando el método de bisección, dentro del intervalo
`dom`. El argumento `tol` fija la tolerancia, es decir, el ancho máximo de cada
intervalo candidato a contener ceros; `nmax` fija el número de iteraciones máxima
en que se bifurcan los intervalos candidatos.
"""
function ceros_biseccion(f, dom::Interval; tol::AbstractFloat=1/1024, nmax::Int = 20)
    bz = !(0 ∈ f(dom))
    v_candidatos = [dom]

    # Bifurca sucesivamente hasta que se cumpla la condición de salida
    n = 0
    while !bz && n < nmax
        biseccion!(v_candidatos, f, tol)
        bz = maximum(diam.(v_candidatos)) < tol
        n += 1
    end

    # Filtra los intervalos que no incluyan al 0
    vind = findall(0 .∈ f.(v_candidatos))
    return v_candidatos[vind]
end

#-
"""
    biseccion!(vdom, f, tol)

Implementa el método de bisección en el vector de intervalos `vdom`, para la función `f`,
con tolerancia `tol`. `vdom` es modificado de tal manera que éste incluye los subintervalos
candidato a tener un cero de `f`.

Esto se hace verificando si `0 ∈ f(dom)` para cada elemeno de `vdom`: si
el resultado es `false` se desecha de `vdom`. Si se obtiene `true`, se verifica el diámetro
del intervalo para ver si es mayor que `tol`, en cuyo caso se bisecta `dom` y se actualiza
`vdom`, o si no se conserva dentro de `vdom`.
"""
function biseccion!(vdom, f, tol)
    for _ in eachindex(vdom)
        dom = popfirst!(vdom)
        vf = f(dom)
        0 ∉ vf && continue
        if diam(dom) < tol
            push!(vdom, dom)
        else
            append!(vdom, bisecta(dom))
        end
    end
    return nothing
end

#-
"""
    bisecta(dom::Interval)

Bisecta `dom` en el punto medio, y devuelve los intervalos que se obtienen.
"""
function bisecta(dom::Interval)
    m = mid(dom)
    return Interval(dom.lo, m), Interval(m, dom.hi)
end

# Para ejemplificar el método, calcularemos los ceros de la función $f(x) = \sin(x)\big(x - \cos(x)\big)$,
# en el intervalo $D=[-10,10]$. Los ceros corresponden a los ceros de $\sin(x)$, es decir, 0,
# $\pm\pi$, $\pm 2\pi$, $\pm 3\pi$ (7 raíces), y al *único* cero de $x = \cos(x)$.

#-
f(x) = sin(x)*(x - cos(x))
dom = -10 .. 10

#-
vv = ceros_biseccion(f, dom, tol=1/2.0^10)

#-
#Verificamos...
all(0 .∈ f.(vv))

#-
# La raíz 0 está incluida en dos intervalos, en `vv[4]` y `vv[5]`, precisamente en uno
# de los bordes. Esto se debe a que el dominio usado es simétrico respecto al 0, y el 0
# es un cero de $f(x)$. Entonces, si uno rehace el ejercicio, con un dominio ligeramente
# asimétrico, las 8 raíces aparecen con claridad.

ceros_biseccion(f, Interval(-10,10.1), tol=1/2.0^10)

#-
# Vale la pena notar que, si uno tiene acceso a la derivada $f\prime(x)$, entonces uno
# puede saber si $f$ es monótona en el intervalo $[\tilde{x}]$, lo que ocurre si
# $0\nin F\prime([\tilde{x}])$. La monotonía de $f$ permite entonces saber si el cero
# contenido en $[\tilde{x}]$ es único, es decir, los ceros no son raíces múltiples.

f′(x) = cos(x) * (x-cos(x)) + sin(x) * (1+sin(x))
0 .∈ f′.(vv)

# El último resultado implica que todos los ceros son raíces únicas (simples).