#-
# # IEEE-754

# ## El estándar

# Para la aritmética de punto flotante existe un estándar cuyo
# objetivo es definir un *formato* común para números de punto
# flotante, y algunas propiedades que dicho formato debe cumplir.

# El estándar IEEE-754 es un formato binario, así que $\beta=2$. Hay
# varias razones por las que $\beta=2$ es importante: la arquitectura de las
# computadoras es una razón importante; otra, es que muchos teoremas sobre
# el error que se comente con operaciones de punto flotante son proporcionales
# a $\beta$, por lo que $\beta=2$ minimiza dichos errores. Aún así, se han
# usado otros formatos no binarios. Otra razón, aún más sutil, es que con
# $\beta=2$ se puede *ganar* un bit más de precisión ya que el primer bit
# de la mantisa se puede omitir. En efecto, si son números normales el primer
# bit de la mantisa siempre es 1, y si son subnormales el primer bit es siempre 0.

# El estándar define cuatro modos de precisión (sencilla, doble, sencilla extendida
# y doble extendida), pero aquí nos enfocaremos a la precisión sencilla y sobretodo
# a la doble.
# El estándar requiere $p=24$ para precisión sencilla, con 8 bits para el exponente
# (32 bits, incluyendo el bit del signo y el bit omitido de la mantisa) y $p=53$ para
# precisión doble, con 11 bits para el exponente. El
# estándar especifica además el arreglo de los bits: el primer bit es el del signo,
# después vienen los bits del exponente y, finalmente, los bits de la mantisa (que
# omiten el bit $b_0$).

# El exponente en precisión sencilla se define de tal manera que se cubra el
# rango de exponentes desde $e_\min=-126$ hasta $e_\max=127$; para precisión doble
# se tiene $e_\min=-1022$ y $e_\max=-1023$. Como estos exponentes pueden ser
# positivos o negativos, se necesita una forma para representar el signo. El estándar
# utiliza lo que se llama una representación sesgada (*bias representation*),
# y el exponente del número de punto flotante se determina sumando el sesgo. Para
# precisión sencilla el sesgo es 127, y para la doble es 1023. Lo que esto
# significa es que si $\tilde{e}$ es el valor representado por los bits del
# exponente, el valor del exponente que de facto se considera es
# $e = \tilde{e}-127$ para precisión sencilla, o $e=\tilde{e}-1023$ para precisión
# doble. Al exponente $e$ se le llama exponente sin sesgo.

# Usando la convención del exponente señalada arriba, el exponente $e_\min-1$ se usa
# para representar al 0 y también los números denormalizados (subnormales), y
# $e_\max+1$ par definir cantidades especiales (`Inf`, con mantisa 0, y `NaN` en
# cualquier otro caso).

# El estándar también requiere que las operaciones aritméticas (suma, resta, multiplicación
# y división) sean hechas usando el *redondeo exacto*. El estándar también establece que
# la raíz cuadrada, el residuo y la conversión de enteros a punto flotante sean
# correctamente redondeadas.

# El estándar cubre también otras cuestiones, un poco más sutiles y por ahora menos
# importantes. Sin embargo, es importante ser consciente de ellas. Es por esto que sugiero
# leer:
# > "What every computer scientist should know about floating-point arithmetic"
# > D. Goldberg, ACM Comput. Surv. 23(1), 5-48, Mar. 1991. doi:10.1145/103162.103163
# Algunas ligas donde pueden encontrar el artículo son:
# [ACM Computing Surveys](https://dl.acm.org/doi/10.1145/103162.103163),
# [aquí](https://ece.uwaterloo.ca/~dwharder/NumericalAnalysis/02Numerics/Double/paper.pdf) o
# [aquí](https://www.itu.dk/~sestoft/bachelor/IEEE754_article.pdf)

# ## Ejercicio
#
# La idea es implementar, usando lo que sabemos de Julia, funciones que conviertan
# un número de punto flotante (`Float64` o `Float32`) a una cadena que represente
# la representación del estándar IEEE-754 de dicho número.
# Esencialmente lo que tenemos que hacer es, dado un valor `x`, convertirlo a su
# representación binaria, y dicha representación escribirla en el formato del estándar,
# es decir, factorizar el exponente y a partir de ahí, escribir la mantisa.
#
# Si requieren un poco de guía para saber si van por buen camino, pueden
# utilizar [esta liga](https://bartaz.github.io/ieee754-visualization/).
#
