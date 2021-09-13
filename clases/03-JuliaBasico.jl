# # Introducción a Julia

#-
# El texto canónico de referencia para cualquier cosa (duda o discusión)
# relacionada con Julia es la
# [documentación oficial](https://docs.julialang.org/en/v1/).

# ## Asignación de variables
r = 1.0 # Asigna 1.0 a la variable `r`

#-
r  # regresa el valor asignado a `r`

#-
n = 1 # un entero!

#-
# En Julia, el caracter `#` indica que el resto de la línea
# es un comentario. Para comentar varias líneas usamos `#=`
# al inicio y `=#`  al final del comentario.

#= Los nombres de las variables pueden ser, o incluir,
caracteres *unicode*.=#
ħ = 1.0  # ħ se obtiene con \hbar<TAB>

#-
perim_circ = 2 * pi * r
perim_circ

#-
area_circ = π * r^2 # π se obtiene con \pi<TAB>

#-
area_circ / perim_circ

#-
esta_clase = "Temas Selectos de Física Computacional 3"  # Una cadena (string)

#-
sqrt(π)  # funciones elementales

#-
sin(pi)

#-
1/2 + 1/3  # operaciones típicas

#-
1//2 # número racional

#-
1//2 + 1//3  # operaciones con números racionales

#-
1//2 + 1/3  # suma un racional y un número de punto flotante

#-
sqrt(-1.0)  # devuelve un error; vale la pena tratar de entenderlo!

#-
z = sqrt(Complex(-1.0)) # en Julia existen número complejos

#-
cmplx = complex(1.0, 3.2) # Esto es equivalente a `1.0 + 3.2*im`

#-
z^2 # las potencias son con `^`

#-
exp(z)  # funciones definidas sobre los complejos: eᶻ

#-
π # pi como "irracional"

#-
1.0 * π # pi como número de punto flotante

#-
big(0.1) # números de precisión extendida

#-
BigFloat(0.1) # 0.1, como número de punto flotante, en precisión extendida

#-
BigFloat("0.1") # 0.1 en precisión extendida

#-
# Uno puede obtener en muchos casos ayuda sobre ciertas funciones.

?sin

# ## Vectores y matrices

un_vector = [1, 2, 3, 4] # se definen con `[...]`, y los elementos se separan por `,`

#-
# Noten que la salida del vector incluye información sobre el tipo específico
# del vector: en la celda anterior, la salida corresponde a un *arreglo* de
# enteros de dimensión 1, o sea, un vector (columna) de enteros.

# Como se muestra en la siguiente celda, si es posible *promocionar* los
# elementos del vector a un tipo común, esto se lleva a cabo. La razón es
# eficiencia en el manejo de la memoria.

