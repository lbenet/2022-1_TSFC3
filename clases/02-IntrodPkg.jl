# # Manejo de Paquetes (Pkg)

# Julia tiene un potente manejador de paquetes, [`Pkg`](https://docs.julialang.org/en/v1/stdlib/Pkg/),
# que está concebido para permitir
# la reproducibilidad del código, entre otras propiedades. Hay varias paqueterías que
# están incluidas en Julia, pero separadas del lenguaje que se carga por default, y éstas
# constituyen lo que se llama la librería estándard (*standard library*). Esto es, son
# paqueterías que *no* debemos instalar, pero sí se deben cargar si se necesitan.

# Empezaremos cargando `Pkg`, una de estas librerían estándard, para lo que usaremos
# la instrucción `using`.

using Pkg

# Lo que haré a continuación es *definir* un proyecto, el del curso, que incluirá todas
# las paqueterías que (por ahora) nos serán necesarias para empezar, y que poco a poco
# iremos ampliando. Para hacer esto, "activaremos" el directorio local e "instanciaremos"
# (*instantiate* en inglés) el repositorio, lo que creará los archivos "Project.toml" y "Manifest.toml",
# que son la base de la reproducibilidad en Julia. Subiéndolos a GitHub, en principio tendremos
# todos los archivos necesarios, para hacer que todo funcionen las cosas de igual manera para todos.

Pkg.activate(".")  # Activa el directorio "." respecto al lugar donde estamos

# En la instrucción anterior, estamos ejecutando la función `activate`, del módulo `Pkg`,
# que vive dentro de él y que no se exporta.

# Ahora, instanciaremos el repositorio; lo que esto hace es actualizar los archivos
# "Project.toml" y "Manifest.toml".

Pkg.instantiate() # crea/actualiza los archivos "Project.toml" y "Manifest.toml"

# Ahora *instalaremos* una paquetería que usaremos para *generar* los notebooks del curso:
# [Literate.jl](https://github.com/fredrikekre/Literate.jl):

Pkg.add("Literate")

# La instrucción anterior instala la paquetería `Literate.jl` en el proyecto del curso;
# además, actualiza "Project.toml" con la información de la paquetería que se instaló (como dependencia)
# y "Manifest.toml" con todas las dependencias que puede requerir `Literate`, y con la información
# de las versiones. Otras paqueterías se instalan de la misma manera usando `Pkg.add`.

# Otra paquetería muy útil para poder visualizar con Jupyter Lab los notebooks,
# es `IJulia`. La instalamos de la misma manera:

Pkg.add("IJulia")

#-

Pkg.build("IJulia")  # Esto lo deben rehacer si actualizan IJulia

# Para saber qué paquetes tenemos instalados, usamos `Pkg.status()`.

Pkg.status()

# Cuando iniciemos cualquier actividad del curso, será importante activar nuevamente
# el projecto, lo que esencialmente permitirá *cargar* (con `using`) las librerías
# que usaremos.

# Nota: Muchos de los comandos anteriores se simplifican desde el REPL (sesión de
# Julia en la terminal) donde `]` (al principio de la línea de comando) da entrada
# al modo de trabajo con los paquetes. En este caso, al entrar a este modo, haremos:
# ```julia
# (@v1.6) pkg> activate .
#   Activating new environment at `~/Documents/4-Clases/46-TemasSelectos/2022-1/Project.toml`
#
# (2022-1) pkg> instantiate
#     Updating registry at `~/.julia/registries/General`
#   No Changes to `~/Documents/4-Clases/46-TemasSelectos/2022-1/Project.toml`
#   No Changes to `~/Documents/4-Clases/46-TemasSelectos/2022-1/Manifest.toml`
#
# (2022-1) pkg> add Literate
#    Resolving package versions...
#    Installed Literate ─ v2.9.3
#     Updating `~/Documents/4-Clases/46-TemasSelectos/2022-1/Project.toml`
#   [98b081ad] + Literate v2.9.3
#     Updating `~/Documents/4-Clases/46-TemasSelectos/2022-1/Manifest.toml`
#   [b5f81e59] + IOCapture v0.2.2
#   [682c06a0] + JSON v0.21.2
#   [98b081ad] + Literate v2.9.3
#   [69de0a69] + Parsers v2.0.3
#   [2a0f44e3] + Base64
#   [ade2ca70] + Dates
#   [b77e0a4c] + InteractiveUtils
#   [56ddb016] + Logging
#   [d6f4376e] + Markdown
#   [a63ad114] + Mmap
#   [de0858da] + Printf
#   [3fa0cd96] + REPL
#   [9a3f8284] + Random
#   [9e88b42a] + Serialization
#   [6462fe0b] + Sockets
#   [4ec0a83e] + Unicode
# Precompiling project...
#   1 dependency successfully precompiled in 2 seconds (3 already precompiled)
# ```

# # Generando notebooks (`ipynb`) con `Literate.jl`

# Aquí ilustraré cómo generar los Jupyter notebooks con el contenido
# de las clases, usando [Literate.jl](https://github.com/fredrikekre/Literate.jl).
# Supondremos, por consistencia, que estamos en el directorio raiz del curso,
# y que ahí iniciaremos una sesión del REPL.
#
# ```repl
# julia> cd("clases")   # Cambiamos al directorio ./clases/
# ```

# Una vez en el directorio correcto, *cargaremos* `Literate`:
#
# ```julia
# julia> using Literate
# ```

# Finalmente, generaremos a partir del archivo fuente ---en este caso "11-JuliaBasico.jl"---
# el Jupyter notebook (con extensión `.ipynb`).

# ```julia
# julia> Literate.notebook("11-JuliaBasico.jl", execute=false)
# [ Info: generating notebook from `~/Documents/4-Clases/46-TemasSelectos/2021-2/clases/11-JuliaBasico.jl`
# [ Info: writing result to `~/Documents/4-Clases/46-TemasSelectos/2021-2/clases/11-JuliaBasico.ipynb`
# "/Users/benet/Documents/4-Clases/46-TemasSelectos/2021-2/clases/11-JuliaBasico.ipynb"
# ```

# La instrucción anterior ejecuta la función `notebook`, de la paquetería `Literate`
# y genera el archivo "11-JuliaBasico.ipynb" que es el notebook que corresponde
# al archivo "11-JuliaBasico.jl". En este caso hemos usado el parámetro (opción) `execute=false` para
# **no** se ejecute el código que puede haber dentro del archivo. Esto es útil, en el contexto
# del curso, ya que si hay *errores* éstos impiden que se genere el notebook.
#
# Vale la pena notar que el archivo `.jl` permite generar celdas pueden ser de código,
# o en Markdown, y pueden también incluir ecuaciones, imágenes, etc. Por esto,
# es **muy** recomendable leer la [documentación](https://fredrikekre.github.io/Literate.jl/v2/)
# de `Literate`, lo que les ayudará en particular a formatear los archivos `.jl` que
# enviarán con las tareas resueltas.

# Usaremos la paquetería `IJulia` para abrir el notebook, en este caso, `10-Pkg.ipynb`, y de
# hecho poderlo explotar.
