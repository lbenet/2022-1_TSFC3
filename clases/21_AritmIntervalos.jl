#-
# # Aritmética de intervalos: calculando con conjuntos

#-
# > Ref: W. Tucker, Validated Numerics: A Short Introduction to Rigorous Computations, Princeton University Press, 2011

#-
# ## Motivación

#-
# Aquí, describiremos brevemente qué es y cómo implementar la
# aritmética de intervalos.

#-
# Básicamente, la aritmética de intervalos es una aritmética de
# desigualdades. Esto es, buscamos *acotar* la respuesta exacta
# a través de una cota inferior y de una superior, las cuales
# son calculadas en la computadora (con números de punto flotante
# incluyendo el redondeo adecuado).

#-
# La motivación básica para esto es el hecho de que los números de
# punto flotante no son continuos. Entonces, la respuesta exacta se
# encuentra, en general, entre dos números de punto flotante.
#
# ![](./imagenes/FPprec2.png)

#-
# Consideremos por ejemplo el cálculo del área de un rectángulo,
# $A=a\cdot b$, del que conocemos a través de mediciones, la
# longitud de sus lados $a=3.1\pm 0.2$ y $b=10\pm 0.1$. Estas
# mediciones las podemos interpretar como desigualdades,
# $2.9 \le a \le 3.3$, $9.9 \le b \le 10.1$, de donde obtenemos
# $28.71 = 2.9\cdot 9.9 \le A \le 33.33 = 3.3 \cdot 10.1$.

# De manera equivalente, podemos pensar los lados del rectángulo
# como intervalos, $[a]=[3.1,3.3]$ y $[b]=[9.9, 10.1]$, y el
# el área del triángulo como $[A] = [a]\cdot [b]$. La aritmética
# de intervalos justifica este tipo de extensión.

#-
# ## Intervalos como conjuntos

#-
# Los elementos básicos de la aritmética de intervalos son
# los intervalos, que definiremos como subconjuntos *cerrados* y
# *acotados* de la recta real. Usaremos la siguiente notación:
# ```math
# \begin{equation*}
# [a] = [\underline{a}, \overline{a}] = \left\{ x\in \mathbb{R} :
# \underline{a} \le x \le \overline{a} \right\}.
# \end{equation*}
# ```

#-
# El conjunto de todos estos intervalos lo denotaremos
# ```math
# \begin{equation*}
# \mathbb{IR} = \left\{ [\underline{a},\overline{a}] :
# \underline{a} \le \overline{a}; \;
# \underline{a}, \overline{a} \in \mathbb{R} \right\}.
# \end{equation*}
# ```

#-
# Vale la pena notar que en esta definición permitimos tener
# intervalos ``degenerados'' $[a]$ en los que
# $\underline{a}=\overline{a}$; nos referiremos a estos intervalos
# como intervalos delgados.

#-
# De la definición anterior, claramente $[-3,4]$ y $[\pi,\pi^2]$
# pertenecen a $\mathbb{IR}$, pero no $(2,3]$, $[2,-1]$ *ni*
# tampoco $[-\infty,0]$. Más adelante veremos que es conveniente
# extender nuestra definición de $\mathbb{IR}$ para que incluya al último
# ejemplo; hay también extensiones que buscan incluir a los otros ejemplos.

#-
# Dado que son conjuntos, los elementos de $\mathbb{IR}$ heredan
# las relaciones naturales entre conjuntos, esto es, las operaciones
# $=$, $\subseteq$, $\subset$, que se definen como:
# ```math
# \begin{align*}
# [a] = [b] & \Leftrightarrow  \underline{a}=\underline{b}
#     \textrm{ and } \overline{a}=\overline{b},\\
# [a] \subseteq [b] & \Leftrightarrow  \underline{a}\le \underline{b}
#     \textrm{ and } \overline{a} \le\overline{b},\\
# [a] \subset [b] & \Leftrightarrow  [a] \subseteq [b] \textrm{ and } [a] \neq [b],\\
# [a] \subsetdot [b] & \Leftrightarrow  \underline{a} < \underline{b}
#     \textrm{ and } \overline{a} < \overline{b},\\
# \end{align*}
# ```

