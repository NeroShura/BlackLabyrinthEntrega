# Black Labyrinth

## 1. Descripción general

**Black Labyrinth** es un videojuego de exploración y supervivencia desarrollado en **Processing**, utilizando **Java** y el paradigma de **Programación Orientada a Objetos (POO)**.

El jugador debe recorrer un laberinto formado por diferentes salas, encontrar la salida y evitar ser atrapado por los enemigos que aparecen durante la partida. Para sobrevivir, debe aprovechar los recursos disponibles, como las pilas que recargan la linterna y las bebidas energéticas que mejoran temporalmente su velocidad.

Además, puede interactuar con objetos del escenario para modificar el entorno y utilizarlos estratégicamente. El juego incorpora diferentes niveles de dificultad, personalización del avatar, efectos visuales, un cronómetro y un sistema de récords almacenado en una base de datos SQLite.

## 2. Objetivos del juego

El objetivo principal es encontrar la sala de salida y llegar hasta ella sin ser atrapado por un enemigo.

Durante la partida, el jugador debe:

- Explorar las distintas salas del laberinto.
- Encontrar y utilizar recursos.
- Evitar a los enemigos.
- Aprovechar los objetos movibles del escenario.
- Administrar la energía de la linterna.
- Utilizar bebidas energéticas para mejorar temporalmente su velocidad.
- Alcanzar la salida en el menor tiempo posible.

La partida termina de dos maneras:

- **Victoria:** el jugador llega a la sala de salida.
- **Game Over:** un enemigo alcanza al jugador.

## 3. Características principales

- Interfaz gráfica desarrollada en Processing.
- Ventana de juego de `800 × 600` píxeles.
- Laberinto compuesto por diferentes salas conectadas.
- Generación aleatoria de elementos y contenido.
- Tres niveles de dificultad.
- Movimiento del jugador en horizontal, vertical y diagonal.
- Enemigos con movimiento aleatorio y comportamiento de persecución.
- Linterna con energía limitada.
- Pilas que permiten recuperar energía.
- Bebidas energéticas con diferentes efectos y probabilidades de aparición.
- Objetos del escenario que pueden moverse con el mouse.
- Sistema de colisiones entre el jugador, los enemigos y los objetos.
- Sistema de partículas para representar efectos visuales.
- Personalización de la apariencia del avatar.
- Diferentes escenarios visuales.
- Pantallas de historia y controles.
- Cronómetro y sistema de récords.
- Integración con una base de datos SQLite.

## 4. Interfaz y pantallas

El juego está organizado mediante diferentes estados de pantalla. La variable `pantalla` determina qué sección debe mostrarse.

### 4.1. Menú principal

Es la pantalla inicial del juego. Desde aquí se puede acceder a las principales opciones:

- **Jugar:** permite comenzar el proceso de inicio de una partida.
- **Personalizar:** abre el menú de personalización del avatar.
- **Controles:** muestra las instrucciones de manejo.
- **Salir:** cierra el juego.

### 4.2. Selección de dificultad

Permite seleccionar uno de los tres niveles disponibles:

- Fácil.
- Normal.
- Difícil.

La selección se almacena en la variable `dificultad`. Cada nivel utiliza un valor diferente para configurar la generación del laberinto y sus características.

### 4.3. Historia

Después de seleccionar la dificultad se presenta una pantalla con la historia del juego. Esta pantalla utiliza el recurso gráfico `Historia.jpg`.

Al presionar `ENTER` se inicia la partida. `ESC` permite regresar a la selección anterior.

### 4.4. Personalización del avatar

Permite modificar la apariencia del personaje antes de comenzar una partida. Se pueden personalizar cuatro partes:

- Remera.
- Pantalón.
- Piel.
- Pelo.

Cada parte dispone de una paleta de ocho colores. La selección se realiza mediante el teclado y se muestra una vista previa del personaje para observar los cambios.

Los colores seleccionados se aplican al jugador cuando comienza la partida.

### 4.5. Controles

Muestra una imagen con las instrucciones necesarias para jugar. Utiliza el recurso `Controles.jpg`. Se puede regresar al menú principal mediante `ESC`.

