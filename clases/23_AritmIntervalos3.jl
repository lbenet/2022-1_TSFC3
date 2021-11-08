#-
# # Aritmética de intervalos: calculando con conjuntos 2

#-
# > Ref: W. Tucker, Validated Numerics: A Short Introduction to Rigorous Computations, Princeton University Press, 2011

#-
# ## Implementación sencilla del redondeo

#-
# Lo que hemos desarrollado hasta ahora asume, implícitamente, que
# estamos llevando a cabo la aritmética de intervalos en $\mathbb{R}$,
# en otras palabras, con precisión infinita. Sin embargo, la
# precisión finita que usamos en la computadora, donde trabajamos con
# números de punto flotante, impone que tengamos que redondear, usando
# el redondeo direccionado.

#-
# Para ser simplistas, implementaremos una forma sencilla y conveniente
# para el redondeo en la que simplemente consideramos el número de
# punto flotante *anterior* y el siguiente a la entrada que pongamos.
# Esto hace que *todos* los intervalos tengan un ancho mínimo equivalente a
# dos sepaaciones (locales) de punto flotante. Si bien la implementación
# es relativamente sencilla en Julia (usando las funciones `prevfloat()`
# y `nextfloat()`), esto hace que *perdamos* la posibilidad de tener
# intervalos estrechos (ancho igual a cero) que corresponden a los números
# reales que son *exactamente representables como números de punto flotante.

#-
# Las funciones `prevfloat(a)` y `nextfloat(a)` literalmente devuelven el
# número de punto flotante anterior y posterior a `a`. Esto corresponde a
# cambiar el último bit de precisión.

a = 0.25 # `a` es exactamente representable como número de punto flotante
@show(bitstring(a));

#-
ap = prevfloat(a)
an = nextfloat(a)
@show(bitstring(ap), bitstring(an));

# Entonces, a la hora de crear los intervalos, deberemos considerar el
# número de punto flotante *anterior* para el ínfimo del intervalo, y
# el *siguiente* para el supremo. Esto garantizará que el intervalo
# creado *incluya* a los límites que introducimos (que son números de
# punto flotante no necesariamente exactamente representables), con la
# consecuencia de que no tendremos intervalos *delgados*.

# En el caso de las operaciones aritméticas, para $[a], [b] \in \mathbb{IF}$
# tendremos:
# ```math
# \begin{align*}
# [a] + [b] & = \big[\bigtriangledown(\underline{a}+\underline{b}),
# \bigtriangleup(\overline{a}+\overline{b})\big], \\
# [a] - [b] & = \big[\bigtriangledown(\underline{a}-\overline{b}),
# \bigtriangleup(\overline{a}-\underline{b})\big], \\
# [a] \times [b] & = \big[
#     \min\big\{ \bigtriangledown(\underline{a}\underline{b}),
#     \bigtriangledown(\underline{a}\overline{b}),
#     \bigtriangledown(\overline{a}\underline{b}),
#     \bigtriangledown(\overline{a}\overline{b})\big\},
#     \max\big\{ \bigtriangleup(\underline{a}\underline{b}),
#     \bigtriangleup(\underline{a}\overline{b}),
#     \bigtriangleup(\overline{a}\underline{b}),
#     \bigtriangleup(\overline{a}\overline{b})\big\}\big], \\
# [a] \div [b] & = \big[
#     \min\big\{ \bigtriangledown(\underline{a}/\underline{b}),
#     \bigtriangledown(\underline{a}/\overline{b}),
#     \bigtriangledown(\overline{a}/\underline{b}),
#     \bigtriangledown(\overline{a}/\overline{b})\big\},
#     \max\big\{ \bigtriangleup(\underline{a}/\underline{b}),
#     \bigtriangleup(\underline{a}/\overline{b}),
#     \bigtriangleup(\overline{a}/\underline{b}),
#     \bigtriangleup(\overline{a}/\overline{b})\big\}\big], \textrm{ si } 0\notin [b],
# \end{align*}
# ```
# donde $\bigtriangledown$ corresponde a `prevfloat` y $\bigtriangleup$
# a `nextfloat`, respectivamente.

#-
# La gran ventaja de este esquema es que es muy fácil de implementar; la desventaja es que
# los intervalos sobreestimarán las operaciones elementales de manera más tosca.

