
class BebidaEnergetica {

  static final int VERDE = 0;
  static final int AMARILLA = 1;
  static final int AZUL = 2;
  static final int ROJA = 3;

  float x, y;
  int fila;
  int columna;
  int tipo;

  boolean recogida = false;

  PImage sprite;


  // Crea una bebida energética verde por defecto.
  BebidaEnergetica(float x, float y, int fila, int columna) {
    this(x, y, fila, columna, VERDE);
  }


  // Inicializa la bebida y carga la imagen según su tipo.
  BebidaEnergetica(float x, float y, int fila, int columna, int tipo) {

    this.x = x;
    this.y = y;
    this.fila = fila;
    this.columna = columna;
    this.tipo = tipo;

    if (tipo == VERDE) {
      sprite = loadImage("Monster.png");

    } else if (tipo == AMARILLA) {
      sprite = loadImage("MonsterAmarilla.png");

    } else if (tipo == AZUL) {
      sprite = loadImage("MonsterAzul.png");

    } else if (tipo == ROJA) {
      sprite = loadImage("MonsterRoja.png");
    }
  }


  // Dibuja la bebida si todavía no fue recogida.
  void dibujar() {

    if (recogida) return;

    imageMode(CENTER);

    if (sprite != null) {
      image(sprite, x, y, 30, 45);
    }

    imageMode(CORNER);
  }


  // Comprueba si el jugador está lo suficientemente cerca para recogerla.
  void comprobarJugador(Jugador jugador) {

    if (recogida) return;

    float distancia = dist(x, y, jugador.x, jugador.y);

    if (distancia < 25) {
      recoger(jugador);
    }
  }


  // Activa el efecto correspondiente y marca la bebida como recogida.
  void recoger(Jugador jugador) {

    recogida = true;

    if (tipo == VERDE) {

      jugador.aplicarMultiplicadorVelocidad(2, 10000);

    } else if (tipo == ROJA) {

      pausarEnemigos(10000);

    } else if (tipo == AMARILLA) {

      jugador.aplicarMultiplicadorVelocidad(0.5, 5000);

    } else if (tipo == AZUL) {

      jugador.aplicarMultiplicadorVelocidad(4, 5000);
    }
  }
}