### 4.6. Pantalla de juego

Es la sección principal. En ella se muestran:

- La sala actual.
- El jugador.
- Los enemigos.
- Los objetos movibles.
- Las bebidas energéticas y las pilas.
- La iluminación de la linterna.
- Los efectos de partículas.
- El tiempo transcurrido.
- El récord registrado.

### 4.7. Game Over

Aparece cuando un enemigo alcanza al jugador. Muestra el mensaje de derrota y el tiempo que duró la partida. Después de unos segundos, el juego regresa automáticamente al menú principal.

### 4.8. Victoria

Se muestra cuando el jugador encuentra la salida del laberinto. Presenta el tiempo obtenido y el récord disponible. Si el tiempo conseguido mejora el récord anterior, se registra como uno nuevo. Después de unos segundos, el juego vuelve al menú principal.

## 5. Mecánicas del juego

### 5.1. Movimiento del jugador

El personaje puede desplazarse en las cuatro direcciones principales y también en diagonal.

Su movimiento se administra desde la clase `Jugador`, que contiene los datos necesarios para representar su posición, velocidad, dirección y animación.

El sistema utiliza `PVector` para trabajar con los vectores de movimiento. Cuando se presionan dos direcciones simultáneamente, se normaliza el vector para evitar que el jugador se desplace más rápido en diagonal que en línea recta.

También se controla la duración de los efectos temporales que modifican su velocidad.

### 5.2. Exploración del laberinto

El mapa está compuesto por salas conectadas mediante puertas. El jugador puede desplazarse entre ellas cuando alcanza una puerta disponible.

Cada sala tiene información sobre sus conexiones con las salas vecinas. Esto permite determinar por dónde puede continuar el recorrido y evita que el jugador atraviese paredes que no tienen una puerta.

### 5.3. Enemigos

Los enemigos aparecen en determinadas salas del laberinto. Su comportamiento se administra mediante la clase `Enemigo`.

Existen dos comportamientos principales:

- **Movimiento aleatorio:** utiliza ruido Perlin para generar desplazamientos variables y suaves.
- **Persecución:** cuando detecta al jugador, intenta acercarse a su posición. Si se encuentra en otra sala, busca dirigirse hacia la sala donde está el jugador.

El enemigo también verifica las puertas disponibles y las colisiones con los elementos del escenario.

Si alcanza al jugador, se activa el estado **Game Over**.

### 5.4. Linterna

La linterna es un elemento importante para la ambientación y exploración. Se administra mediante la clase `Linterna` y cuenta con una cantidad limitada de energía.

Su iluminación se genera mediante un objeto `PGraphics`, que permite dibujar un efecto de luz alrededor del jugador. La intensidad depende de la batería restante.

A medida que transcurre el tiempo, la linterna consume energía. Cuando se agota, deja de proporcionar iluminación hasta que el jugador consiga una pila.

### 5.5. Pilas

Las pilas son objetos que permiten recuperar la energía de la linterna.

Cuando el jugador se encuentra suficientemente cerca de una pila, esta se recoge automáticamente. Al hacerlo:

- Se marca la pila como recogida.
- Se restaura la batería de la linterna.
- Se generan partículas para representar visualmente la recolección.

La clase `Pila` administra su posición, imagen, estado y comportamiento.

### 5.6. Bebidas energéticas

Las bebidas energéticas son elementos que otorgan una mejora temporal al jugador.

Existen cuatro tipos, identificados mediante constantes:

| Tipo | Probabilidad de aparición |
| :--- | :--- |
| Verde | 50 % |
| Amarilla | 25 % |
| Azul | 20 % |
| Roja | 5 % |

La clase `BebidaEnergetica` se encarga de inicializar cada bebida, cargar su imagen, comprobar si el jugador puede recogerla y aplicar el efecto correspondiente.

Al recoger una bebida, se activa el efecto asociado a su tipo. Los efectos temporales se administran mediante un multiplicador de velocidad y un temporizador.

### 5.7. Objetos movibles

El escenario contiene objetos que pueden desplazarse utilizando el mouse.

