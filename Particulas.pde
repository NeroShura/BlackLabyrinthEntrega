class Particula {

  PVector posicion;
  PVector velocidad;
  float vida;
  float tamano;


  // Inicializa la partícula con una posición, velocidad y duración aleatorias.
  Particula(float x, float y) {

    posicion = new PVector(x, y);

    velocidad = PVector.random2D();
    velocidad.mult(random(0.5, 2));

    vida = 255;
    tamano = random(2, 5);
  }


  // Actualiza la posición, reduce la velocidad y disminuye la vida.
  void actualizar() {

    posicion.add(velocidad);

    velocidad.mult(0.98);

    vida -= 4;
  }


  // Dibuja la partícula con transparencia según su vida restante.
  void dibujar() {

    noStroke();

    fill(255, 220, 120, vida);

    ellipse(
      posicion.x,
      posicion.y,
      tamano,
      tamano
      );
  }


  // Comprueba si la partícula terminó su ciclo de vida.
  boolean muerta() {

    return vida <= 0;
  }
}
