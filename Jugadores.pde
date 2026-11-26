
class Jugador {

  float x, y;

  float velocidadX = 0;
  float velocidadY = 0;

  float direccionX = 0;
  float direccionY = -1;

  float multiplicadorVelocidad = 1;
  long finEfectoVelocidad = 0;

  float velocidadMaxima = 6;

  float faseCaminata = 0;

  boolean moviendose = false;

  color colorRemeraJugador;
  color colorPantalonJugador;
  color colorPielJugador;
  color colorPeloJugador;


  // Inicializa la posición del jugador y sus colores.
  Jugador(float x, float y) {
    this.x = x;
    this.y = y;

    actualizarColores(
      colorRemera,
      colorPantalon,
      colorPiel,
      colorPelo
      );
  }


  // Actualiza los colores de las distintas partes del jugador.
  void actualizarColores(color remera, color pantalon, color piel, color pelo) {
    colorRemeraJugador = remera;
    colorPantalonJugador = pantalon;
    colorPielJugador = piel;
    colorPeloJugador = pelo;
  }


  // Calcula el movimiento del jugador y controla los efectos de velocidad.
  void mover() {
    moviendose = false;

    if (finEfectoVelocidad > 0 && millis() >= finEfectoVelocidad) {
      multiplicadorVelocidad = 1;
      finEfectoVelocidad = 0;
    }

    float movimientoX = 0;
    float movimientoY = 0;

    if (arribaPresionada) movimientoY--;
    if (abajoPresionada) movimientoY++;
    if (izquierdaPresionada) movimientoX--;
    if (derechaPresionada) movimientoX++;

    float magnitud = sqrt(movimientoX * movimientoX + movimientoY * movimientoY);

    if (magnitud > 0) {
      movimientoX /= magnitud;
      movimientoY /= magnitud;

      direccionX = movimientoX;
      direccionY = movimientoY;

      moviendose = true;
    }

    velocidadX = movimientoX * velocidadMaxima * multiplicadorVelocidad;
    velocidadY = movimientoY * velocidadMaxima * multiplicadorVelocidad;

    x += velocidadX;
    y += velocidadY;

    if (moviendose) {
      faseCaminata += 0.25;
    }
  }


  // Dibuja al jugador y genera la animación de movimiento.
  void dibujar() {
    noStroke();

    fill(0, 0, 0, 90);
    ellipse(x, y + 10, 22, 10);

    pushMatrix();

    translate(x, y);
    rotate(atan2(direccionY, direccionX) + HALF_PI);

    float balanceo = moviendose ? sin(faseCaminata) * 5 : 0;

    stroke(colorPantalonJugador);
    strokeWeight(4);

    line(-4, 6, -4 + balanceo, 14);
    line(4, 6, 4 - balanceo, 14);

    noStroke();

    fill(colorRemeraJugador);

    ellipse(-9 - balanceo * 0.5, 2, 6, 12);
    ellipse(9 + balanceo * 0.5, 2, 6, 12);

    fill(colorRemeraJugador);
    ellipse(0, 2, 17, 20);

    fill(lerpColor(colorRemeraJugador, color(255), 0.25));
    ellipse(-2, 0, 8, 14);

    fill(colorPielJugador);
    ellipse(0, -9, 13, 13);

    fill(lerpColor(colorPielJugador, color(255), 0.15));
    ellipse(1, -10, 11, 11);

    fill(colorPeloJugador);
    arc(0, -13, 13, 10, PI, TWO_PI);

    fill(30);
    ellipse(0, -6, 3, 3);

    popMatrix();
  }


  // Aplica un multiplicador de velocidad durante un tiempo determinado.
  void aplicarMultiplicadorVelocidad(float multiplicador, int duracion) {
    multiplicadorVelocidad = multiplicador;
    finEfectoVelocidad = millis() + duracion;
  }
}