El jugador puede seleccionarlos, arrastrarlos y soltarlos en otra posición. Para mantener la posición del objeto respecto al cursor, se calcula la distancia entre el mouse y el objeto al comenzar el arrastre.

La posición se limita para impedir que el objeto salga de los bordes de la ventana.

Estos objetos también intervienen en el sistema de colisiones, por lo que pueden bloquear el movimiento del jugador y dificultar el paso por determinadas zonas.

### 5.8. Sistema de partículas

El juego utiliza partículas para representar efectos visuales.

La clase `Particula` representa cada partícula individual y contiene:

- Posición.
- Velocidad.
- Vida restante.
- Tamaño.

Cada partícula se desplaza, reduce progresivamente su velocidad y pierde vida hasta desaparecer.

La clase `SistemaParticulas` administra un conjunto de partículas mediante un array. Se encarga de generar nuevas partículas, actualizar sus estados y dibujar únicamente las que siguen activas.

Se utiliza, entre otras situaciones, cuando el jugador recoge una pila.

### 5.9. Escenarios visuales

El juego dispone de tres imágenes de escenario:

- `Escenario1.jpg`
- `Escenario2.jpg`
- `Escenario3.jpg`

Al comenzar una partida se selecciona un escenario visual. Este se mantiene durante el recorrido, incluso cuando el jugador cambia de sala, para conservar la continuidad visual de la partida.

## 6. Arquitectura del proyecto

El proyecto está dividido en diferentes archivos `.pde`. Cada archivo contiene una clase o parte de la lógica principal del juego. Esta organización permite separar responsabilidades y facilita el mantenimiento del código.

### 6.1. Archivo principal

| Archivo | Responsabilidad |
| :--- | :--- |
| `Main.pde` | Control general del juego, pantallas, eventos, inicialización y ciclo principal. |

### 6.2. Clases del juego

| Clase | Responsabilidad |
| :--- | :--- |
| `Mapa` | Creación del laberinto, salas, conexiones y administración de elementos. |
| `Sala` | Representación visual y características de cada sala. |
| `Jugador` | Representa al personaje, su movimiento, apariencia y posición. |
| `Enemigo` | Administra el comportamiento y movimiento de los enemigos. |
| `Linterna` | Controla la iluminación y la energía disponible. |
| `Pila` | Representa los recursos que recargan la linterna. |
| `BebidaEnergetica` | Administra los potenciadores de velocidad. |
| `ObjetoMovible` | Permite interactuar con objetos del escenario mediante el mouse. |
| `Particula` | Representa cada partícula individual de los efectos visuales. |
| `SistemaParticulas` | Administra la creación, actualización y dibujo de partículas. |
| `BaseDatos` | Gestiona la conexión con SQLite y el registro de récords. |

## 7. Funcionamiento del mapa

### 7.1. Estructura

El laberinto se representa mediante una matriz bidimensional. La estructura utilizada en `Mapa.pde` es de `5` filas por `5` columnas.

Cada posición de la matriz indica si existe una sala en esa ubicación:

- `1`: existe una sala.
- `0`: no existe una sala.

La matriz se utiliza para construir la estructura del laberinto y determinar las conexiones entre las salas.

### 7.2. Conexiones

Cada sala conoce si tiene una puerta hacia alguna de las cuatro direcciones:

- Arriba.
- Abajo.
- Izquierda.
- Derecha.

Estas conexiones se determinan a partir de las salas existentes en las posiciones vecinas de la matriz.

### 7.3. Tipos de salas

Durante la generación del mapa se asignan distintos tipos de salas:

| Tipo | Característica |
| :--- | :--- |
| **Normal** | Sala común del laberinto. |
| **Fortuna** | Puede contener recursos para el jugador. |
| **Peligro** | Contiene enemigos. |
| **Victoria** | Es la sala que contiene la salida. |

La sala de victoria se selecciona entre las salas ubicadas en los extremos del laberinto, siempre que existan posiciones disponibles. Las demás salas reciben aleatoriamente uno de los tipos restantes.

### 7.4. Distribución de elementos

