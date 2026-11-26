
Mapa mapa;
Jugador jugador;
Jugador avatarVista;
Linterna linterna;
SistemaParticulas sistemaParticulas;

BaseDatos baseDatos;

PImage menu;
PImage[] escenarios = new PImage[3];
PImage controles;
PImage historia;
PImage fondoEscenario;

boolean arribaPresionada = false;
boolean abajoPresionada = false;
boolean izquierdaPresionada = false;
boolean derechaPresionada = false;

boolean gameOver = false;
boolean victoria = false;

int pantalla = 0;
int opcionMenu = 0;
int opcionDificultad = 0;
int dificultad = 5;

int parteSeleccionada = 0;

long tiempoInicio = 0;
long tiempoFinal = 0;
long mejorTiempo = 0;

int tiempoPantallaFinal = 0;
int duracionPantallaFinal = 3000;

int[] indicesColores = {0, 0, 0, 0};

boolean tiempoRegistrado = false;

color colorRemera = #2850B4;
color colorPantalon = #1E1E1E;
color colorPiel = #C8A082;
color colorPelo = #3C281E;

color[] paletaRemera = {
  #2850B4, #D62828, #168A55, #7B35B5,
  #E58A19, #E5C72D, #202020, #E5E5E5
};

color[] paletaPantalon = {
  #1E1E1E, #34495E, #2850B4, #7B35B5,
  #168A55, #8B4513, #B5B5B5, #E5E5E5
};

color[] paletaPiel = {
  #F5D0A9, #E6BE96, #C8A082, #A87552,
  #805333, #633D2E, #E0A080, #D99A8C
};

color[] paletaPelo = {
  #3C281E, #171717, #704020, #D6A52D,
  #B5B5B5, #E5E5E5, #B52B35, #354B8C
};


// Configura la ventana, carga los recursos y conecta la base de datos.
void setup() {

  size(800, 600);

  menu = loadImage("Menu.png");

  escenarios[0] = loadImage("Escenario1.jpg");
  escenarios[1] = loadImage("Escenario2.jpg");
  escenarios[2] = loadImage("Escenario3.jpg");

  controles = loadImage("Controles.jpg");
  historia = loadImage("Historia.jpg");

  avatarVista = new Jugador(0, 0);

  baseDatos = new BaseDatos();

  if (baseDatos.conectar()) {
    mejorTiempo = baseDatos.obtenerRecord();
  }
}


// Inicializa los objetos y valores necesarios para comenzar una partida.
void iniciarJuego() {

  int escenarioSeleccionado = int(random(escenarios.length));

  fondoEscenario = escenarios[escenarioSeleccionado];

  mapa = new Mapa();

  jugador = new Jugador(width / 2, height / 2);

  linterna = new Linterna(180);

  sistemaParticulas = new SistemaParticulas(30);

  gameOver = false;
  victoria = false;

  tiempoInicio = millis();
  tiempoFinal = 0;
  tiempoRegistrado = false;
}


// Reinicia los objetos de la partida y vuelve a la pantalla principal.
void volverAlMenu() {

  pantalla = 0;

  gameOver = false;
  victoria = false;

  jugador = null;
  mapa = null;
  linterna = null;
  sistemaParticulas = null;

  fondoEscenario = null;
}


// Actualiza los colores del avatar según las opciones seleccionadas.
void actualizarColorAvatar() {

  colorRemera = paletaRemera[indicesColores[0]];
  colorPantalon = paletaPantalon[indicesColores[1]];
  colorPiel = paletaPiel[indicesColores[2]];
  colorPelo = paletaPelo[indicesColores[3]];

  avatarVista.actualizarColores(
    colorRemera,
    colorPantalon,
    colorPiel,
    colorPelo
    );
}


// Convierte el tiempo en milisegundos a minutos, segundos y centésimas.
String formatearTiempo(long tiempo) {

  long minutos = tiempo / 60000;
  long segundos = (tiempo % 60000) / 1000;
  long centesimas = (tiempo % 1000) / 10;

  return nf((int)minutos, 2) + ":" +
    nf((int)segundos, 2) + ":" +
    nf((int)centesimas, 2);
}


// Controla qué pantalla se muestra según el estado actual del juego.
void draw() {

  if (pantalla == 0) {
    dibujarMenu();
    return;
  }

  if (pantalla == 1) {
    dibujarDificultad();
    return;
  }

  if (pantalla == 2) {
    dibujarSkins();
    return;
  }

  if (pantalla == 3) {
    jugar();
    return;
  }

  if (pantalla == 4) {
    dibujarControles();
    return;
  }

  if (pantalla == 5) {
    dibujarHistoria();
    return;
  }
}


