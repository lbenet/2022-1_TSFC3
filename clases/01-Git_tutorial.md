# Tutorial para el manejo del repositorio Git de la clase

## 1. Creación del fork

Como primer paso se navegará hacia la página principal del curso, la cual será proporcionada por el profesor. En esta página se dará click en el botón que aparece a la derecha de la pantalla: *Fork*.

<img src="imagenes/Tutorial/fork_1.png" alt="alt text" width="800" height="450"/>

Esto nos enviará a nuestro fork que se ha creado. Notesé que nos encontramos en una copia del repositorio original ya que en la dirección el nombre ha cambiado. Hemos creado nuestro fork propio del curso!

<img src="imagenes/Tutorial/fork_2.png" alt="alt text" width="800" height="450"/>

## 2. Clonar repositorio

Ahora regresaremos al **REPOSITORO PRINCIPAL DEL CURSO**, ahí daremos click en el botón *CODE* y copiaremos la dirección, ya sea en https o ssh, todo depende de la configuración.

<img src="imagenes/Tutorial/clonar_1.png" alt="alt text" width="800" height="300"/>

Ahora localizamos una capeta donde desemos colocar el curso y abrimos aquí una terminal (o bien navegamos hasta está carpeta). Por favor, traten de no olvidarse de donde se encuentra. 

En este ejemplo, se ejecutará la siguiente orden:

 `git clone https://github.com/lbenet/2021-2TSelecFisComp-1.gi`

 En este punto solo necesitan sustituir el link por el que ustedes tienen.

 <img src="imagenes/Tutorial/clonar_2.png" alt="alt text" width="800" height="250"/>

 Ahora lo que haremos será ligar nuestro repositorio con el fork que hemos creado anteriormente. De esta forma ahora nos iremos al link del fork **DE CADA UNO DE NOSOTROS, NO EL DEL REPOSITORIO ORIGINAL**, en este punto obetendremos su link copiandolo otra vez después de presionar el botón *CODE*.

 <img src="imagenes/Tutorial/clonar_3.png" alt="alt text" width="800" height="400"/>

Después iremos a la carpeta donde esta nuestro repositorio que acabamos de clonar y entraremos en ella(en este caso ejecuto `cd 2021-2\_TSelecFisComp-1/` para este fin).

Posteriormente se ejecuta lo siguiente:

`git remote add mifork\_2 git@github.com:Julian-RC/2021-2\_TSelecFisComp-1.git`

que es `git remote add`+ *nombre de mi fork*+*link de mi fork*, el link debe ser el de tu fork que se copió en el paso anterior y el nombre puede ser cualquiera, pero debes recordarlo ya que es muy importante.

 <img src="imagenes/Tutorial/clonar_4.png" alt="alt text" width="800" height="250"/>

 Por último, ejecutamos:

`git remote -v`


para verificar que se encuentren tanto el *fork* que acabamos de hacer como el *origin* del curso. Hemos descargado el curso y ahora nuestra copia local se encuentra ligada a nuestro fork!

 <img src="imagenes/Tutorial/clonar_5.png" alt="alt text" width="800" height="270"/>

## 3. Subir Tareas

Para subir la tarea se realizará el siguiente procedimiento.

 **Como paso principal y fundamental se debe HACER UN BRANCH**, en este caso el mio se llamará Tarea-1, el nombre es lo de menos, el branch se crea con el comando

 `git branch Tarea-1`

 Noten que esto se hace desde la carpeta del curso que tenemos localmente.

  <img src="imagenes/Tutorial/tarea_1.png" alt="alt text" width="800" height="200"/>

  Ahora para movernos a la rama debemos ejecutar:

`git checkout Tarea-1`

Espero que resulte claro que en caso de que rama tenga un nombre distinto la última parte de la orden debe intercambiarse por el nombre asignado, es decir, si al branch la llamamos *rama_para_trabajar* entonces tendremos que ejecutar `git checkout rama_para_trabajar` para movernos a este branch.

Por último, confirmamos que estamos en la rama deseada realizando ejecutando `git branch`.

  <img src="imagenes/Tutorial/tarea_2.png" alt="alt text" width="800" height="200"/>

  Ahora será momento de ver donde colocar la tarea, primero entraremos en la carpeta de *Tareas*:

  <img src="imagenes/Tutorial/tarea_5.png" alt="alt text" width="800" height="500"/>