El contenido se genera al crear el mapa:

- En las salas de fortuna se genera una bebida energética o una pila.
- El tipo de bebida energética se selecciona mediante probabilidades.
- En las salas de peligro se generan uno o dos enemigos.
- También se pueden generar objetos movibles en distintas salas, respetando determinadas distancias para evitar superposiciones y mantener libres las zonas de las puertas.

### 7.5. Generación de bebidas energéticas

El método `generarTipoMonster()` determina qué tipo de bebida energética se genera.

La selección se realiza mediante probabilidades acumuladas:

- Verde: 50 %.
- Amarilla: 25 %.
- Azul: 20 %.
- Roja: 5 %.

De esta manera, las bebidas no aparecen con la misma frecuencia y algunas son más difíciles de encontrar que otras.

## 8. Funcionamiento del programa principal

El archivo `Main.pde` coordina el funcionamiento general del videojuego.

### 8.1. Inicialización

El método `setup()` configura la ventana del juego, carga los recursos gráficos, inicializa el avatar de vista previa y crea el objeto encargado de gestionar la base de datos.

### 8.2. Inicio de partida

El método `iniciarJuego()` crea los objetos principales necesarios para comenzar:

- Un nuevo `Mapa`.
- Un nuevo `Jugador`.
- Una `Linterna`.
- Un `SistemaParticulas`.

También reinicia los estados de victoria y derrota e inicializa el cronómetro.

### 8.3. Ciclo principal

El método `draw()` se ejecuta continuamente y determina qué pantalla debe dibujarse según el estado actual.

Cuando se encuentra en la pantalla de juego, se ejecuta el método `jugar()`. Este método coordina las actualizaciones y comprobaciones necesarias para desarrollar la partida.

El ciclo general incluye:

1. Actualizar el movimiento del jugador.
2. Comprobar las colisiones con las paredes y los objetos.
3. Actualizar el comportamiento de los enemigos.
4. Comprobar las bebidas energéticas.
5. Comprobar las pilas.
6. Actualizar el sistema de partículas.
7. Comprobar si un enemigo alcanzó al jugador.
8. Dibujar la sala y sus elementos.
9. Comprobar los cambios de sala.
10. Verificar si el jugador llegó a la salida.
11. Actualizar la información visual del juego.

## 9. Sistema de colisiones

El juego implementa diferentes comprobaciones para controlar las interacciones entre los elementos.

### 9.1. Colisiones con los límites

El jugador no puede atravesar las paredes de una sala cuando no existe una puerta disponible. Cuando llega a una puerta habilitada, puede continuar hacia la sala vecina.

### 9.2. Colisiones con objetos

Los objetos movibles funcionan como obstáculos físicos. El sistema calcula las distancias entre el jugador y los límites de cada objeto para impedir que el personaje los atraviese.

También se comprueba que los objetos no bloqueen determinadas zonas importantes, como las puertas, durante su generación.

### 9.3. Colisiones con enemigos

Se comprueba la distancia entre la posición del jugador y la de los enemigos. Cuando la distancia es inferior al límite establecido, se considera que el enemigo alcanzó al jugador y se activa el estado de derrota.

### 9.4. Colisiones con recursos

Las bebidas energéticas y las pilas comprueban la proximidad del jugador para determinar cuándo deben activar sus respectivos efectos.

## 10. Sistema de tiempo y récords

El juego dispone de un cronómetro que mide cuánto tarda el jugador en encontrar la salida. El tiempo se calcula utilizando `millis()`, que permite obtener el tiempo transcurrido desde el inicio del programa.

El resultado se presenta con el siguiente formato:

`MM:SS:CC`

Donde:

- `MM`: minutos.
- `SS`: segundos.
- `CC`: centésimas.

Al alcanzar la victoria, el tiempo final se compara con el récord almacenado. Si el nuevo resultado es mejor, se actualiza el récord.

## 11. Base de datos

El proyecto utiliza **SQLite** para almacenar y consultar el récord del juego.

La clase `BaseDatos` se encarga de administrar las operaciones relacionadas con la conexión y el registro de tiempos. La base de datos se almacena en un archivo local llamado `laberinto.db`.

