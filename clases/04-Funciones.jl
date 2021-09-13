# # Funciones  en Julia

# ## Constructores básicos

#  Iniciaremos con algo trivial...

r = 1.0

# En Julia, una función mapea una tupla de elementos de entrada, en una salida.

# Julia permite distintas formas de definir una función. La manera estándar es
# usando la instrucción `function`, y el bloque que define la función se termina con `end`.
# El resultado de una función se especifica con `return`, que si es la última
# instrrucción que define a la función (antes del `end`) se puede omitir. La convención
# a la hora de nombrar funciones es que éstas usen sólo minúsculas.

"""
área_círculo(r)

Calcula el área de un círculo de radio `r`
"""
function área_círculo(r)
    return π * r^2
end

# Lo que aparece en la función definida arriba entre comillas triples `"""` son las cadenas
# de documentación de la función (*docstrings*). Si bien no es obligatorio, es altamente
# recomendable incluir docstrings en el código. (Vale la pena notar, además, que hay dos
# caracteres UTF (no ASCII), `á` e `í`, en el nombre de la función.)

?área_círculo

# En Julia, el formato de la función (por ejemplo, la indentación) no es obligatoria; sin
# embargo, se recomienda usarla ya que hace más sencilla la lectura del código.

# Una manera totalmente equivalente pero más compacta de definir `área_círculo` es:

área_círculo(r) = π * r^2

# (Noten el mensaje de que sólo hay un método definido para la función `área_círculo`.)

área_círculo(2)

#-
área_círculo(BigFloat(2.0))

#-
área_círculo.([1, 2, 3])  #  Sin hacer nada a nuestra función, broadcasting funciona

# Es importante señalar que la `r` en la definición de `área_círculo` no es la misma
# variable que la `r` que asignamos al principio y cuyo valor *sigue* siendo `1.0`. Los
# argumentos de una función se tratan como nuevas variables *locales*, cuyo valor es idéntico
# al que se pasa a la función como argumento. Si bien es posible llamar a variables globales
# dentro de una función, eso no se recomienda.

r

# Es posible que una función modifique variables que son *mutables*, como
# por ejemplo, las componentes de un vector. En este caso, la convención recomienda
# usar `!` al final del nombre de la función, justamente para indicar que al menos
# un argumento de entrada de la función puede ser modificado. Un ejemplo es la
# función `push!`.

push!([1,2,3], 4)

# Uno puede también definir funciones que no requieren ningún argumento.

mi_nombre() = "Luis"

#-
mi_nombre()

# También vale la pena decir que los operadores, como `+` o `^`, son funciones. Por lo mismo,
# uno puede usarlas incluyendo paréntesis (que es lo que se llama *infix form*) de
# manera completamente equivalente:

1 + 2 + 3

#-
+(1, 2, 3) # forma alterna de ejecutar la instrucción anterior


# En ciertos casos, por ejemplo cuando una función requiere a otra para ser ejecutada,
# puede ser conveniente definir funciones anónimas, esto es, sin nombre. Las siguientes
# definiciones son equivalentes y definen la misma función anónima, que corrresponde a
# $f(x) = x^2 + 2x -1$.

x -> x^2 + 2x -1

#-
function (x)
    x^2 + 2x -1
end

# Una función anónima, que depende de múltiples argumentos, se escribe `(x,y) -> x^2 + y^2`,
# mientras que una función anónima sin argumentos se escribe como `() -> π`.

# ## Tuplas como argumentos y funciones con argumentos variables (varags)

# Es posible definir funciones de tal manera que uno pase como único argumento una tupla
# al ejecutar la función. Hay diversas posibilidades; la siguiente es una que explota
# (y a la vez impone) la estructura que debe tener la tupla.

distancia((max, min)) = max - min

#-
distancia((5, 2))

#-
distancia(5, 2) # Si se dan los argumentos por separado, arroja un `MethodError`

# Es útil tener la opción de escribir funciones que puedan tener un número arbitrario de
# argumentos; al número variable de argumentos se le llama *varargs*. Como ejemplo (tomado
# de la [documentación oficial](https://docs.julialang.org/en/v1/manual/functions/#Varargs-Functions))
# definiremos la función

lala(a, x...) = (a, x) # `...` que aparecen en la definición se llaman "slurp"

#-
lala(1) # esto es equivalente a `lala(1,)`

#-
lala(1, (2,))

#-
lala(1, 2, (3, 4))

# La instrucción anterior encapsula en una tupla a los argumentos `2, (3, 4)`, es decir,
# `(2, (3, 4))`.

# La siguiente ejecución de `lala` distribuye los argumentos de la tupla; esto se
# llama `splat`

lala((1,2,3)...) # equivalente a lala(1,2,3)

# ## Métodos, *multiple dispatch*, y estabilidad de tipo

# Julia permite utilizar *la misma función* en distintos contextos. Por ejemplo,
# con `*` podemos multiplicar dos números, o concatenar cadenas.

2 * 3

#-
"dos por tres es igual a " * "seis"

# Esta multiplicidad del uso de una función (con el mismo nombre) significa que la función tiene
# definidos varios métodos.