otro_vector = [1.0, 2, 3, 4//1 ] # En este caso es un `Array{Float64,1}`

#  Uno puede realizar *ciertas* operaciones entre vectores
un_vector + otro_vector

#-
un_vector * otro_vector # da un `MethodError`; `*` entre vectores no es una operación del álgebra lineal

#-
transpose(un_vector) * otro_vector # producto interno

#-
un_vector .* otro_vector # producto de elemento a elemento; regresa un vector

#-
un_vector .^ 2 # cuadrado, elemento  a elemento

# Uno puede evaluar otras funciones elemento-a-elemento, explotando lo que
# se llama *broadcasting*. Esto equivale a hacer la operación de manera
# vectorizada

sin.(un_vector) # broadcasting

# Los vectores definidos anteriormente se comportan como vectores *columna*.
# Uno también puede definir (directamente) vectores renglón.

vector_renglon = [1 2 3 4]

#-
@show(un_vector)
un_vector[2] # 2do elemento del vector

#-
un_vector[2:3]  # una rebanada (slice)

#-
2:4 # esto  define un *rango*

#-
collect(2:4)  # esto hace del rango el vector apropiado; es eficiente trabajar con rangos

#-
collect(2:3:9) # de 2 a 9 en pasos de 3

#-
collect(0:0.1:2) # de 0 a 2 en pasos de 0.1

#-
rang = range(0, step=0.1, stop=2)  # lo mismo que lo anterior, pero más eficiente

#-
rang[2]  # 2do elemento de `rang`

#-
collect(rang)

# ## Matrices

# Tanto `vector_renglon` o `un_vector .^ [0,1,2]` devuelven matrices. En este
# sentido, las matrices son arreglos de dimensión 2.

A = [2  1 0
     1 -1 1;
    -2  3 1]

#-
una_matriz = [[2, 1, -2] [1, -1, 3] [0, 1, 1]] # concateno horizontalmente vectores; noten el espacio entre los vectores columna

#-
A[2,3]   # elemento (2,3)

# Julia almacena en memoria a las matrices usando como índice rápido el primero; esta convención
# se llama "a lo largo de la columna"  (o *column wise*). Respetar este órden en memoria
# *ayuda* a generar código rápido.

# Una consecuencia de esto es que uno puede indizar los elementos de una matriz con un sólo índice,
# que simplemente recorre el *órden* en memoria.

A[6] # equivalente,  en este caso, a A[2,3]

# Es importante notar que los elementos de cada renglón se separan con un espacio
# en blanco, y los renglones por <Enter> o un  `;`.

# Varias operaciones estándar del álgebra lineal están definidas de manera natural.
b = un_vector[1:3]  # vector de longitud 3, a partir de `un_vector`

#-
A*b  # producto de matriz por vector

#-
inv(A)  # matriz inversa

# La solución del sistema $A x = b$ es $x = A^{-1} b$
x1 = inv(A)*b

#-
A*x1 - b  # verificamos qué tan buena es la solución

#-
x2 = A\b # equivale a inv(A)*b, pero es más rápido

#-
x1 == x2  # Los resultados no son idénticos; `A\b` es más rápido

# Varias operaciones son reconocidas entre vectores y matrices. En particular, explotando
# `transpose` uno puede efectivamente lograr un producto eexterno

un_vector * transpose(un_vector)

# Otras construcciones de matrices se pueden hacer explotando el *broadcasting*.
un_vector .^ [0 1 2 3] # esto es una matriz de Vandermonde

#-
sin.(A) # `sin` evaluado elemento a elemento

#-
sin(A)  # función `sin` aplicado a la matriz `A` (no a cada elemento!)

# ## Tuplas

una_tupla = (1, 2, 3, 4) # una tupla

#-
una_tupla_con_nombres = (a=1, b=3.0) # una tupla cuyas entradas tienen nombres

#-
una_tupla[2]

#-
una_tupla_con_nombres.b # equivalente a una_tupla_con_nombres[2]

# Una diferencia entre un vector y una tupla es que el vector es *mutable*, mientras
# que la tupla no. Eso lo que significa es que los elementos de un vector pueden ser
# cambiados, reasignados, añadidos o borrados, y los de la tupla no. Las matrices,
# siendo arreglos, son mutables.

un_vector[end] = 0 # `end` se usa para indicar el último elemento

#-
una_tupla[end] = 0  # arroja un `MethodError`

# Otra diferencia entre las tuplas y los vectores es que las operaciones típicas no
# funcionan con las tuplas.

una_tupla + una_tupla  # esto arroja un `MethodError`

# ## Tipos

# Todo en Julia tiene asignado un *tipo*. Reconocer esto permite explotar las
# ventajas que Julia ofrece.

typeof(r) # un número de punto flotante `Float64`

#-
typeof(pi) # un número irracional

#-
typeof(1) # un entero; para procesadores antiguos, el resultado puede ser `Int32`

#-
typeof(1//3) # Un número racional; noten que hay `Int64` en el tipo, que etiqueta al racional

#-
typeof(z) # Un número complejo; noten otra vez que incluye "un apellido"

#-
typeof(un_vector) # Un vector; aquí hay dos "parámetros" para distinguirlo, el segundo es la dimensión

#-
typeof(A) # Una matriz es un `Array` de dimensión 2

#-
typeof(una_tupla)

#-
typeof(una_tupla_con_nombres)

#-
typeof(esta_clase) # una cadena

#-
typeof(+) # Los operadores (funciones) también tienen *su propio* tipo

#-
typeof(exp) # este output raro indica que las funciones tienen su propio tipo

#-
typeof(1.0)

#-
typeof(Float64) # Incluso los "tipos" tienen un tipo asignado específico

#-
typeof(DataType)

#-
typeof(typeof(exp))

# Los tipos en Julia tienens una estructura (en el sentido de grafos)
# que es un árbol. Uno puede conocer los tipos más generales, o más específicos,
# usando las instrucciones `supertype` y `subtypes`; la última está
# dentro de la librería estándar `InteractiveUtils.jl`, que eventualmente
# cargaremos.

supertype(Int)

#-
supertype(Signed)

#-
supertype(Integer)

#-
supertype(Real)

#-
supertype(Number)

#-
supertype(Float64)

#-
supertype(AbstractFloat)

#-
supertype(typeof(esta_clase))

#-
supertype(AbstractString)

#-
supertype(Any)

# Claramente, cualquier cosa tiene como último supertipo a `Any`.

# Para  ver los resultados de los subtipos, cargamos de la librería
# `InteractiveUtils` la función `subtypes`.

using InteractiveUtils: subtypes

#-
subtypes(Number)  # regressa un  vector de tipos

# Las *hojas del árbol* de tipos (el final) corresponde a `Type[]` que es un
# vector con *cero elementos* de tipo `Type`. Esto es una manera de decir
# que no hay más subtipos.

typeof(subtypes(Number))

#-
subtypes(Float64)

#-
typeof(subtypes(Float64))

#-
# Para saber si un objeto es de cierto tipo, uno utiliza la función `isa`

1.0 isa Int # esto equivale a isa(1.0, Int)

#-
typeof(false) # `false` y `true` son de tipo `Bool`

#-
true isa Bool

#-
supertype(Bool) # `Bool` es de tipo `Integer` ya que es equivalente a 0 o 1, y requiere 1 bit de memoria

# Para saber si un tipo es subtipo de otro, uno utiliza el operador `<:`; en algún sentido,
# este operador verifica si `Bool` está en una subrama de `Integer`

Bool <: Integer

#-
Real <: Number

#-
Float64 <: Number

#-
BigFloat <: Real

# Los tipos pueden ser `concretos` o `abstractos`; la deferencia está en que los tipos
# concretos se pueden representar de una manera *concreta* en memoria; los tipos abstractos
# sirven para poder *generalizar* ciertas funciones a varios tipos; no tienen una representación
# concreta en memoria.

isconcretetype(Float64), isconcretetype(Real)

#-
isabstracttype(Number)

