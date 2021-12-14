# # Tarea 3

#-
# > **Fecha de entrega** (aceptación del *Pull Request*): 10 enero, 2022
#

#-
# **NOTA:** Lo que se pide en esta tarea deberá satisfacer los tests `Tests/test3.jl`,
# que incluyen varios aspectos que se piden. Las funciones deberán ser exportadas
# desde el módulo `Intervalos` de forma apropiada.
#

#-
# ### Ejercicio 1: `Intervalo` y `ForwardDiff`
#
# Modifiquen su estructura `Intervalo` de tal manera que uno pueda calcular derivadas
# usando `ForwardDiff.derivate(f, dom)`, con `dom` un `Intervalo`. El requisito básico
# que `ForwardDiff` impone es que el tipo (en este caso `Intervalo`) sea un subtipo de `Real`.
# Carguen `ForwardDiff` desde su módulo para intervalos. Resulta que también será necesario
# sobrecargar dos funciones más; chequen los tests que no pasan y traten de entender los errores
# que aparecen.

#-
# ### Ejercicio 2: Checando monotonicidad
#
# Escriban una función `esmonotona(f,D)` que verifique si una función $f(x)$ es
# monótona en el intervalo $D$, explotando `ForwardDiff` para esto. El resultado de la
# función debe ser `true` o `false`, es decir, del tipo `Bool`. Incluyan esta función
# en `intervalos.jl`.

#-
# ### Ejercicio 3: Método de Newton intervalar extendido en 1d
#
# - Definan una estructura `Raiz` que incluya dos campos, `raiz::Intervalo{T}` y `unicidad::Bool`.
#    Consideren que *puede* ser útil parametrizar el tipo.
# - Escriban una o varias funciones que permitan implementar el método de Newton intervalar
#    para la función (unidimensional) `f`, dentro del dominio `dom::Intervalo`, con tolerancia
#    `tol`; se deberá exportar la función `ceros_newton(f, dom, tol)`.
#    El método debe arrojar *todos* los intervalos que son candidatos a incluir una raíz
#    (hasta cierta tolerancia) a través
#    de un *vector* del tipo `Raiz`, que incluye información sobre la unicidad de la raíz
#    en el intervalo dado. El diámetro de los intervalos dentro del vector deberá ser menor que
#    cierta tolerancia `tol`.
#    Documenten apropiadamente cada una de las funciones que implementen.
# - El código que corresponde a este ejercicio deberá escribirse en el archivo `raices.jl`.
#    Este archivo deberá ser llamado (`include`) dentro del archivo `intervalos.jl`; exporten
#    las funciones que sean necesarias.
#  - Recuerden que es útil filtrar los resultados de manera apropiada.
#

#-
# ### Ejercicio 4: Optimización
#
# El objetivo de este ejercicio es escibir una función `minimiza(f, D)` que encuentre el
# mínimo global de la función $f(x)$ en el dominio $D\subset\mathbb{R}$. Esto es, queremos
# obtener el valor $y^*$ que es el ínfimo de la función en $D$, y el lugar en que esto ocurre,
# es decir, $x^*$. Supondremos que $f(x)$ es continua en $D$, y que $D$ es un intervalo (conjunto
# compacto).
#
# La idea del método es fijar un valor $\tilde{y}$, que es la cota *superior* de prueba para $y^*$
# con la que se trabaja (y que se irá ajustando), y excluir subconjuntos de $D$ en que
# se satisface $f(x) > \tilde{y}$, es decir, que no incluyen un mínimo global de $f$.
# Inicializaremos el método considerando $E^{(0)}=D$ y
# $y^*=+\infty$. En el paso $k$ tendremos $y^*\leq \tilde{y}^{(k)}$ y los candidatos
# ```math
# E^*\subseteq \{ x\in D: f(x)\leq \tilde{y}^{(k)}\} \subseteq E^{(k)} = \bigcup_{i=1}^{N_k}D_i^{(k)},
# ```
# del conjunto que minimiza. Para cada uno de estos candidatos $D_i^{(k)}$ procederemos así:
# - Calculamos $[y_i]=F(D_i^{(k)})$.
# - Verificamos si se cumple $\tilde{y}^{(k)} < \underline{y}_i$.
#    Si es el caso, eliminamos el intervalo $D_i^{(k)}$. De lo contrario, calculamos el valor
#    de la función en el punto medio, $m_i=f\big(\textrm{mid}(D_i^{(k)})\big)$ y lo comparamos con
#    $\tilde{y}^{(k)}$. Si $m_i<\tilde{y}^{(k)}$ y asignamos $\tilde{y}\leftarrow m_i$.
#    Independientemente de la comparación que involucra $m_i$, bisectamos $D_i^{(k)}$, y
#    añadimos los intervalos a la lista de candidatos.
# - Estos pasos se repiten para cada elemento de la lista de candidatos $D_i^{(k)}$.
#    Una vez que se concluye se fija $\tilde{y}^{(k+1)}=\tilde{y}$.
# - El proceso se repite hasta que se satisfaga un criterio para parar el algoritmo definiendo
#    una tolerancia. En este caso, definiremos el criterio usando el diámetro de los intervalos
#    $D_i^{(k)}$.
#  - Explotando la función `minimiza`, escriban una función `maximiza`.
#
# Todas las funciones que requieran para completar este ejercicio deberán ser incluidas en el
# archivo `optimizacion.jl`, que deberá ser llamado desde `intervalos.jl`. Documenten todas las
# funciones que escriban.
