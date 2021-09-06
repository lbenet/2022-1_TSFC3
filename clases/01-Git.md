# `git` ultrabásico

<img src="https://raw.githubusercontent.com/louim/in-case-of-fire/master/in_case_of_fire.png" title="In case of fire (https://github.com/louim/in-case-of-fire)" width="280" height="200" align="center">

---
# Instalación

Descargar la versión apropiada según la plataforma:

- OSX: https://git-scm.com/download/mac; o instalarlo a través de [homebrew](https://brew.sh/)

- Linux: https://git-scm.com/download/linux

- Windows: https://gitforwindows.org/

---
# ¿Qué es `git`?

`git` es un sistema de control de versiones descentralizado. `git` permite desarrollar proyectos colaborativos de manera coordinada, distribuida (descentralizada), incremental y eficiente, preservando *la historia* del proyecto en cada copia del proyecto.

`git` funciona desde la línea de comandos, aunque también existen versiones gráficas.

---

# Configuración básica

Una vez instalado `git`, lo primero que haremos es configurarlo para que `git` atribuya el trabajo de manera correcta a quien lo hace. Para esto, desde la terminal, ejecutaremos una serie de comandos:

```git
git config --global user.name "Su Nombre"

git config --global user.email "usuario@email_de_verdad"

git config --global color.ui "auto"

git config --global github.user "Usuario_GitHub"
```

---
# Flujo de trabajo

De manera totalmente abstracta por ahora, el flujo de trabajo en `git` consiste en:

(1) Es **muy importante** trabajar en una rama *separada* de la principal (que se llama `main` o `master`). Por esto, uno debe empezar *creando* una rama para hacer los cambios, lo que permite no alterar el estado de la rama principal del proyecto.  Esto se hace con el comando:

```git
git checkout <nombre_de_la_rama>
```

---

## Flujo de trabajo (cont)

(2) Hacer los cambios al proyecto, a través de cambios en archivos existentes o nuevos en el proyecto. Para añadir los cambios hechos en el archivo `<file>` al "índice" de git (zona de almacenamiento temporal), se usa el comando:
```git
git add <file>
```
Nuevos cambios pueden ser realizados e incorporados, incluso los que involucran a otros archivos, y se pueden añadir a la zona temporal sin que se reflejen en el historial del proyecto. El "índice" es una zona de almacenamiento intermedia o temporal para, en algún sentido, ir mejorando los cambios que uno quiere hacer, o repensar si uno los quiere incluir, hasta que éstos se quieren incorporar al historial.

---

## Flujo de trabajo (cont)

(3) Eventualmente, los cambios a uno o varios archivos del proyecto se quieren incluir en el historial del proyecto de una manera más definitiva y explícita. (Internamente, `git` actualiza el puntero `HEAD`.) Esto se hace a través del comando:
```git
git commit -m "Mensaje descriptivo de los cambios realizados"
```
El mensaje, que puede detallarse aún más, justamente sirve para describir los cambios hechos.

`git` tiene una amplísima flexibilidad: Uno puede *cambiar* el orden de los *commit*s, incluso cambiando la estructura al unirlos en uno solo, por ejemplo. Lo importante, entonces, es ir "guardando" el trabajo hecho, y avanzar hasta que "se complete" el objetivo del cambio que se propone.

---
# Comandos básicos

```git
git help
```

Ayuda básica sobre `git`; en particular, despliega varios comandos útiles. Para obtener el manual correspondiente a cada comando se usa
```git
    git help <command>
```

--

```git
git init
```

Sirve para inicializar cualquier repositorio local `git`. Este comando crea un nuevo directorio local (`.git/`) donde se almacena toda la información necesaria del repositorio. Típicamente, se utiliza una vez este comando.

---

## Comandos básicos (cont)

```git
git checkout
```

Este comando tiene varios usos relacionados con las ramas de desarrollo de un proyecto. La idea de las ramas (o *branch*-es) es poder hacer cambios específico sin alterar la versión principal del repositorio (que están en la rama `main` o en la rama `master`), de una manera independiente respecto a otros desarrolladores. Esto permite el trabajo en paralelo, incluyendo hacer pruebas "disruptivas" que no afectan el funcionamiento.

