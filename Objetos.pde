class ObjetoMovible {

  float x;
  float y;

  float ancho = 46;
  float alto = 38;

  int fila;
  int columna;

  boolean arrastrando = false;

  float distanciaMouseX;
  float distanciaMouseY;


  // Inicializa el objeto en una posición y sala determinadas.
  ObjetoMovible(float x, float y, int fila, int columna) {

    this.x = x;
    this.y = y;

    this.fila = fila;
    this.columna = columna;
  }


  // Dibuja el objeto movible en pantalla.
  void dibujar() {

    rectMode(CENTER);

    stroke(35, 22, 12);
    strokeWeight(3);

    fill(95, 55, 30);
    rect(x, y, ancho, alto, 5);

    stroke(145, 100, 55);
    strokeWeight(3);

    line(x - ancho / 2 + 7, y - alto / 2 + 7,
      x + ancho / 2 - 7, y + alto / 2 - 7);

    line(x + ancho / 2 - 7, y - alto / 2 + 7,
      x - ancho / 2 + 7, y + alto / 2 - 7);

    stroke(45, 28, 15);
    strokeWeight(2);

    noFill();
    rect(x, y, ancho - 10, alto - 10, 3);

    noStroke();

    rectMode(CORNER);
  }


  // Comprueba si el cursor está dentro de los límites del objeto.
  boolean contiene(float mx, float my) {

    return mx >= x - ancho / 2 &&
      mx <= x + ancho / 2 &&
      my >= y - alto / 2 &&
      my <= y + alto / 2;
  }


  // Comienza el arrastre y guarda la distancia respecto al cursor.
  void iniciarArrastre(float mx, float my) {

    arrastrando = true;

    distanciaMouseX = x - mx;
    distanciaMouseY = y - my;
  }



  // Actualiza la posición del objeto mientras se arrastra con el mouse.
  void moverConMouse(float mx, float my) {

    if (!arrastrando) {
      return;
    }

    x = constrain(
      mx + distanciaMouseX,
      ancho / 2,
      width - ancho / 2
      );

    y = constrain(
      my + distanciaMouseY,
      alto / 2,
      height - alto / 2
      );
  }


  // Finaliza el arrastre del objeto.
  void soltar() {

    arrastrando = false;
  }
}
