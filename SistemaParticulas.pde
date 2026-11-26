class SistemaParticulas {

  Particula[] particulas;


  // Crea un sistema con una cantidad determinada de partículas.
  SistemaParticulas(int cantidad) {

    particulas = new Particula[cantidad];
  }


  // Busca un espacio disponible y genera una nueva partícula.
  void generar(float x, float y) {

    for (int i = 0; i < particulas.length; i++) {

      if (particulas[i] == null || particulas[i].muerta()) {

        particulas[i] = new Particula(x, y);

        return;
      }
    }
  }


  // Actualiza el estado y movimiento de todas las partículas existentes.
  void actualizar() {

    for (int i = 0; i < particulas.length; i++) {

      if (particulas[i] != null) {
        particulas[i].actualizar();
      }
    }
  }


  // Dibuja las partículas que todavía están activas.
  void dibujar() {

    for (int i = 0; i < particulas.length; i++) {

      if (particulas[i] != null && !particulas[i].muerta()) {
        particulas[i].dibujar();
      }
    }
  }
}