Las operaciones principales son:

- `conectar()`: establece la conexión con SQLite y prepara la tabla si todavía no existe.
- `obtenerRecord()`: obtiene el mejor tiempo almacenado.
- `guardarSiEsMenor(tiempo)`: registra el nuevo tiempo únicamente cuando mejora el récord existente.

La tabla utilizada almacena el récord del juego. Se emplean consultas SQL mediante objetos como `PreparedStatement` y `ResultSet` para realizar las operaciones.

Para utilizar esta funcionalidad es necesario contar con el controlador JDBC de SQLite dentro del proyecto de Processing.

## 12. Recursos del proyecto

Los recursos gráficos y otros archivos necesarios deben ubicarse en la carpeta `data` del sketch de Processing.

| Recurso | Utilización |
| :--- | :--- |
| `Menu.png` | Fondo del menú principal. |
| `Escenario1.jpg` | Primer escenario visual. |
| `Escenario2.jpg` | Segundo escenario visual. |
| `Escenario3.jpg` | Tercer escenario visual. |
| `Controles.jpg` | Imagen de instrucciones. |
| `Historia.jpg` | Imagen de la historia del juego. |
| `Monster.png` | Imagen utilizada para las bebidas energéticas. |
| `Pila.png` | Imagen utilizada para las pilas. |

Los nombres de los archivos deben coincidir con los utilizados en el código para que Processing pueda cargarlos correctamente.

## 13. Tecnologías utilizadas

| Tecnología | Utilización |
| :--- | :--- |
| **Processing** | Desarrollo del videojuego y representación gráfica. |
| **Java** | Lenguaje utilizado por Processing para implementar la lógica. |
| **Programación Orientada a Objetos** | Organización del proyecto mediante clases y objetos. |
| `PVector` | Representación y cálculo de posiciones y vectores de movimiento. |
| `ArrayList` | Administración de colecciones de enemigos, recursos y objetos. |
| **Arrays** | Almacenamiento de matrices, paletas de colores y partículas. |
| **SQLite** | Almacenamiento y consulta de récords. |
| **JDBC** | Comunicación entre Java y la base de datos SQLite. |
| `PGraphics` | Creación del efecto de iluminación de la linterna. |
| **Mouse y teclado** | Interacción con los menús, el personaje y los objetos. |

## 14. Conceptos de programación aplicados

Durante el desarrollo se utilizaron diferentes conceptos de programación:

- **Programación Orientada a Objetos:** separación de las funcionalidades en clases independientes.
- **Constructores:** inicialización de los objetos del juego.
- **Atributos y métodos:** representación del estado y comportamiento de cada elemento.
- **Vectores:** cálculo de movimiento y posiciones mediante `PVector`.
- **Matrices:** representación de la estructura del laberinto.
- **Colecciones dinámicas:** administración de elementos mediante `ArrayList`.
- **Arrays:** almacenamiento de partículas y otros conjuntos de datos.
- **Aleatoriedad:** distribución de enemigos, recursos y tipos de salas.
- **Probabilidades:** selección de los diferentes tipos de bebidas energéticas.
- **Condicionales:** control de colisiones, estados y condiciones de victoria o derrota.
- **Ciclos:** actualización y representación de los elementos durante la partida.
- **Eventos:** detección de entradas del teclado y del mouse.
- **Detección de colisiones:** control de las interacciones físicas entre elementos.
- **Temporizadores:** administración de efectos temporales y medición de partidas.
- **Persistencia de datos:** almacenamiento de récords mediante SQLite.
- **Ruido Perlin:** generación de movimientos aleatorios suaves para los enemigos.

## 15. Organización y responsabilidades de las clases

Cada clase tiene una responsabilidad específica dentro del videojuego:

- `Main`: coordina las pantallas, los eventos y el funcionamiento general.
- `Mapa`: administra la estructura del laberinto, la generación de salas y los elementos que contiene.
- `Sala`: representa cada habitación, sus puertas y su apariencia.
- `Jugador`: controla el movimiento, los colores y los 