// Dibuja el menú principal y resalta la opción seleccionada.
void dibujarMenu() {

  if (menu != null) {
    image(menu, 0, 0, width, height);
  } else {
    background(15, 15, 25);
  }

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(28);

  text("JUGAR", width / 2, 380);
  text("PERSONALIZAR", width / 2, 430);
  text("CONTROLES", width / 2, 480);
  text("SALIR", width / 2, 530);

  noFill();
  stroke(255);

  rect(
    width / 2 - 130,
    360 + opcionMenu * 50,
    260,
    40
    );

  noStroke();

  textAlign(LEFT, BASELINE);
}


// Muestra las opciones de dificultad disponibles.
void dibujarDificultad() {

  background(0);

  fill(255);
  textAlign(CENTER, CENTER);

  textSize(45);
  text("DIFICULTAD", width / 2, 130);

  textSize(28);
  text("FÁCIL", width / 2, 260);
  text("NORMAL", width / 2, 320);
  text("DIFÍCIL", width / 2, 380);

  noFill();
  stroke(255);

  rect(
    width / 2 - 120,
    235 + opcionDificultad * 60,
    240,
    45
    );

  noStroke();

  textSize(18);
  text("ESC para volver", width / 2, 510);

  textAlign(LEFT, BASELINE);
}


// Muestra las opciones de personalización y la vista previa del avatar.
void dibujarSkins() {

  background(15, 15, 25);

  fill(255);
  textAlign(CENTER, CENTER);

  textSize(38);
  text("PERSONALIZAR AVATAR", width / 2, 65);

  String[] partes = {
    "REMERA",
    "PANTALÓN",
    "PIEL",
    "PELO"
  };

  for (int i = 0; i < partes.length; i++) {

    float y = 165 + i * 65;

    if (parteSeleccionada == i) {

      fill(65, 85, 130);
      noStroke();

      rect(75, y - 20, 200, 45, 8);

      fill(255);
    } else {

      fill(170);
    }

    textSize(21);
    text(partes[i], 175, y);
  }


  fill(255);
  textSize(19);
  text("VISTA PREVIA", 430, 145);

  pushMatrix();

  translate(430, 280);
  scale(3);

  avatarVista.dibujar();

  popMatrix();


  fill(255);
  textSize(19);
  text("COLORES", 665, 145);

  for (int i = 0; i < 8; i++) {

    int columna = i % 2;
    int fila = i / 2;

    float x = 615 + columna * 55;
    float y = 185 + fila * 65;

    color c = obtenerColorPaleta(parteSeleccionada, i);

    fill(c);
    noStroke();

    rect(x, y, 40, 40, 6);

    if (indicesColores[parteSeleccionada] == i) {

      noFill();
      stroke(255);
      strokeWeight(3);

      rect(x - 3, y - 3, 46, 46, 7);

      strokeWeight(1);
    }
  }


  fill(200);
  textSize(15);

  text("↑ ↓ Seleccionar parte", width / 2, 500);
  text("← → Cambiar color", width / 2, 525);
  text("ESC Volver al menú", width / 2, 555);

  textAlign(LEFT, BASELINE);
}


// Obtiene el color correspondiente a la parte del avatar y al índice seleccionado.
color obtenerColorPaleta(int parte, int indice) {

  if (parte == 0) {
    return paletaRemera[indice];
  }

  if (parte == 1) {
    return paletaPantalon[indice];
  }

  if (parte == 2) {
    return paletaPiel[indice];
  }

  return paletaPelo[indice];
}


// Muestra la imagen con las instrucciones de los controles.
void dibujarControles() {

  if (controles != null) {
    image(controles, 0, 0, width, height);
  } else {

    background(0);

    fill(255);
    textAlign(CENTER, CENTER);
    text("No se pudo cargar la imagen de controles", width / 2, height / 2);
  }

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(18);

  text("ESC para volver al menú", width / 2, height - 25);

  textAlign(LEFT, BASELINE);
}


