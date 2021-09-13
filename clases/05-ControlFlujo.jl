# # Control del flujo

# ## Condicionales

# Los condicionales en cualquier lenguaje de programación permiten decidir
# si ciertas partes del código se evalúan o no, o en otras palabras, crean *ramas*
# en el código según  una condición. En Julia, los condicionales tienen
# la estructura `if-else-end`, como vimos en un ejemplo anteriormente, y cada condición
# debe regresar una variable booleana (`true` o `false`).

function compara_x_y(x, y)
    if x < y
        println("x es menor que y: $(x<y)")
    elseif x > y
        println("x es mayor que y: ", x > y)
    else
        println("x es igual a y: ", x == y)
    end
end

#-
compara_x_y(1.0, 2.3)

#-
compara_x_y(1.0, 0.3)

#-
compara_x_y(0.0, false)

# En ocasiones, uno requiere regresar un valor dependiendo de una condición, y si
# ésta no se cumple, entonces se regresa otro valor. Esto se puede hacer con la
# construcción anterior haciendo las asignaciones pertinentes, o también, de una
# manera más corta, a través del "operador ternario".

positivo_o_negativo(x::Real) = x > zero(x) ? "positivo" : "negativo o cero"

#-
positivo_o_negativo(1.2)

#-
positivo_o_negativo(-1.2)

# La función anterior se puede igualmente escribir en una línea con `ifelse`

positivo_o_negativo(x::Real) = ifelse(x > zero(x), "positivo", "negativo o cero")

# Hay otra forma más de condicional, que es la llamada evaluación de "corto circuito".
# En ciertos casos, uno requiere evaluar expresiones que involucran dos variables
# booleanas. Esto se puede conseguir con los operadores `&` (*and*) y `|` (*or*), por
# ejemplo.

false & true

# Por otro lado, en ocasiones es rendundante evaluar *ambos* lados del operador
# lógico, por ejemplo, cuando la primera condición es `false` y evaluamos `and`
# el resultado será `false` independientemente de la segunda condición. De manera similar
# ocurre si evaluamos un `or` y  la primer condición es `true`. En estos casos, basta
# con la primer evaluación para decidir el resultado; de ahí que se llamen de
# *corto circuito*. Concretamente,
#
# - `bool_a && b` significa que `b` se evaluará si `bool_a == true`, ya que si `a == false` el resultado es `false`;
# - `bool_a || b` significa que `b` se evaluará si `bool_a == false`, ya que si `a == true` el resultado es `true`.

# Para ilustrar esto, usaremos las funciones `verdadero(x)` y `falso(x)`, que imprimen
# el valor de entrada `x`, y que regresan `true` o `false`, respectivamente.

verdadero(x) = (println(x); true)
falso(x) = (println(x); false)

#-
verdadero(1) && verdadero(2) # Dos operaciones

#-
verdadero(1) && falso(2) # Dos operaciones

#-
falso(1) && verdadero(2) # Una operación

#-
falso(1) && falso(2) # Una operación

#-
verdadero(1) || verdadero(2)  # Una operación

#-
verdadero(1) || falso(2)  # Una operación

#-
falso(1) || verdadero(2) # Dos operaciones

#-
falso(1) || falso(2) # Dos operaciones


# ## Ciclos

# Hay dos tipos de ciclos: el ciclo `while` y el ciclo `for`. Si bien éstos son en algún
# sentido equivalentes, a veces conviene usar uno en lugar del otro. *Ambas formas*, igual
# que el *bloque* `if`, requiere terminar con `end`, que marca donde acaba el código que
# se repite.

#=
La variable `glob_i` debe definirse *antes* del `while`;
tiene un caracter *global*.
=#
glob_i = 1
while glob_i <= 5
    println(glob_i)
    glob_i += 1
    v_out = glob_i
end
glob_i

#-
#= Lo siguiente, regresa un `UndefVarError` ya que `v_out` sólo existe dentro
del `while`, o sea, tiene un caracter *local*.
=#
v_out
#-
for loc_i in 1:5
    println(loc_i)
    v_out = loc_i