# Julia permite definir métodos especializados respecto al tipo
# del argumento de entrada a la función. Por ejemplo, la siguiente función `ff`
# muestra el valor del argumento, e imprime su valor al cuadrado.

ff(x) = (@show(x); x^2)

# Vale la pena notar que usamos paréntesis para usar la forma "infix" y
# definir de la función `ff`, que consta de dos instrucciones, que son
# separadas por `;`. El macro `@show` lo que hace es precisamente imprimir
# (sustituyenco código a la hora de "leer" el código) la variable `x`.

# Esta función, por ejemplo, la podemos aplicar a un número de punto flotante o
# a uno complejo:

ff(1.1)

#-
ff(1.1 + 3im)

# Internamente, Julia especializa la función al tipo de argumentos, y escoge la apropiada.

# Supongamos que queremos que el comportamiento de esta función, para números complejos,
# devuelva el módulo al cuadrado, en lugar de su cuadrado. En este caso debemos
# entonces definir un método especializado para el caso en que `x` sea un número
# complejo. Esto lo hacemos utilizando `::` para especificar/restringir uno o varios
# argumentos de la función a un tipo; es aquí donde los "tipos abstractos" pueden
# ser útiles.

ff(x::Complex) = (@show(x); abs2(x))  # `abs2(z)` devuelve el módulo al cuadrado  de `z`

#-
ff(1.1 + 3im)

# Para además particularizar en el posible parámetro del tipo, uno usa la siguiente
# forma:

ff(x::Complex{T}) where {T<:BigFloat} = (@show(typeof(x)); ff(angle(x)))  # `angle(z)` es el argumento (radianes) de `z`

#-
ff(big(1.1) + 3im)

# El hecho de que los distintos métodos que definen a una función se aplican de manera distinta
# *según* el *tipo* de los argumentos de entrada y de su órden es lo que se llama *multiple dispatch*. Lograr
# código rápido en Julia no significa escribir métodos específicos según el tipo
# --aunque a veces esto puede ser útil--, sino que el tipo del resultado de una función
# esté determinado *sólamente* por el tipo de los argumentos de entrada, y no por su valor. Es esto
# lo que se conoce como *estabilidad de tipo*.

# Como ejemplo de esto último, construyamos una función que *no* es estable según
# el tipo; para esto, utilizaremos un block `if`-`else`-`end`.

function mi_sqrt(x)
    @show(x)
    if x < 0
        return sqrt(Complex(x))  # El resultado es `Complex{...}`
    else
        return sqrt(x) # El resultado es del mismo tipo que `x` (`AbstractFloat`)
    end
end

#-
mi_sqrt(-1//1)

#-
mi_sqrt(1//1)

# El macro `@code_warntype`, de la librería estándar `InteractiveUtils.jl` ayuda a encontrar
# problemas respecto a la estabilidad de tipo. (Más tarde usaremos también el macro `@which`,
# así  que lo cargamos de una vez.)

using InteractiveUtils:  @code_warntype, @which
@code_warntype mi_sqrt(1//1)

# ## Ambigüedades

# Consideremos las siguientes definiciones de la función `gg`:

gg(a, b::Any)              = "fallback"   # default
gg(a::Number, b::Number)   = "a and b are both `Number`s"
gg(a::Number, b)           = "a is a `Number`"
gg(a, b::Number)           = "b is a `Number`"
gg(a::Integer, b::Integer) = "a and b are both `Integer`s"

# Uno puede obtener información sobre los métodos que tiene definidos la función
# usando `methods(gg)`

methods(gg)  # Describe los distintos métodos de una función

#-
gg(1.5, 2)

#-
gg("2", 1.5)

#-
gg(1.0, "2")

#-
gg(1, 2)

#-
gg("Hello", "World!")

#-
@which gg("2", 1.5) # El macro `@which` permite identificar qué método se está usando

# A veces, uno puede definir métodos de una función de tal manera que Julia no encuentre qué método
# aplicar en el sentido de cuál es el *más concreto* respecto al tipo de los argumentos.
# En ese caso, hay un `MethodError` dado que los métodos son *ambiguos*.

gg(x::Int, y::Any) = println("int")
gg(x::Any, y::String) = println("string")

#-
gg(3, "test")

# Vale la pena notar que en el mensaje de error, está descrita una posible solución para resolver
# la ambigüedad.


# ## Ejercicios

# 1. Escriban una función que proporcione el área y el volumen de un círculo de manera
# simultánea, es decir, que la función regrese esos dos valores.
#
# 1. Llamando a la función que hicieron en el ejercicio anterior `mifunc`, y ejecutando
# `res = mifunc(1.0)`, ¿qué *tipo* tiene `res`?
#
# 1. ¿Qué asignación pueden hacer para separar los resultados de `mifunc`?
#
# 1. ¿Cuál es el tipo de `mifunc`? Hint: ¿Cuál es el tipo de `(mifunc, typeof(mifunc))`?
#
# 1. ¿Qué tipo de resultado se obtiene al ejecutar la siguiente función?
#     ```julia
#     println("Nada")
#     ```
# 1. Analicen qué representa el resultado obtenido al ejecutar la siguiente función:
#     ```julia
#     map(first ∘ reverse ∘ uppercase, split("you can compose functions like this"))
#     ```