#-
# Podemos *ordenar* parcialmente el conjunto $\mathbb{IR}$ de distintas formas.
# Una de éstas es preservando el orden natural de los números reales,
# a través de $\le$
# ```math
# \begin{equation*}
# [a] \le [b] \Leftrightarrow \underline{a}\le\underline{b} \textrm{ and }
# \overline{a}\le\overline{b}.
# \end{equation*}
# ```
# El orden así definido es parcial, ya que se puede mostrar que hay intervalos en
# los que $[a]\nleq [b]$ y $[b]\nleq [a]$.

#-
# Tiene además sentido usar la notación $a\in[b]$ cuando se cumple
# $\underline{b}\leq a \leq \overline{b}$.

#-
# Podemos extender las nociones de conjuntos $\cup$ y $\cap$ a $\mathbb{IR}$,
# aunque ambas requieren ciertos ajustes. Por ejemplo, la unión de dos
# intervalos puede no definir un intervalo cuando los dos intervalos están
# suficientemente separados (disjuntos). Usamos el concepto de *hull* (cáscara) para
# resolver esta situación
# ```math
# \begin{equation*}
# [a] \sqcup [b] = [\min(\underline{a},\underline{b}), \max(\overline{a}, \overline{b})].
# \end{equation*}
# ```
# Es claro que el conjunto que resulta *incluye* a la unión de los conjuntos.

# Para extender la intersección entre dos intervalos es necesario agregar
# el conjunto vació a $\mathbb{IR}$, cuya extensión denotaremos $[\emptyset]$,
# para el caso en que los intervalos sean disjuntos. Con esto, definimos a la
# intersección como:
# ```math
# \begin{equation*}
# [a] \cap [b] =
# \begin{cases}
# [\emptyset], & \overline{b}<\underline{a} \textrm{ o } \overline{a}<\underline{b}, \\
# [\max(\underline{a},\underline{b}), \min(\overline{a},\overline{b})], & \textrm{ en otros casos.}
# \end{cases}
# \end{equation*}
# ```

#-
# Dado un intervalo $[a]$, definimos las siguientes funciones reales:
# ```math
# \begin{align*}
# \textrm{rad}(a) & = \frac{1}{2}(\overline{a}-\underline{a}), \;\textrm{radio de }a,\\
# \textrm{mid}(a) & = \frac{1}{2}(\underline{a}+\overline{a}), \;\textrm{punto medio de }a,\\
# \textrm{mag}([a]) & = \max\left\{ |x|: x\in [a]\right\}, \;\textrm{magnitud de }a,\\
# \textrm{mig}([a]) & = \min\left\{ |x|: x\in [a]\right\}, \;\textrm{mignitud de }a.\\
# \end{align*}
# ```
# Las dos últimas funciones definen cuál es la máxima y mínima distancia del cero (origen)
# a los elementos del intervalo $[a]$. Claramente, si $0\in[a]$, $\textrm{mig}(a)=0$.

#-
# Combinando las dos últimas funciones, podemos definir
# ```math
# \begin{equation*}
# \abs([a]) = \left\{ |x|: x\in[a] \right\} = [\textrm{mig}([a]), \textrm{mag}([a])].
# \end{equation*}
# ```
# Vale la pena notar que, al contrario de las funciones previamente definidas,
# $\abs([a])$ es un intervalo.

#-
# Usando las definiciones anteriores, podemos hacer de $\mathbb{IR}$ un espacio métrico,
# al definir la distancia de Hausdorff
# ```math
# \begin{equation*}
# d([a],[b]) = \max(|\underline{a}-\underline{b}|, |\overline{a}-\overline{b}|)
# \end{equation*}
# ```
# De esta definición tenemos que $d([a],[b])=0$ si y sólo si $[a]=[b]$.

#-
# Usando la métrica se puede definir la noción de una secuencia convergente para intervalos,
#
# ```math
# \begin{align*}
# \lim_{k\to\infty}[a_k] = [a] & \Leftrightarrow \lim_{k\to\infty} d([a_k],[a]) = 0 \\
#  & \Leftrightarrow \left( \lim_{k\to\infty} \underline{a}_k = \underline{a}\right)
#  \textrm{ y } \left( \lim_{k\to\infty} \overline{a}_k = \overline{a}\right)
#  \textrm{ y } \left( \textrm{ para toda }k, \underline{a}_k \le \overline{a}_k\right)
# \end{align*}
# ```