Dentro de la carpeta tareas crearás una carpeta con tu nombre, apellidos o nombres de los autores de la tarea:

  <img src="imagenes/Tutorial/tarea_4.png" alt="alt text" width="800" height="500"/>

Y dentro de esta copiarás el archivo con extensión .jl donde tienes tu tarea. **OJO: NO NECESITAMOS NI LOS .IPYBN, NI .JPJ,NI .PNG, ETC. QUE RESULTAN COMO RESULTADO DE LOS EJERCICIOS. SOLO ES NECESARIO SUBIR EL .JL DONDE TIENES EL CODIGO E IMAGENES QUE SE AGREGUEN AL TRABAJO DE FORMA DE APOYO, SOLO SI ES ABSOLUTAMENTE NECESARIO PARA EL DESARROLLO DE SU TAREA**:

  <img src="imagenes/Tutorial/tarea_3.png" alt="alt text" width="800" height="500"/>

Ahora para agregar el archivo y que nuestro git lo siga solo hacemos: 

`git add` + *dirección del archivo*

En este ejemplo que estoy realizando el código a correr se vería de la siguiente:

<img src="imagenes/Tutorial/tarea_6.png" alt="alt text" width="800" height="200"/>

Ahora realizaremos un commit con los cambios como se ve en la imagen:

<img src="imagenes/Tutorial/tarea_7.png" alt="alt text" width="800" height="450"/>

En este punto, es **MUY IMPORTANTE RECORDAR EL NOMBRE DEL FORK**, además debes estar en el branch que creaste para esta tarea, si lo haces desde main tendrás problemas. Para subir los archivos agregados a tu fork online, será necesario ejecutar la siguiente linea:

`git push mifork\_2`

donde *mifork_2* es el nombre del fork que hemos escogido.

<img src="imagenes/Tutorial/tarea_8.png" alt="alt text" width="800" height="500"/>

En caso de salir una relacionada con `upstream`o algo parecido, solo es necesario ejecutarlo una vez y listo.

Hasta este punto solo se ha subido a nuestro fork online pero aún no ha sido agregado al repositorio del curso.

Ahora si entras a tu fork en la web veras esta imagen, nota que el símbolo que esta a la izquierda del letrero amarillo dice que subí un branch. Ahora solo presionamos el botón `Compare & pull request`.

<img src="imagenes/Tutorial/tarea_9.png" alt="alt text" width="800" height="400"/>

Nos mandará a una página donde es opcional agregar un mensaje para después subir el pull que se ve de esta forma, nota que solo cambia un archivo, esto se ve donde dice `Files changes`.
<img src="imagenes/Tutorial/tarea_10.png" alt="alt text" width="800" height="400"/>

También observa que el archivo esta en la carpeta, lo que implica que la tareas original no se ve afectada y tu trabajas en tu propia carpeta. 
<img src="imagenes/Tutorial/tarea_11.png" alt="alt text" width="800" height="400"/>
Como te diste cuenta es importante el nombre que le des al fork y siempre debes tener presente la rama en la que estás, para cada tarea diferente crea una rama diferente, en este caso durante esta tarea solo se necesita trabajar en esta rama.

## 4. Subir avances de la tarea

Ahora para subir avances  (yo realice un pequeño cambio en el archivo que subí) solo es necesario hacer un  `git add ...` y un `git commit ...` , realizas el `git push ....` igual que la vez anterior y eso es todo, ya esta en el repositorio del curso como un nuevo cambio al pull request que subiste!!!
<img src="imagenes/Tutorial/actualizar_1.png" alt="alt text" width="800" height="400"/>
Si miras el pull request que esta en el repositorio de la clase tiene dos commits sin necesidad de ir a la web y dar otro click!!. Lo que esto significa es que tu rama es el pull request, lo que hagas ahí se  subirá como tarea cuando hasgas el push, por eso ten cuidado que editas :)

<img src="imagenes/Tutorial/actualizar_2.png" alt="alt text" width="800" height="400"/>

## 5. Algunos puntos extra

- Para mantener actualizado tu fork, tal y como se explica en *01-git.md*, con el repositoro del curso se debe ejecutar:

    `git checkout main`

    `git pull origin`

    `git push mifork_2`

  Con *mifork_2* el nombre que se asigno al fork respectivo.

- **DURANTE EL CURSO, CUANDO SE REVISEN LOS NOTEBOOK SIEMPRE SIEMPRE TRABAJEN EN RAMAS**, **NO TRABAJEN EN MAIN, NUNCA**.