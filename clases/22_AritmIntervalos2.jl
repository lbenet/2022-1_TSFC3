#-
# # Aritmética de intervalos: calculando con conjuntos 2

#-
# > Ref: W. Tucker, Validated Numerics: A Short Introduction to Rigorous Computations, Princeton University Press, 2011

#-
# ## Aritmética de intervalos en $\mathbb{R}$

#-
# Podemos visualizar a los elementos de $\mathbb{IR}$ no sólo como conjuntos, sino además
# como una generalización de los números reales; es por esto que tiene sentido establecer
# la aritmética en $\mathbb{IR}$.
#
# La manera más directa es definir las operaciones aritméticas
# (binarias) en base a la teoría de conjuntos. Así, el resultado de las operaciones binarias
# aritméticas entre intervalos debe incluir todos los posibles resultados que involucren
# a todo elemento de cada uno de los intervalos, en el orden correspondiente.
# Esto es, si $\star$ es cualquier operador aritmético binario, $+$, $-$, $\times$ o $\div$,
# entonces
# ```math
# \begin{equation*}
# [a] \star [b] = \left\{ a \star b, \forall a \in [a], b \in [b]\right\},
# \end{equation*}
# ```
# con la excepción de que $[a] \div [b]$ está *indefinido* si $0\notin [b]$.

#-
# La definición anterior no hace evidente que el resultado es *siempre* un intervalo. El hecho
# de que usamos sólo intervalos cerrados, permite usar los bordes de los intervalos para
# obtener los resultados de las operaciones aritméticas. Uno puede establecer que:
#
# ```math
# \begin{align*}
# [a] + [b] & = [ \underline{a}+\underline{b}, \overline{a}+\overline{b} ],\\
# [a] - [b] & = [ \underline{a}-\overline{b}, \overline{a}-\underline{b} ],\\
# [a] \times [b] & = [
# \min(\underline{a}\underline{b}, \overline{a}\underline{b}, \underline{a}\overline{b}, \overline{a}\overline{b}),
# \max(\underline{a}\underline{b}, \overline{a}\underline{b}, \underline{a}\overline{b}, \overline{a}\overline{b}) ],\\
# [a] \div [b] & = [a] \times [1/\overline{b}, 1/\underline{b}], \quad\textrm{si }0\notin [b].\\
# \end{align*}
# ```
#
# Vale la pena mencionar que, para entender los resultados anteriores el concepto de
# monoticidad aparece, y el hecho de que si fijamos uno de los valores que se operan,
# las operaciones aritméticas son monótonas respecto al otro. La monoticidad
# es importante ya que permite usar sólo los valores extremos del intervalo para
# obtener el resultado de la operación. Además, la división puede
# ser *extendida* si el denominador incluye al 0, si permitimos incluir entre los números reales
# al infinito.

#-
# Consecuencias de las definiciones anteriores es que se cumplen las propiedades conmutativa y
# asociativa para la adición y la multiplicación. Además, es fácil convencerse que $[0,0]$ y
# $[1,1]$ son los elementos (únicos) neutros respecto a la adición y multiplicación, respectivamente.
#
# Sin embargo, *en general* no existe el elemento neutro bajo la suma o el producto. Por ejemplo,
# si usamos las definiones de arriba, obtenemos que $[1,3]-[1,3] = [-2,2]\neq [0,0]$, y
# $[1,3]\div[1,3] = [1/3,3]\neq [1,1]$.
#
# Una consecuencia importante de esto es que la propiedad distributiva *no siempre* se cumple,
# pero lo que se cumple es la *propiedad subdistributiva*:
# ```math
# \begin{equation*}
# [a] \times ([b]+[c]) \subseteq [a]\times [b] + [a] \times [c].
# \end{equation*}
# ```

#-
# Otra propiedad importante en aritmética de intervalos es la monotonicidad de inclusión
# (*inclusion monotonicity*): Si $[a]\subseteq [a']$ y $[b]\subseteq [b']$, y
# $\star \in \{+, -, \times, \div\}$, entonces
# ```math
# \begin{equation*}
# [a] \star [b] \subseteq [a'] \star [b'],
# \end{equation*}
# ```
# donde se asume que para la división $0\notin [b']$.

#-
# ## Aritmética de intervalos *extendida*

#-
# El hecho de que tengamos que excluir $0$ del denominador al hacer una división es
# algo incómodo.
# Una manera de darle la vuelta a esto es pensando que
# el resultado de $[c] = [a]\div [b]$ es el conjunto
# ```math
# \begin{equation*}
# [c] = \left\{ c\in\mathbb{R}: a = bc, a\in[a], b\in[b] \right\}.
# \end{equation*}
# ```

#-
# Consideremos $[a] = [1,2]$ y $[b]=[-1,1]$. Separamos $[b]$, en el sentido de
# conjuntos como $[b]=[-1,0)\cup[0]\cup(0,1]$. Usando la definición anterior para $[c]$,
# la ecuación $0\cdot c \in [a]$ no tiene sentido, por lo que ignoramos ese caso. Entonces
# tenemos
# ```math
# \begin{equation*}
# [c] = \left\{ c\in\mathbb{R}: a\in [1,2], b\in[-1,0) \right\}
# \cup
# \left\{ c\in\mathbb{R}: a\in [1,2], b\in(0,1] \right\}
# = (-\infty, -1] \cup [1,\infty),
# \end{equation*}
# ```
# es decir, $\mathbb{R}$ \\ $(-1,1)$.
#
# Claramente, para poder tener a cero en el denominador en una división, requerimos
# la noción de infinito en $\mathbb{R}$.

