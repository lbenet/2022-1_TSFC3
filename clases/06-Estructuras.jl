# # Tipos/Estructuras en Julia

#-
# Hemos visto que **todo** en Julia tiene asociado un tipo o estructura. Aquí veremos varias
# formas de crear tipos que se acomoden a lo que necesitamos, y algunos trucos para que la
# ejecución sea rápida. La importancia de los tipos radica, como vimos, en el hecho que la
# elección de qué método de una función se usa depende del tipo de sus argumentos.

#-
# La convención a la hora de definir tipos es que estén escritos en estilo de "camello",
# es decir, en que la primer letra de cada palabra empieza en mayúscula. Por ejemplo,
# tenemos `Float64`, `AbstractFloat`.

# Es importante decir que los tipos **no** pueden ser redefinidos o sobreescritos en una
# sesión de Julia "normal"; para hacerlo, hay que iniciar una nueva sesión o reiniciar el kernel
# del notebook (para el Jupyter notebook).

#-
# ## Tipos inmutables y constructores internos

struct MiTipo
end

#-
# Para crear un objeto del tipo `MiTipo` se requiere un *constructor*, que sencillamente es
# una función que devuelve un objeto del tipo especificado.

methods(MiTipo)

#-
# La estructura `MiTipo` que acabamos de definir **no** contiene ningún tipo de datos, por lo
# que se llama "singleton". Este tipo de estructuras pueden ser útiles para cuestiones de
# *dispatch*, esto es, de distinguir el método que se usa.

mt = MiTipo()

#-
typeof(mt)

#-
mt isa MiTipo

#-
# En general, cuando definimos un tipo nuevo es para que contenga cierto tipo de datos, que
# por una u otra razón tienen un significado importante para nosotros.

#-
# La siguiente estructura define a `Partic1d`, que podría representar la posición y velocidad
# de una partrícula en 1 dimensión.

#-
struct Partic1d
    x :: Float64
    v :: Float64
end

#-
# Por cuestiones de eficiencia es conveniente que los tipos de las variables *internas*
# sean concretos; si se requiere
# versatilidad respecto a los tipos internos, se puede definir *tipos parámetricos*,
# como veremos más adelante.

# Es importante enfatizar que las distintas componentes internas de un tipo pueden tener distintos
# tipos asociados, por ejemplo, `Float64` y `String`.

#-
# Para acceder a la información de los campos internos de un tipo, usamos la función `fieldnames`:

fieldnames(Partic1d)

#-
# El método que por default crea a un objeto tipo `Partic1d` requiere que especifiquemos
# *en el mismo orden* todos los *campos* que lo componen.

p1 = Partic1d(1.0, -2.4)

#-
p1.x

#-
getfield(p1, :v) # Otra manera de obtener el campo `:v` de p1

# El tipo de estructura que acabamos de crear es *inmutable*, lo que significa que los
# campos individuales (cuando son *concretos*), no se pueden cambiar. Esto lo que
# significa es que si tratamos de cambiar el campo interno de un tipo inmutable, Julia
# arrojará un error.

isimmutable(p1)

#-
p1.x = 2.0

#-
# La propiedad de inmutabilidad no es recursiva; así, si una componente de un tipo
# consiste de algún campo que es mutable (por ejemplo, `Array{T,N}`), entonces
# las componentes individuales de ese campo pueden cambiar.

struct Partic2d
    x :: Array{Float64,1}
    v :: Array{Float64,1}
    #La siguiente función se llama constructor interno
    function Partic2d(x::Array{Float64,1}, v::Array{Float64,1})
        @assert length(x) == length(v) == 2
        return new(x, v)
    end
end

# La función que aparece en el interior redefine el constructor de default, y se llama
# *constructor interno*. Hay que enfatizar que el comando `new` *sólo* se utiliza en
# el caso de constructores internos; en algún sentido estamos devolviendo un objeto
# tipo `Partric2d`, que aún no está definido.

p2 = Partic2d([1.0, 2.5], [1.0, 3.0])

# Como dijimos antes, no se puede cambiar *el objeto en si* (por ser inmutable), pero sí
# sus componentes.

p2.x = [2, 1]  # Arroja un error

#-
p2.x[1] = 6.0  # cambia la primer componente del campo `:x`

#-
p2.x .= [2, 1] # Cambiamos componente a componente (con broadcasting) todo el campo `:x`

#-
p2

#-
# ## Tipos mutables

# Todo lo dicho anteriormente se puede extender para definir tipos mutables. La única
# diferencia es que a la hora de definirlos, debemos usar `mutable struct`.

mutable struct MPartic2d
    x :: Array{Float64,1}
    v :: Array{Float64,1}
    function MPartic2d(x :: Array{Float64,1}, v :: Array{Float64,1})
        @assert length(x) == length(v) == 2
        return new(x, v)
    end