end

#-
v_out  # Regresa un `UndefVarError` por la misma razón que antes

#-
loc_i  # Regresa el mismo error, ya que el contador `loc_i` sólo existe dentro del `for`

# Los errores que aparecen tienen que ver con el hecho de que los bloques `for` o `while`
# definen cierto ámbito "local" para las variables que se usan; en inglés, definen un
# *scope*. Por default ese ámbito es local. Entonces, las variables `v_out` no existen fuera
# de ese ámbito, que es la razón del error. Para poderlas usar fuera, entonces,
# debemos definirlas antes, o etiquetarlas con `global`.

# En cuanto a `1:5`, habíamos viisto que esto define un `UnitRange{Int64}` que es una manera muy
# conveniente (memoria) de definir un iterador. Si uno quiere que el iterador no tenga pasos de
# tamaño 1, uno utiliza `1:2:5`, lo que daría saltos de 2 en 2, empezando en 1 y terminando
# en 5.

# Los ciclos `for` permiten *iterar* sobre objetos iterables.

for i in [1,2,3]
    println(i)
end

#-
animales = ["perro", "gato", "conejo"]
for i ∈ animales   # ∈ se obtiene con `\in<TAB>`
    println(i)
end

# A veces es necesario interrumpir un ciclo, o quizás sólo no ejecutar parte del ciclo.
# Esto se logra con `break` y `continue`.

jj = 0
for j = 1:1000
    println(j)
    j ≥ 5 && break # Si `j ≥  5` es verdadero, entonces "ejecuta" la siguiente instrucción.
    jj = j
end
jj

#-
jj = 0
for i = 1:10
    i % 3 != 0 && continue   ## i % 3 es equivalente a mod(i, 3)
    println(i)
    jj = i
end
jj

# Es posible encadenar ejecuciones de varios ciclos `for` en una línea, formando el
# producto cartesiano de los iterados.  El segundo índice equivale al índice interno.

for i = 1:2, j = 1:5
    println((i, j))
end

# Es posible construir vectores usando ciclos `for` directamente en una línea; a esto
# se le llama `comprehensions`. Por ejemplo:

v_tupla = [ (i,j) for i = 1:2, j = 1:5]

# Es mejor usar rangos que vectores, justamente porque así se para evita el uso (desperdicio?)
# de memoria. Esto lo podemos ver usando `sizeof`.

sizeof( collect(1:2^20) )   # 8*2^20, 8 bytes cada entero

#-
sizeof( [i for i=1:1_048_576] )  # 2^20 == 1048576

#-
sizeof( 1:1_000_000 )


# ## Ejercicios

# 1. Construyan una función que, a partir de un tipo de estructura (e.g., `Int64`), muestre
# el árbol de estructuras que están por arriba de él, es decir, que son más generales, hasta
# llegar a `Any`. Usen la función con varios ejemplos.
#
# 2. Usando la siguiente función (tomada de
# [aquí](https://github.com/crstnbr/JuliaWorkshop19/blob/master/1_One/1_types_and_dispatch.ipynb)),
# lo que para funcionar requiere que carguen la función `subtypes` (está dentro de
# `InteractiveUtils.jl`)
# ```julia
#     using  InteractiveUtils: subtypes
#     function show_subtypetree(T, level=1, indent=4)
#         level == 1 && println(T)
#         for s in subtypes(T)
#             println(join(fill(" ", level * indent)) * string(s))
#             show_subtypetree(s, level+1, indent)
#         end
#     end
# ```
# ¿Qué pueden decir de los tipos que son concretos en cuanto a su posición en el árbol de tipos?
#
# 3. Escriban una función, incluyendo *docstrings* que expliquen el *algoritmo*, que aproxime
# la raíz cuadrada de `a` usando el método iterativo Babilonio:
#     - (1) Empiecen con un número arbitrario *positivo* `x`.
#     - (2) Reemplacen `x` por  `(x+a/x)/2` .
#     - (3) Repitan el paso anterior usando el nuevo valor de `x`.
# (Recuerden definir algún criterio de parada de la función.)
#
