# Práctica Jenkins + Github + Terraform

**Autores: Alejandro Pedro Alonso-Basurto Díaz y Jonás Núñez Díaz**

En primer lugar, realizamos un fork del repositorio de la práctica mediante el comando <fork https://github.com/jenkins-docs/simple-python-pyinstaller-app>, sobre el cual vamos a trabajar. Tenemos un fichero Dockerfile, que nos servirá para crear la imagen de docker modificada de jenkins con la extensión *blueocean*.

Ejecutamos el comando docker en la terminal: <docker build -t myjenkins-blueocean:2.426.2-1 .>.
Con este comando creamos la imagen que vamos a usar en Terraform.

Para continuar, tenemos en nuestra posesión dos ficheros más: *jenkins-docker+jenkins-blueocean.tf* y *variables.tf*. El primero es el fichero principal de Terraform, lo usamos para desplegar el contenedor de docker-dind (*jenkins-docker*), motor de docker para ofrecérselo al contenedor de jenkins; y el de jenkins con blueocean (*jenkins-blueocean*).

Ahora, en el fichero *jenkins-docker+jenkins-blueocean.tf* indicamos que el proveedor de la configuración es Docker. con "provider "docker" {}". Los dos *resource* nos permiten declarar y otorgar un nombre a las imágenes de docker *docker:dind* y la imagen recientemente creada de jenkins con *blueocean*, *myjenkins-blueocean:2.426.2-1*.
Después, tenemos los dos recursos *resource* para crear el contenedor *jenkins-docker* y el contenedor *jenkins-blueocean*. El parámetro *image* sirve para indicar la imagen que va a usar este, *name* para indicar el nombre que le daremos, ports nos permite el mapeo de los puertos de nuestra máquina hacia el contenedor.
Las variables de entorno se proporcionan al contenedor a través de la sección *env*. Todas estas variables se encuentran, para mayor modularidad del código, en el fichero variables.tf, definidas con el formato tipo, valor.
Luego, indicamos los volúmenes que vayamos a usar para permitir la persistencia una vez los contenedores sean eliminados, indicando el nombre del volumen (los cuales están declarados debajo, fuera del *resource*) y el path del contenedor en el que se quiere montar el volumen. Por último, tenemos el bloque *networks_advanced*, para indicar la red (*jenkins*), cuya red está declarada debajo, a la que pertenecen ambos contenedores para que puedan comunicarse.

Desde terminal, en el directorio docs, ejecutamos el comando: <terraform init> y a continuación: <terraform apply> para que desplieguen los contenedores.

Una vez ya están desplegados, accedemos a *localhost:8080* desde el navegador web. Esto nos llega al menú de instalación de jenkins. Introducimos nombre de usuario, contraseña y correo, y luego indicamos la url de jenkins. Tenemos que buscar la contraseña inicial en el directorio *var/jenkins_home/secrets/initialAdminPassword*, mediante los comandos de terminal: <docker exec -it jenkins-blueocean bash> y <cat /var/jenkins_home/secrets/initialAdminPassword>.

Para crear un pipeline, hacemos click en *Nueva Tarea*, introducimos nombre para el ítem, seleccionamos *pipeline*. Damos una descripción (opcional), luego, en la sección *Pipeline*, en definition seleccionamos *from SCM* y luego *Git*, e indicamos la [URL del repositorio](https://github.com/AlexioPlay/simple-python-pyinstaller-app). En *branch specifier*, indicamos que es la rama main la que contiene el pipeline Jenkinsfile (*/main), y que el script path es *Jenkinsfile*, ya que está en la raíz del repositorio.

Para ejecutar el pipeline, abrimos el menú de blueocean seleccionando en el panel de la izquierda. Hacemos click en iniciar para inciar el proceso de despliegue del pipeline de jenkins. Vemos como se completan las etapas de Build, Test y Deliver, y listo.