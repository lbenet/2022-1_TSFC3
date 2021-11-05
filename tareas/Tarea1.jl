# # Tarea 1

#-
# > **Fecha de entrega** (aceptación del *Pull Request*): Jueves 11 Noviembre
#

#-
# > **NOTA:** Esta tarea requiere que suban código (el archivo `intervalos.jl`)
# > *únicamente*, que deberá estar en un subdirectorio de `tareas/`. Ese archivo
# > debe estar adecuadamente documentado o, al menos, comentado.
#

#-
# ### Ejercicio 1: Módulo `Intervalos`
#
# - Definan la estructura `Intervalo`, que debe funcionar para `Float64` y `BigFoat`. El uso de
#     `Intervalo(a)` debe ser posible y equivalente a `Intervalo(a,a)`. Definan qué hacer si el `Intervalo`
#     no está correctamente definido (por ejemplo, el ínfimo es mayor que el supremo).
#
# - Definan la función `intervalo_vacio`, que devuelve al `Intervalo` que no tiene elementos; piensen cómo
#     definir el intervalo vacío y qué hacer para que su estructura permita definir a este intervalo especial.
#
# - Extiendan las relaciones de conjuntos `==`, `issubset` (`⊆`), `isinterior` (`⪽`), `in` (`∈`),
#     `hull` (`⊔`), `intersect` (`∩`) para usarlas con intervalos. Noten que los símbolos `⪽` y `⊔`
#     no existen en Julia y los usaremos. La función `union` (`∪`) háganla sinónimo de `hull`.
#
# - Extiendan las funciones aritméticas (`+`, `-`, `*`, `/`); por ahora no nos ocuparemos del redondeo. Sin embargo,
#     asegúrense que las operaciones, cuando tenga sentido, pueden involucrar números enteros, `Float64` o `BigFoat`,
#     entre otros, o sea, `<:Real`, o incluso sólo un intervalo.
#
# - Extiendan las potencias enteras para intervalos; consideren por ahora sólo potencias enteras.
#
# - El código escrito debe estar dentro de un *módulo* de Julia llamado `Intervalos`, y éste deberá incluirse en el
#     archivo `intervalos.jl`, que contiene todas las definiciones anteriores.
#

#-
# ### Ejercicio 2: Tests
#
# Asegúrense que lo desarrollado en el Ejercicio 1 *pase* las pruebas que se encuentran en el archivo
# `tareas/Tests/test1_nr.jl`. Para verificar esto, lo que deben hacer es (desde el REPL) en el directorio
# principal del repositorio,
# ```julia
#     include("tareas/SuDirTarea1/intervalos.jl")
#     include("tareas/Tests/test1_nr.jl")
# ```
# y esto debe **no** arrojar ningún error. (Eventualmente automatizaremos este tipo de pruebas.)