```git
    git checkout -b <nombre_rama>
```

Sirve para *crear* y cambiarnos una nueva rama


```git
    git checkout <nombre_rama>
```

Permite cambiarse de rama. La rama *principal* por convención es la rama `main` o la rama `master`.

```git
    git checkout -- <file>
```

Sirve para revertir ciertos cambios en uno o varios archivos

---

## Comandos básicos (cont)

```git
git status
```

Muestra el estado del repositorio: por un lado, muestra la rama en la que se está trabajando, los cambios en los archivos que  están incluidos en  el proyecto, o de los que aún no se siguen, los archivos que están en el "índice" pero que aún no se "comprometen", etc.

```git
git log
```

Muestra la información sobre los commits que se han hecho en el repositorio, mostrando primero los commits más recientes. Existen varias formas útiles simplificadas:
```git
    git log --oneline
    git log --graph
```

---

## Comandos básicos (cont)

Los siguientes comandos son **muy importantes** para el [flujo de trabajo](#flujotrabajo):

```git
git add <files>
```

Agrega el contenido del archivo a la lista de archivos (índice) cuyos cambios se seguirán en el repositorio.

```git
git commit -m "Message about commit"
```

Este comando "compromete" los cambios hechos y agregados con `git add`, es decir, los incluye en el historial preciso del repositorio través de actualizar el puntero `HEAD`. La información que aquí se escribe es a la que se tiene acceso con `git log`.

---

## Comandos básicos (cont)

Los siguientes comandos son de interés a la hora de trabajar con versiones remotas del repositorio, y son importantes para los aspectos colaborativos de `git`.

```git
git push [<remote> <rama>]
```

Este comando actualizará la versión remota de un repositorio local (se pueden tener varias versiones remotas!) "subiendo" los cambios hechos localmente.

```git
git pull [<remote> <rama>]
```

Este comando actualizará la versión local de un repositorio, a partir de los cambios que hay en la dirección "remota" del repositorio.

```git
git clone <direccion_repo>
```

Permite crear una copia *local* de un repositorio remoto, que se especifica a través de su dirección. La copia local contiene el historial íntegro del repositorio remoto.

---

# `git` colaborativo

A fin de contribuir a un proyecto remoto del cual **no** somos los "propietarios", o simplemente no tenemos permiso de escribir lo que es muy común, es típico hacer una copia (propia) del repositorio al que se quiere contribuir desde su propia cuenta de [GitHub](https://github.com). Esto se hace haciendo un *fork*, es decir, creando una bifurcación del proyecto original.

Es en el fork (local) donde ustedes pueden hacer cambios o pruebas de manera libre. Eventualmente, subirán los cambios a su copia del fork en  GitHub (donde ustedes pueden escribir!), y entonces pueden hacer una petición para que sus cambios puedan ser incluidos en el proyecto. Esto se hace a través de un *pull request*.

Esta opción de hacer cambios y proponerlos para pertenecer al proyecto externo es la esencia del *software abierto*.

Ver también: [How to make your first pull request on GitHub](https://www.freecodecamp.org/news/how-to-make-your-first-pull-request-on-github-3/).

---

# Servidores remotos

Uno debe tener claro que uno parte de tener una copia íntegra del repositorio en su propia máquina. El repositorio, además de estar en cada una las máquinas que han clonado localmente el  repositorio, típicamente se encuentra en un espacio "público" como [GitHub](https://github.com) o Gitlab (el acceso puede ser restringido). El comando
```git
git clone <url_del_fork>
```
permite clonar un repositorio remoto a un directorio local.

`git` permite seguir los cambios de *distintos* repositorios remotos ligados al mismo proyecto; por ejemplo, uno es el proyecto oficial, otro la versión "fork" del propio proyecto, y un tercero donde se comparte el desarrollo con un compañera o compañero del mismo equipo.

---
## Servidores remotos (cont)

Una cosa importante es que hay dos tipos de URL que se  pueden especificar al momento de clonar un repositorio, y esto impacta la manera en que uno se conecta a [GitHub](https://github.com):

- Se puede clonar un repositorio usando ["https"](https://docs.github.com/en/github/using-git/which-remote-url-should-i-use#cloning-with-https-urls); esto requerirá usar un [*personal token*](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) para conectarse.

- Se puede clonar usando ["ssh"](https://docs.github.com/en/github/using-git/which-remote-url-should-i-use#cloning-with-ssh-urls) lo que para conectarse involucra [tener claves SSH](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh).

De las dos opciones, la más sencilla es la segunda, ya que ésta permita entrar a [GitHub](https://github.com) sin usar las credenciales de entrada cada vez. Uno puede cambiar esto usando el comando `git remote`.

---
## Servidores remotos (cont)

Para ver qué configuración se tiene de los repositorios remotos, uno ejecuta
```git
git remote -v
```

Si uno quiere agregar un nuevo servidor remoto para seguir los cambios, por
ejemplo, además de tener la copia oficial poder acceder al fork propio, se necesita agrgar una  identificación para  el nuevo "remote", usando el comando:
```git
git remote add <alias> <url_del_fork>
```
donde `<url_del_fork>` es la dirección donde está nuestro fork (en [GitHub](https://github.com)), y `<alias>` es la abreviación que le daremos, por ejemplo, "fork" o "mifork".

---
## Servidores remotos (cont)

La distinción entre el repositorio oficial y el fork, y por tanto sus abreviaciones (o alias) son importantes: el proyecto oficial (digamos la clase) típicamente no es de nuestra propiedad, en el sentido de que no tenemos derecho a "empujar" o "escribir" los cambios, mientras que el "fork" propio (en nuestra cuenta de [GitHub](https://github.com)) sí lo tenemos.

El comando
```git
git push mifork
```
empujará los cambios a `mifork` usando la rama actual, y desde GitHub, podremos *poner a consideración* estos cambios para que puedan ser incluidos en el repositorio oficial.

---
## Servidores remotos (cont)

De igual manera, para tener actualizada la rama principal (en este caso `main`) de su fork con el del proyecto oficial, lo que deben hacer es:
```git
git checkout main
git pull origin
git push mifork
```
La primer instrucción hace el cambio a la rama "main", la segunda jala (actualiza) del remote "origin" los cambios a la máquina local (si es que los hay), y el último actualiza nuestro fork en GitHub, también a la rama "main".

---

# Ramas

Un punto **esencial** para hacer de `git` sea una herramienta colaborativa eficiente, es el uso de ramas (*branch*-es). Trabajar distintas cosas en distintas ramas es lo mejor que pueden hacer.

La idea es trabajar en una rama independiente, cosa que aparentemente equivale a una copia íntegra que se crea a partir del lugar/momento (commit) en el que se crea la rama. Esta descripción es muy simplista, en el sentido de que crear una rama no involucra hacer copias, sino redirigir ciertas ligas simbólicas; de hecho, el trabajo en ramas es mucho más poderoso que esto. En la nueva rama uno hace los cambios específicos, que eventualmente se enviarán para ser considerado como nueva aportación en el proyecto.

---
## Ramas (cont)

Para crear una rama, uno puede usar el comando
```git
git branch <nombre_rama>
```
donde "nombre_rama" será el nombre de la nueva rama creada.

El comando anterior crea la rama, pero no nos cambia a esa rama. Para cambiarnos, utilizamos (ver arriba) el comando
```git
git checkout <nombre_rama>
```

Para ver qué ramas hay en el proyecto, uno usa el comando
```git
git branch -v
```

---
## Ramas (cont)

Una manera más corta de crear la rama y cambiarnos a ella, como se explicó arriba, es usar el comando
```git
    git checkout -b <nombre_rama>
```
Es importante señalar que uno puede crear tantas ramas como se quiera y desde cualquier punto del desarrollo, dado que éstas son *baratas* en cuanto al espacio de disco.

El commit en la rama desde el que se crea una nueva rama aparece en la nueva rama.

---

# Algunas ligas útiles:

- [Learn git branching](https://learngitbranching.js.org/)

- [Git & GitHub Crash Course For Beginners](https://www.youtube.com/watch?v=SWYqp7iY_Tc)

- [Git - the simple guide](https://rogerdudler.github.io/git-guide/)

- [How to make your first pull request on GitHub](https://www.freecodecamp.org/news/how-to-make-your-first-pull-request-on-github-3/)
