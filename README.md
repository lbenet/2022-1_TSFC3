# Temas Selectos de Física Computacional III

## Aritmética de intervalos (2022-1)


[Grupo 8387](https://aulas-virtuales.cuaed.unam.mx/)

Luis Benet
[Instituto de Ciencias Físicas, UNAM](https://www.fis.unam.mx)

Julián Ramírez Castro
[Facultad de Ciencias, UNAM](http://www.fciencias.unam.mx)


*Lunes 10-12 -- Jueves 10-11*


---

### Contenido del curso

El objetivo del curso es introducir una serie de métodos de matemáticas y física computacionales que permiten *calcular con conjuntos* y establecer resultados garantizados (rigurosos), a partir de cálculos numéricos usando números de punto flotante. El curso está dirigido a estudiantes de Física, Matemáticas, Matemáticas Aplicadas y Ciencias de la Computación.

En el curso estudiaremos (e implementaremos en el lenguaje de programación [Julia](https://julialang.org)) los conceptos básicos y técnicas relacionadas con la aritmética y análisis de intervalos, la aplicación de métodos tipo Newton para intervalos, diferenciación automática, propagación de restricciones, y el método de integración de Taylor. A través de ejemplos concretos cubriremos distintas aplicaciones.

### Temario

- Aritmética de punto flotante y redondeo
- Aritmética de intervalos
- Funciones de intervalos
- Raíces de funciones: Métodos rigurosos de bisección y Newton
- Cuadratura numérica
- Diferenciación automática en una y varias variables
- Mínimos y máximos de funciones: Optimización local y global
- Aproximación de funciones mediante series de Taylor; cálculo del error
- Propagación de constricciones
- Ecuaciones diferenciales ordinarias y el método de integración de Taylor

### Bibliografía

- R.E. Moore, R. Baker Kearfott & M.J. Cloud, Introduction to Interval Analysis, SIAM, 2009
- W. Tucker, Validated Numerics: A Short Introduction to Rigorous Computations, Princeton University Press, 2011

---

### Ligas de interés

- **git**
	- [Learn Git branching](https://learngitbranching.js.org/)

	- [Become a Git guru](https://www.atlassian.com/git/tutorials/)

	- [Github](https://docs.github.com/en/github/getting-started-with-github)

	- [Hello World en GitHub](https://guides.github.com/activities/hello-world/)

- **Markdown**
	- [Markdown guide](https://www.markdownguide.org/getting-started/)

- **Julia**
	- [http://julialang.org/](https://julialang.org)

	- [Julia programming for nervous beginners](https://www.youtube.com/watch?v=ub3tqCWZmo4&list=PLP8iPy9hna6Qpx0MgGyElJ5qFlaIXYf1R)

---

### Preparación (set-up)

1. Instalar `git`:
    Seguir las instrucciones descritas en https://www.atlassian.com/git/tutorials/install-git, que dependen de la plataforma que usan:  [Linux](https://www.atlassian.com/git/tutorials/install-git#linux), [Mac](https://www.atlassian.com/git/tutorials/install-git#mac-os-x),  [Windows](https://www.atlassian.com/git/tutorials/install-git#windows)

2. Instalar Julia:
    Ir a https://julialang.org/downloads/, descargar [la última versión estable](https://julialang.org/downloads/#current_stable_release) (actualmente es la 1.5.3) y  que sea adecuada a su plataforma.

3. Verificar el funcionamiento de Julia; ver las notas específicas para [cada plataforma](https://julialang.org/downloads/platform/):
    Abran la aplicación que acaban de instalar y corran el comando: `1+1`.

4. Instalar el [Jupyter Lab](https://jupyter.org/) (o el Jupyter Notebook) siguiendo [las instrucciones oficiales](https://jupyter.org/install).