#-
# En la *extensión proyectiva*, uno considera la compactificación de $\mathbb{R}$ en
# el círculo, al considerar la intersección sobre el círculo de la recta que une al
# punto $x\in\mathbb{R}$ con el polo norte del círculo. Esto introduce un nuevo
# punto, cuya proyección es el polo norte, que identificamos con el infinito (¡sin signo!).
# Esta extensión, $\mathbb{R}^*$,  permite que podamos escribir $[c]$ en el ejemplo de arriba
# como un *intervalo extendido*, $[1, -1]$, donde este intervalo se entiende como
# los puntos en que $x\ge 1$ o $x\le 1$.
#
# La *extensión afín* consiste en dotar de signo a infinito en la extensión de los reales,
# y se denota como $\overline{\mathbb{R}}$. Esto permite extender $\mathbb{R}$
# para que los intervalos $[2,+\infty]$ o $[-\infty, +\infty]$ tengan sentido. Esta es
# la extensión que solemos, ingenuamente, usar. En este caso, $[c]$ no es un intervalo,
# pero la división se puede extender resultando en la unión de dos intervalos bien definidos.
# El conjunto de intervalos formados por esta extensión de los reales se denota
# $\overline{\mathbb{IR}}$.
#
# Finalmente, mencionamos la *extensión del cero con signo*, y que ha sido empujada por
# los manufacturadores de computadoras, y que es la que usaremos en cuestiones numéricas.
# Lo ``feo'' de esta extensión es que al incluir un signo para el cero, $+0$ y $-0$
# son distintos números reales aunque se comparen igual. Una ventaja es que $+\infty$ y
# $-\infty$ tendrán un inverso # bien definido y distinto en cada caso.
#
# Vale la pena mencionar que en cualquiera de estas extensiones, operaciones como
# $(\pm)\infty-(\pm)\infty$, $(\pm)\infty/(\pm)\infty$, o $(\pm)0\cdot (\pm)\infty$ son
# indefinidas.

#-
# La división se puede extender si uno considera estas extensiones de los reales. El resultado
# en los casos en que el denominador incluye el cero se vuelve más cómoda en
# $\overline{\mathbb{IR}}$, aunque en varios casos el resultado corresponde a la unión de
# intervalos.
#
# ```math
# [a]\div[b] = \begin{cases}
# \begin{align*}
# & [a] \times [1/\overline{b}, 1/\underline{b}], &\textrm{si }& 0\notin [b], \\
# & [-\infty,+\infty], &\textrm{si }& 0\in[a] \textrm{ y } 0\in[b], \\
# & [\overline{a}/\underline{b}, +\infty], &\textrm{si }& \overline{a}<0 \textrm{ y } \underline{b}<\overline{b}=0, \\
# & [\overline{a}/\underline{b},+\infty]\cup[-\infty,\overline{a}/\overline{b}], &\textrm{si }& \overline{a}<0 \textrm{ y } \underline{b}<0<\overline{b}, \\
# & [-\infty, \overline{a}/\overline{b}], &\textrm{si }& \overline{a}<0 \textrm{ y } 0=\underline{b}<\overline{b}, \\
# & [-\infty, \underline{a}/\underline{b}], &\textrm{si }& 0<\underline{a} \textrm{ y } \underline{b}<\overline{b}=0, \\
# & [\underline{a}/\overline{b}, +\infty]\cup[-\infty,\underline{a}/\underline{b}], &\textrm{si }& 0<\underline{a} \textrm{ y } \underline{b}<0<\overline{b}, \\
# & [\underline{a}/\overline{b}, +\infty], &\textrm{si }& 0<\underline{a} \textrm{ y } 0=\underline{b}<\overline{b}, \\
# & [\emptyset], &\textrm{si }& 0\notin [a] \textrm{ y } [b]=[0,0].\\
# \end{align*}
# \end{cases}
# ```

#-
# Esta definición de la división extendida, puede demostrarse, es monótona de inclusión.
# Además, permite evitar los errores al dividir por cero.
# Finalmente, y como veremos adelante, ciertos algoritmos como el método de Newton
# para intervalos, utilizan la división extendida.

#-
# ## Conjuntos contenedores

#-
# Al trabajar con intervalos, la evaluación de ciertas funciones *inocentes* puede llevar
# a problemas conceptuales. Por ejemplo, consideremos la función $f(x) = \sqrt{x-x^2}$, con
# $x\in[0,1]$. Es fácil convencerse que el rango de esta función es $R(f; [0,1))=[0,1/\sqrt{2}]$.
# Sin embargo, el uso *ingenuo* de intervalos puede llevar a situaciones raras. Por ejemplo,
# evaluar directamente usando intervalos lleva a
# $F([0,1])=\sqrt{[0,1]-[0,1]^2}=\sqrt{[0,1]-[0,1]}=\sqrt{[-1,1]}$, que es problemático.

#-
# Una manera de salir de esta situación es considerando el *dominio natural* de las funciones
# involucradas, y tomar la intersección del resultado con intervalos y el dominio natural.
# En el ejemplo anterior esto significa $\sqrt{x} = \sqrt{[x]\cap[0,+\infty]}$, lo que nos
# lleva a $F([0,1])=\sqrt{[-1,1]\cap[0,+\infty]}=[0,1]$. Vale la pena notar que,
# si bien no obtuvimos al intervalo que acota al rango, tenemos que
# $R(f,[0,1])\subseteq F([0,1])$.

#-
# La manera de proceder anterior que incluye la evaluación de la intersección con el dominio
# natural de las funciones es lo que se llama *conjuntos contenedores*. La ventaja de usar
# conjuntos contenedores es que las evaluaciones no tienen excepciones (errores).
