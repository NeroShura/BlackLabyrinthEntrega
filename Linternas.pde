
class Linterna {

  PGraphics luz;
  float radio;

  float bateria = 100;

  float consumo = 0.003;


  // Inicializa el radio de iluminación y crea el gráfico de la linterna.
  Linterna(float radio) {

    this.radio = radio;

    luz = createGraphics(width, height);
  }


  // Consume batería y dibuja el efecto de iluminación alrededor del jugador.
  void aplicar(float x, float y) {

    bateria -= consumo;

    bateria = constrain(bateria, 0, 100);

    float intensidad = map(bateria, 0, 60, 3, 2);

    luz.beginDraw();

    luz.clear();

    luz.noStroke();

    for (int r = (int)radio; r > 0; r--) {

      float distancia = r / radio;

      float alpha = map(distancia, 0, 1, 0, intensidad);

      luz.fill(255, 220, 150, alpha);

      luz.ellipse(x, y, r * 2, r * 2);
    }

    luz.endDraw();

    blendMode(ADD);

    image(luz, 0, 0);

    blendMode(BLEND);
  }


  // Restaura la batería de la linterna al máximo.
  void recargar() {

    bateria = 100;
  }
}