// Muestra la historia del juego y la indicación para comenzar.
void dibujarHistoria() {

  if (historia != null) {
    image(historia, 0, 0, width, height);
  } else {

    background(0);

    fill(255);
    textAlign(CENTER, CENTER);
    text("No se pudo cargar la imagen de historia", width / 2, height / 2);
  }

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(22);

  text("PRESIONA ENTER PARA COMENZAR", width / 2, height - 30);

  textAlign(LEFT, BASELINE);
}


// Actualiza los elementos de la partida, controla los estados y dibuja el juego.
void jugar() {

  if (gameOver) {

    dibujarGameOver();

    if (millis() - tiempoPantallaFinal >= duracionPantallaFinal) {
      volverAlMenu();
    }

    return;
  }

  if (victoria) {

    dibujarVictoria();

    if (millis() - tiempoPantallaFinal >= duracionPantallaFinal) {
      volverAlMenu();
    }

    return;
  }


  jugador.mover();

  mapa.limitarColisiones(jugador);
  mapa.actualizarEnemigos(jugador);
  mapa.actualizarBebidas(jugador);
  mapa.actualizarPilas(jugador, linterna, sistemaParticulas);

  sistemaParticulas.actualizar();


  if (mapa.enemigoAlcanzoJugador(jugador)) {

    tiempoFinal = millis() - tiempoInicio;

    gameOver = true;
    tiempoPantallaFinal = millis();

    return;
  }


  mapa.dibujarSalaActual();
  mapa.dibujarEnemigos();
  mapa.dibujarBebidas();
  mapa.dibujarPilas();
  mapa.dibujarObjetosMovibles();

  sistemaParticulas.dibujar();
  jugador.dibujar();

  mapa.verificarPuertas(jugador);


  if (mapa.jugadorGano()) {

    tiempoFinal = millis() - tiempoInicio;

    if (!tiempoRegistrado) {

      if (baseDatos.guardarSiEsMenor(tiempoFinal)) {

        mejorTiempo = tiempoFinal;

        println("¡Nuevo récord!");
      }

      tiempoRegistrado = true;
    }

    victoria = true;
    tiempoPantallaFinal = millis();

    return;
  }


  linterna.aplicar(jugador.x, jugador.y);

  fill(255);
  textSize(20);

  text("Sala: (" + mapa.fila + ", " + mapa.columna + ")", 20, 30);

  text("Tiempo: " + formatearTiempo(millis() - tiempoInicio), 20, 60);

  if (mejorTiempo > 0) {
    text("Récord: " + formatearTiempo(mejorTiempo), 20, 90);
  }
}


long finPausaEnemigos = 0;


// Establece el momento en que los enemigos podrán volver a moverse.
void pausarEnemigos(int duracion) {

  finPausaEnemigos = millis() + duracion;
}


// Muestra la pantalla de derrota con el tiempo de la partida.
void dibujarGameOver() {

  background(0);

  fill(180, 30, 30);
  textAlign(CENTER, CENTER);
  textSize(70);

  text("GAME OVER", width / 2, height / 2 - 70);

  fill(255);
  textSize(24);

  text("Un enemigo te atrapó", width / 2, height / 2 + 10);

  fill(180);
  textSize(18);

  text(
    "Tiempo: " + formatearTiempo(tiempoFinal),
    width / 2,
    height / 2 + 60
    );

  text("Volviendo al menú...", width / 2, height / 2 + 100);

  textAlign(LEFT, BASELINE);
}


// Muestra la pantalla de victoria con el tiempo obtenido y el récord.
void dibujarVictoria() {

  background(0);

  fill(80, 220, 100);
  textAlign(CENTER, CENTER);
  textSize(70);

  text("¡VICTORIA!", width / 2, height / 2 - 100);

  fill(255);
  textSize(24);

  text("Encontraste la salida", width / 2, height / 2 - 35);

  textSize(22);

  text(
    "Tu tiempo: " + formatearTiempo(tiempoFinal),
    width / 2,
    height / 2 + 15
    );

  if (mejorTiempo > 0) {

    text(
      "Récord: " + formatearTiempo(mejorTiempo),
      width / 2,
      height / 2 + 55
      );
  }

  fill(180);
  textSize(18);

  text("Volviendo al menú...", width / 2, height / 2 + 110);

  textAlign(LEFT, BASELINE);
}