end

#-
mp2 = MPartic2d([1.0, 2.5], [1.0, 3.0])

#-
mp2.x = [2, 1]  # Funciona, ya que el tipo es mutable!

#-
mp2

#-
# ## Estructuras paramétricas

# En ocasiones uno quiere definir estructuras que operen con distinto tipo de entradas. Un
# ejemplo son los racionales: tenemos `Rational{Int}` y *también* `Rational{BigInt}`; otro
# ejemplo son los complejos: `Complex{Int64}` o `ComplexF64`, que es un alias de
# `Complex{Float64}`.

#-
# Anteriormente, definimos `Partic2d` con campos que son vectores `Array{Float64,1}`, por
# lo que usar otro tipo de vectores da un error.

Partic2d([1, 2], [1, 3])

# En principio uno *podría* usar en la definición de los campos que componen al tipo,
# tipos abstractos, como `Real`. Sin embargo, dado que el compilador *no* conoce la
# estructura en memoria de tipos abstractos, el código será ineficiente. Un ejemplo
# de código ineficiente, entonces, sería:
# ```julia
# #Estructura MUY ineficiente
# struct Partic3dIneficiente
#     x :: Array{Real,1}
#     v :: Array{Real,1}
# end
# ```
# dado que `Real` es un tipo abstracto.

#-
# La alternativa es definir estructuras *paramétricas*, donde precisamente el parámetro
# es un tipo concreto (sin especificar) que es subtipo de algún tipo abstracto.

struct Partic3d{T<:Real}
    x :: Array{T,1}
    v :: Array{T,1}
    function Partic3d(x :: Array{T,1}, v :: Array{T,1}) where {T}
        @assert length(x) == length(v) == 3
        return new{T}(x, v)
    end
end

# En cierto sentido, en la definición anterior de `Partic3d{T}` la `T` adquiere un tipo
# concreto, que es subtipo de `Real`, y que es el que se utiliza en los campos donde se
# requiere especificar dentro del constructor.

Partic3d([1,2,3], [2,3,4])  # regresa un Partic3d{Int}

#-
Partic3d([1.5,2,3], [2.5,3,4]) # regresa un Partic3d{Float64}

#-
# Los tipos están organizados en un a estructura de árbol; en todos los casos anteriores,
# la definición los ha puesto directamente abajo de `Any`.

supertype(Partic3d)

# Uno puede de hecho insertar en cualquier punto del árbol de tipos los tipos definidos.
# Esto es útil porque permiite obtener cierta clase de sobrecarga de operadores, y por lo mismo,
# la posibilidad de aplicar ciertas funciones a la estructura que hemos creado.

# El siguiente ejemplo define la estructura paramétrica `MiVector2d`, y la pone como
# subtipo de `AbstractArray`; noten que `AbstractArray` *también* es una estructura
# paramétrica.

struct MiVector2d{T<:Real} <: AbstractArray{T,1}
    x :: T
    y :: T
end

#-
x = MiVector2d(1, 2) # da un error !?

# El error indica *algo* aparentemente no relacionado con lo que hemos hecho, sino que
# tiene que ver con la visualización de `x`. (El mensaje dice que el problema está con `size`.)
# Uno puede notar que `x.x` y `x.y` dan los resultado esperados; de hecho, `x` ha sido *definido*,
# pero no lo podemos visualiizar.

x.x, x.y

#-
isdefined(Main, :x)

# Para hacernos la vida más sencilla a la hora de visualizar `MiVector2d`, sobrecargaremos
# `size` y `getindex`.

import Base: size
size(::MiVector2d{T}) where {T} = (2,)

#-
function Base.getindex(v::MiVector2d, i::Int)
    if i == 1
        return v.x
    elseif i == 2
        return v.y
    else
        throw(AssertError)
    end
end

#-
x

#-
y = MiVector2d(1.2, 2.1)

# A pesar de que **no** hemos sobrecargado la suma (`:+`), funciona gracias a la estructura
# de tipo que hemos impuesto a `MiVector2d`, esto es, que sea subtipo de `AbstractArray`.

x + y

# Sin embargo, hay que notar que el resultado es un `Array{Float64,1}` y no un
# `MiVector2d{Float64}`. Para logra que el resultado sea del tipo que queremos, sobrecargamos
# la función `:+`.

Base.:+(x::MiVector2d, y::MiVector2d) = MiVector2d((x .+ y)...)

#-
x + y

# Este ejemplo *no* es uno muy interesante, pero muestra que Julia permite adecuar
# las cosas a lo que requerimos, y que permite *extender* a Julia para que la interacción
# sea sencilla.
