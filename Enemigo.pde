
class Enemigo {

  float x, y;
  float velocidad = 3;

  int fila;
  int columna;

  float ruidoX;
  float ruidoY;
  float tiempoNoise = 0;

  boolean persiguiendo = false;

  float distanciaDeteccion = 180;


  // Inicializa al enemigo en una posición y sala determinadas.
  Enemigo(float x, float y, int fila, int columna) {
    this.x = x;
    this.y = y;

    this.fila = fila;
    this.columna = columna;

    ruidoX = random(1000);
    ruidoY = random(1000);
  }


  // Actualiza el comportamiento del enemigo y controla sus movimientos y colisiones.
  void actualizar(Jugador jugador, Mapa mapa) {

    if (millis() < finPausaEnemigos) {
      mapa.limitarColisionesEnemigo(this);
      return;
    }

    if (fila < 0 || fila >= mapa.salas.length ||
      columna < 0 || columna >= mapa.salas[0].length) {
      return;
    }
    int distanciaSalas = abs(fila - mapa.fila) +
      abs(columna - mapa.columna);

    if (distanciaSalas > 1) {
      persiguiendo = false;
    }

    if (fila == mapa.fila && columna == mapa.columna) {
      float distancia = dist(x, y, jugador.x, jugador.y);

      if (distancia <= distanciaDeteccion) {
        persiguiendo = true;
      }
    }

    if (persiguiendo) {
      perseguirJugador(jugador, mapa);
    } else {
      movimientoNoise(mapa);
    }

    verificarPuerta(mapa);
    mapa.limitarColisionesEnemigo(this);
  }


  // Genera un movimiento aleatorio utilizando la función de ruido Perlin.
  void movimientoNoise(Mapa mapa) {

    tiempoNoise += 0.01;

    float dirX = map(noise(ruidoX, tiempoNoise), 0, 1, -1, 1);
    float dirY = map(noise(ruidoY, tiempoNoise), 0, 1, -1, 1);

    PVector direccion = new PVector(dirX, dirY);

    if (direccion.mag() > 0) {
      direccion.normalize();

      x += direccion.x * velocidad;
      y += direccion.y * velocidad;
    }

    Sala salaActual = mapa.salas[fila][columna];

    if (x > width - 15 && !salaActual.puertaDerecha) {
      x = width - 15;
    }

    if (x < 15 && !salaActual.puertaIzquierda) {
      x = 15;
    }

    if (y > height - 15 && !salaActual.puertaAbajo) {
      y = height - 15;
    }

    if (y < 15 && !salaActual.puertaArriba) {
      y = 15;
    }
  }


  // Persigue al jugador dentro de la sala o se dirige hacia su ubicación.
  void perseguirJugador(Jugador jugador, Mapa mapa) {

    if (fila == mapa.fila && columna == mapa.columna) {
      perseguirDentroDeSala(jugador);
      return;
    }

    int diferenciaFila = mapa.fila - fila;
    int diferenciaColumna = mapa.columna - columna;

    Sala salaActual = mapa.salas[fila][columna];

    if (diferenciaFila > 0 && salaActual.puertaAbajo) {
      irHaciaPuertaAbajo();
    } else if (diferenciaFila < 0 && salaActual.puertaArriba) {
      irHaciaPuertaArriba();
    } else if (diferenciaColumna > 0 && salaActual.puertaDerecha) {
      irHaciaPuertaDerecha();
    } else if (diferenciaColumna < 0 && salaActual.puertaIzquierda) {
      irHaciaPuertaIzquierda();
    } else {
      movimientoNoise(mapa);
    }
  }


  // Calcula la dirección y avanza directamente hacia el jugador.
  void perseguirDentroDeSala(Jugador jugador) {

    PVector direccion = new PVector(
      jugador.x - x,
      jugador.y - y
      );

    if (direccion.mag() > 0) {
      direccion.normalize();
      direccion.mult(velocidad);

      x += direccion.x;
      y += direccion.y;
    }

    x = constrain(x, 15, width - 15);
    y = constrain(y, 15, height - 15);
  }


  // Dirige al enemigo hacia la puerta superior.
  void irHaciaPuertaArriba() {
    moverHacia(width / 2, 0);
  }


  // Dirige al enemigo hacia la puerta inferior.
  void irHaciaPuertaAbajo() {
    moverHacia(width / 2, height);
  }


  // Dirige al enemigo hacia la puerta izquierda.
  void irHaciaPuertaIzquierda() {
    moverHacia(0, height / 2);
  }


  // Dirige al enemigo hacia la puerta derecha.
  void irHaciaPuertaDerecha() {
    moverHacia(width, height / 2);
  }


  // Calcula el desplazamiento necesario para alcanzar una posición determinada.
  void moverHacia(float objetivoX, float objetivoY) {

    PVector direccion = new PVector(
      objetivoX - x,
      objetivoY - y
      );

    if (direccion.mag() > 0) {
      direccion.normalize();
      direccion.mult(velocidad);

      x += direccion.x;
      y += direccion.y;
    }
  }


  // Comprueba si el enemigo puede atravesar una puerta y actualiza su sala.
  void verificarPuerta(Mapa mapa) {

    Sala s = mapa.salas[fila][columna];

    if (x > width && s.puertaDerecha &&
      !mapa.puertaBloqueada(fila, columna, "derecha")) {

      columna++;
      x = 5;
      y = height / 2;
      return;
    } else if (x > width - 10 && !s.puertaDerecha) {
      x = width - 10;
    }

    if (x < 0 && s.puertaIzquierda &&
      !mapa.puertaBloqueada(fila, columna, "izquierda")) {

      columna--;
      x = width - 5;
      y = height / 2;
      return;
    } else if (x < 10 && !s.puertaIzquierda) {
      x = 10;
    }

    if (y > height && s.puertaAbajo &&
      !mapa.puertaBloqueada(fila, columna, "abajo")) {

      fila++;
      y = 5;
      x = width / 2;
      return;
    } else if (y > height - 10 && !s.puertaAbajo) {
      y = height - 10;
    }

    if (y < 0 && s.puertaArriba &&
      !mapa.puertaBloqueada(fila, columna, "arriba")) {

      fila--;
      y = height - 5;
      x = width / 2;
      return;
    } else if (y < 10 && !s.puertaArriba) {
      y = 10;
    }
  }


  // Dibuja la apariencia del enemigo en su posición actual.
  void dibujar() {

    pushMatrix();

    translate(x, y);

    noStroke();

    fill(0, 0, 0, 65);
    ellipse(0, 13, 25, 9);

    stroke(210, 220, 235);
    strokeWeight(1.2);
    fill(250, 250, 255);

    beginShape();

    vertex(-12, 10);

    bezierVertex(-13, 2, -13, -15, 0, -16);

    bezierVertex(13, -15, 13, 2, 12, 10);

    vertex(7, 6);
    vertex(2, 11);
    vertex(-3, 6);
    vertex(-8, 11);

    endShape(CLOSE);

    noStroke();

    fill(255);
    ellipse(-5, -3, 8, 11);
    ellipse(5, -3, 8, 11);

    fill(35, 65, 120);
    ellipse(-4, -2, 4, 7);
    ellipse(6, -2, 4, 7);

    fill(10, 20, 35);
    ellipse(-4, -2, 2, 4);
    ellipse(6, -2, 2, 4);

    popMatrix();
  }
}