// Procesa las teclas presionadas para navegar por los menús y controlar el juego.
void keyPressed() {

  if (key == 'w' || key == 'W') arribaPresionada = true;
  if (key == 's' || key == 'S') abajoPresionada = true;
  if (key == 'a' || key == 'A') izquierdaPresionada = true;
  if (key == 'd' || key == 'D') derechaPresionada = true;

  if (key == CODED) {
    if (keyCode == UP) arribaPresionada = true;
    if (keyCode == DOWN) abajoPresionada = true;
    if (keyCode == LEFT) izquierdaPresionada = true;
    if (keyCode == RIGHT) derechaPresionada = true;
  }


  if (pantalla == 0) {

    if (keyCode == UP) {

      opcionMenu--;

      if (opcionMenu < 0) {
        opcionMenu = 3;
      }
    }

    if (keyCode == DOWN) {

      opcionMenu++;

      if (opcionMenu > 3) {
        opcionMenu = 0;
      }
    }

    if (keyCode == ENTER || keyCode == RETURN) {

      if (opcionMenu == 0) {
        pantalla = 1;
      }

      if (opcionMenu == 1) {
        pantalla = 2;
      }

      if (opcionMenu == 2) {
        pantalla = 4;
      }

      if (opcionMenu == 3) {
        exit();
      }
    }

    return;
  }


  if (pantalla == 1) {

    if (keyCode == UP) {

      opcionDificultad--;

      if (opcionDificultad < 0) {
        opcionDificultad = 2;
      }
    }

    if (keyCode == DOWN) {

      opcionDificultad++;

      if (opcionDificultad > 2) {
        opcionDificultad = 0;
      }
    }

    if (keyCode == ENTER || keyCode == RETURN) {

      if (opcionDificultad == 0) {
        dificultad = 5;
      }

      if (opcionDificultad == 1) {
        dificultad = 10;
      }

      if (opcionDificultad == 2) {
        dificultad = 20;
      }

      pantalla = 5;
    }

    if (keyCode == ESC) {

      key = 0;
      pantalla = 0;
    }

    return;
  }


  if (pantalla == 2) {

    if (keyCode == UP) {

      parteSeleccionada--;

      if (parteSeleccionada < 0) {
        parteSeleccionada = 3;
      }
    }

    if (keyCode == DOWN) {

      parteSeleccionada++;

      if (parteSeleccionada > 3) {
        parteSeleccionada = 0;
      }
    }

    if (keyCode == LEFT) {

      indicesColores[parteSeleccionada]--;

      if (indicesColores[parteSeleccionada] < 0) {
        indicesColores[parteSeleccionada] = 7;
      }

      actualizarColorAvatar();
    }

    if (keyCode == RIGHT) {

      indicesColores[parteSeleccionada]++;

      if (indicesColores[parteSeleccionada] > 7) {
        indicesColores[parteSeleccionada] = 0;
      }

      actualizarColorAvatar();
    }

    if (keyCode == ESC) {

      key = 0;
      pantalla = 0;
    }

    return;
  }


  if (pantalla == 4) {

    if (keyCode == ESC) {

      key = 0;
      pantalla = 0;
    }

    return;
  }


  if (pantalla == 5) {

    if (keyCode == ENTER || keyCode == RETURN) {

      iniciarJuego();

      pantalla = 3;
    }

    if (keyCode == ESC) {

      key = 0;
      pantalla = 1;
    }

    return;
  }
}


// Detecta cuándo se suelta una tecla y actualiza los estados de movimiento.
void keyReleased() {
  if (key == 'w' || key == 'W') arribaPresionada = false;
  if (key == 's' || key == 'S') abajoPresionada = false;
  if (key == 'a' || key == 'A') izquierdaPresionada = false;
  if (key == 'd' || key == 'D') derechaPresionada = false;

  if (key == CODED) {
    if (keyCode == UP) arribaPresionada = false;
    if (keyCode == DOWN) abajoPresionada = false;
    if (keyCode == LEFT) izquierdaPresionada = false;
    if (keyCode == RIGHT) derechaPresionada = false;
  }
}


// Detecta el clic del mouse para interactuar con los objetos del mapa.
void mousePressed() {

  if (pantalla == 3 && !gameOver && !victoria && mapa != null) {
    mapa.mousePresionado();
  }
}


// Permite arrastrar los objetos del mapa mientras se mantiene presionado el mouse.
void mouseDragged() {

  if (pantalla == 3 && !gameOver && !victoria && mapa != null) {
    mapa.mouseArrastrado();
  }
}


// Finaliza la interacción con los objetos al soltar el mouse.
void mouseReleased() {

  if (mapa != null) {
    mapa.mouseSoltado();
  }
}
