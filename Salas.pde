class Sala {

  color colorPiso;

  boolean puertaArriba;
  boolean puertaAbajo;
  boolean puertaIzquierda;
  boolean puertaDerecha;

  String tipo;


  // Inicializa la sala, su color de piso y las puertas disponibles.
  Sala(boolean arriba, boolean abajo, boolean izquierda, boolean derecha) {

    colorPiso = color(
      random(15, 35),
      random(15, 35),
      random(20, 40)
      );

    puertaArriba = arriba;
    puertaAbajo = abajo;
    puertaIzquierda = izquierda;
    puertaDerecha = derecha;

    tipo = "Normal";
  }


  // Dibuja el fondo de la sala y sus cuatro paredes.
  void dibujar() {

    if (fondoEscenario != null) {
      image(fondoEscenario, 0, 0, width, height);

      noStroke();
      fill(0, 0, 0, 100);
      rect(0, 0, width, height);
    } else {
      background(colorPiso);
    }

    dibujarPared(0, 0, width, 0, puertaArriba, true);
    dibujarPared(0, height, width, height, puertaAbajo, true);
    dibujarPared(0, 0, 0, height, puertaIzquierda, false);
    dibujarPared(width, 0, width, height, puertaDerecha, false);
  }


  // Dibuja una pared y deja un espacio para la puerta si corresponde.
  void dibujarPared(float x1, float y1, float x2, float y2, boolean tienePuerta, boolean horizontal) {

    stroke(90);
    strokeWeight(6);

    if (!tienePuerta) {

      line(x1, y1, x2, y2);

      return;
    }


    if (horizontal) {

      line(x1, y1, width / 2 - 40, y1);
      line(width / 2 + 40, y1, x2, y2);
    } else {

      line(x1, y1, x1, height / 2 - 40);
      line(x1, height / 2 + 40, x2, y2);
    }


    strokeWeight(12);
    stroke(120, 80, 40);


    if (horizontal) {

      line(
        width / 2 - 40,
        y1,
        width / 2 + 40,
        y1
        );
    } else {

      line(
        x1,
        height / 2 - 40,
        x1,
        height / 2 + 40
        );
    }
  }
}
