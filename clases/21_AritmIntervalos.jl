#-
# # Aritmética de intervalos: calculando con conjuntos 1

#-
# > Ref: W. Tucker, Validated Numerics: A Short Introduction to Rigorous Computations, Princeton University Press, 2011

#-
# ## Motivación

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
# $28.71 = 2.9\cdot 9.9 \le A \le 33.33 = 3.3 \cdot 10.1$. Esto mismo
# lo podemos escribir como $A=31.02\pm 2.31$.

# De manera equivalente, podemos pensar los lados del rectángulo
# como intervalos, $[a]=[3.1,3.3]$ y $[b]=[9.9, 10.1]$, y el
# el área del triángulo como $[A] = [a]\cdot [b]$. La aritmética
# de intervalos justifica esta extensión.

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
# $=$, $\subseteq$, $\subset$, ⪽ (está en el interior), que se definen como:
# ```math
# \begin{align*}
# [a] = [b] & \Leftrightarrow  \underline{a}=\underline{b}
#     \textrm{ y } \overline{a}=\overline{b},\\
# [a] \subseteq [b] & \Leftrightarrow  \underline{b}\le \underline{a}
#     \textrm{ y } \overline{a}\le\overline{b},\\
# [a] \subset [b] & \Leftrightarrow  [a] \subseteq [b] \textrm{ y } [a] \neq [b],\\
# [a] ⪽ [b] & \Leftrightarrow  \underline{b} < \underline{a}
#     \textrm{ y } \overline{a} < \overline{b},\\
# \end{align*}
# ```

#-
# Podemos *ordenar* parcialmente el conjunto $\mathbb{IR}$ de distintas formas.
# Una de éstas es preservando el orden natural de los números reales,
# a través de $\le$, de la siguiente forma:
# ```math
# \begin{equation*}
# [a] \le [b] \Leftrightarrow \underline{a}\le\underline{b} \textrm{ y }
# \overline{a}\le\overline{b}.
# \end{equation*}
# ```
#
# Vale la pena notar que la definición anterior se puede formular como el
# conjunto
# ```math
# \begin{equation*}
# [a] \le [b] = \left\{ (\forall a\in [a] \ \exists b\in[b]) \textrm{, y }
# (\forall b\in [b] \ \exists a\in[a]) : a\le b \right\}.
# \end{equation*}
# ```
# El orden así definido es parcial, ya que se puede mostrar que hay intervalos en
# los que $[a]\nleq [b]$ y $[b]\nleq [a]$.

#-
# Tiene además sentido usar la notación $a\in[b]$ cuando se cumple
# $\underline{b}\leq a \leq \overline{b}$.

#-
# Podemos extender las nociones de unión e intersección de conjuntos, $\cup$ y $\cap$,
#  a $\mathbb{IR}$, # aunque ambas requieren ciertos ajustes. Por ejemplo, la unión de dos
# intervalos puede no definir un intervalo cuando los dos intervalos están
# suficientemente separados (son disjuntos). Usamos el concepto de *hull* (cáscara) para
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

#-
# Las dos últimas funciones definen cuál es la distancia máxima y mínima del cero (origen)
# a los elementos del intervalo $[a]$. Claramente, si $0\in[a]$, $\textrm{mig}(a)=0$.

#-
# Combinando las funciones anteriores, podemos definir
# ```math
# \begin{equation*}
# \textrm{abs}([a]) = \left\{ |x|: x\in[a] \right\} = [\textrm{mig}([a]), \textrm{mag}([a])].
# \end{equation*}
# ```
# Vale la pena notar que, al contrario de las funciones previamente definidas,
# $\textrm{abs}([a])$ es un intervalo.

#-
# Con las funciones anteriores podemos escribir
# ```math
# \begin{equation*}
# [a] = [ \textrm{mid}([a])-\textrm{rad}([a]), \textrm{mid}([a])+\textrm{rad}([a])],
# \end{equation*}
# ```
# de donde tenemos
# ```math
# \begin{equation*}
# x \in [a] \Leftrightarrow |x-\textrm{mid}([a])|\le \textrm{rad}([a]).
# \end{equation*}
# ```


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
# Usando esta métrica se puede definir la noción de una secuencia convergente para intervalos,
#
# ```math
# \begin{align*}
# \lim_{k\to\infty}[a_k] = [a] & \Leftrightarrow \lim_{k\to\infty} d([a_k],[a]) = 0 \\
#  & \Leftrightarrow \left( \lim_{k\to\infty} \underline{a}_k = \underline{a}\right)
#  \textrm{ y } \left( \lim_{k\to\infty} \overline{a}_k = \overline{a}\right)
#  \textrm{ y } \left( \textrm{ para toda }k, \underline{a}_k \le \overline{a}_k\right)
# \end{align*}
# ```

