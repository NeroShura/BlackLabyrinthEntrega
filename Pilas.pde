class Pila {

  float x, y;

  int fila;
  int columna;

  boolean recogida = false;

  PImage sprite;


  // Inicializa la pila en una posición y sala determinadas y carga su imagen.
  Pila(float x, float y, int fila, int columna) {

    this.x = x;
    this.y = y;

    this.fila = fila;
    this.columna = columna;

    sprite = loadImage("Pila.png");
  }


  // Dibuja la pila si todavía no fue recogida.
  void dibujar() {

    if (recogida) {
      return;
    }

    imageMode(CENTER);

    image(sprite, x, y, 30, 45);

    imageMode(CORNER);
  }


  // Comprueba si el jugador está lo suficientemente cerca para recoger la pila.
  void comprobarJugador(Jugador jugador, Linterna linterna, SistemaParticulas sistemaParticulas) {

    if (recogida) {
      return;
    }

    float distancia = dist(x, y, jugador.x, jugador.y);

    if (distancia < 25) {
      recoger(linterna, sistemaParticulas);
    }
  }


  // Recarga la linterna y genera partículas al recoger la pila.
  void recoger(Linterna linterna, SistemaParticulas sistemaParticulas) {

    recogida = true;

    linterna.recargar();

    for (int i = 0; i < 15; i++) {
      sistemaParticulas.generar(x, y);
    }
  }
}
