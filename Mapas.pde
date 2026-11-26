
class Mapa {

  boolean[][] existe;
  Sala[][] salas;

  ArrayList<Enemigo> enemigos;
  ArrayList<BebidaEnergetica> bebidas;
  ArrayList<Pila> pilas;
  ArrayList<ObjetoMovible> objetosMovibles;

  ObjetoMovible objetoArrastrado;

  int fila;
  int columna;

  float radioJugador = 10;


  // Genera la estructura del mapa, crea las salas y distribuye sus objetos.
  Mapa() {

    int[][] layout = {
      {1, 1, 1, 0, 0},
      {0, 1, 1, 1, 0},
      {1, 1, 0, 1, 1},
      {1, 0, 1, 1, 1},
      {0, 1, 1, 1, 1}
    };

    int filas = layout.length;
    int columnas = layout[0].length;

    existe = new boolean[filas][columnas];
    salas = new Sala[filas][columnas];

    for (int i = 0; i < filas; i++) {
      for (int j = 0; j < columnas; j++) {
        existe[i][j] = layout[i][j] == 1;
      }
    }

    for (int i = 0; i < filas; i++) {
      for (int j = 0; j < columnas; j++) {

        if (existe[i][j]) {

          boolean arriba = i > 0 && existe[i - 1][j];
          boolean abajo = i < filas - 1 && existe[i + 1][j];
          boolean izquierda = j > 0 && existe[i][j - 1];
          boolean derecha = j < columnas - 1 && existe[i][j + 1];

          salas[i][j] = new Sala(
            arriba,
            abajo,
            izquierda,
            derecha
            );
        }
      }
    }

    boolean encontrada = false;

    for (int i = 0; i < filas && !encontrada; i++) {
      for (int j = 0; j < columnas; j++) {

        if (existe[i][j]) {
          fila = i;
          columna = j;
          encontrada = true;
          break;
        }
      }
    }

    asignarTipos();

    enemigos = new ArrayList<Enemigo>();
    bebidas = new ArrayList<BebidaEnergetica>();
    pilas = new ArrayList<Pila>();
    objetosMovibles = new ArrayList<ObjetoMovible>();

    crearContenido();
    crearObjetosMovibles();
  }


  // Asigna aleatoriamente los tipos de sala y selecciona una sala de victoria.
  void asignarTipos() {

    ArrayList<int[]> extremos = new ArrayList<int[]>();

    for (int i = 0; i < salas.length; i++) {
      for (int j = 0; j < salas[0].length; j++) {

        if (!existe[i][j]) {
          continue;
        }

        if (i == fila && j == columna) {
          continue;
        }

        boolean arriba = i > 0 && existe[i - 1][j];
        boolean abajo = i < salas.length - 1 && existe[i + 1][j];
        boolean izquierda = j > 0 && existe[i][j - 1];
        boolean derecha = j < salas[0].length - 1 && existe[i][j + 1];

        int vecinos = 0;

        if (arriba) vecinos++;
        if (abajo) vecinos++;
        if (izquierda) vecinos++;
        if (derecha) vecinos++;

        if (vecinos == 1) {
          extremos.add(new int[] {i, j});
        }
      }
    }

    if (extremos.size() > 0) {

      int indice = int(random(extremos.size()));
      int[] victoria = extremos.get(indice);

      salas[victoria[0]][victoria[1]].tipo = "Victoria";

    } else {

      for (int i = 0; i < salas.length; i++) {
        for (int j = 0; j < salas[0].length; j++) {

          if (existe[i][j] && !(i == fila && j == columna)) {
            salas[i][j].tipo = "Victoria";
            return;
          }
        }
      }
    }

    for (int i = 0; i < salas.length; i++) {
      for (int j = 0; j < salas[0].length; j++) {

        if (!existe[i][j]) {
          continue;
        }

        if (salas[i][j].tipo.equals("Victoria")) {
          continue;
        }

        int tipo = int(random(3));

        if (tipo == 0) {
          salas[i][j].tipo = "Normal";
        } else if (tipo == 1) {
          salas[i][j].tipo = "Fortuna";
        } else {
          salas[i][j].tipo = "Peligro";
        }
      }
    }
  }


  // Recorre las salas y crea los elementos correspondientes a cada tipo.
  void crearContenido() {

    for (int i = 0; i < salas.length; i++) {
      for (int j = 0; j < salas[0].length; j++) {

        if (!existe[i][j]) {
          continue;
        }

        if (salas[i][j].tipo.equals("Fortuna")) {
          crearObjetoFortuna(i, j);
        } else if (salas[i][j].tipo.equals("Peligro")) {
          crearEnemigosSala(i, j);
        }
      }
    }
  }


  // Genera aleatoriamente una bebida energética o una pila.
  void crearObjetoFortuna(int f, int c) {

    float x = random(70, width - 70);
    float y = random(70, height - 70);

    int objeto = int(random(2));

    if (objeto == 0) {

      int tipoMonster = generarTipoMonster();

      bebidas.add(new BebidaEnergetica(x, y, f, c, tipoMonster));

    } else {

      pilas.add(new Pila(x, y, f, c));
    }
  }


  // Determina el tipo de bebida energética según sus probabilidades.
  int generarTipoMonster() {

    float probabilidad = random(100);

    if (probabilidad < 50) {
      return 0;
    } else if (probabilidad < 75) {
      return 1;
    } else if (probabilidad < 95) {
      return 2;
    } else {
      return 3;
    }
  }


  // Crea una cantidad aleatoria de enemigos dentro de una sala peligrosa.
  void crearEnemigosSala(int f, int c) {

    int cantidad = int(random(1, 3));

    for (int i = 0; i < cantidad; i++) {

      float x = random(50, width - 50);
      float y = random(50, height - 50);

      enemigos.add(new Enemigo(x, y, f, c));
    }
  }


  // Distribuye objetos movibles aleatoriamente por las salas disponibles.
  void crearObjetosMovibles() {

    for (int i = 0; i < salas.length; i++) {
      for (int j = 0; j < salas[0].length; j++) {

        if (!existe[i][j]) {
          continue;
        }

        if (i == fila && j == columna) {
          continue;
        }

        if (random(100) < 35) {

          int cantidad = random(100) < 20 ? 2 : 1;

          for (int k = 0; k < cantidad; k++) {
            crearObjetoMovible(i, j);
          }
        }
      }
    }
  }


  // Busca una posición libre para crear un objeto movible.
  void crearObjetoMovible(int f, int c) {

    for (int intento = 0; intento < 40; intento++) {

      float x = random(100, width - 100);
      float y = random(100, height - 100);

      if (!posicionLibreObjeto(x, y, f, c)) {
        continue;
      }

      objetosMovibles.add(new ObjetoMovible(x, y, f, c));
      return;
    }
  }


  // Comprueba que una posición no esté ocupada ni bloquee una puerta.
  boolean posicionLibreObjeto(float x, float y, int f, int c) {

    float margenPuerta = 85;

    boolean cercaPuertaHorizontal =
      (x < margenPuerta || x > width - margenPuerta) &&
      abs(y - height / 2) < 40 + 25;

    boolean cercaPuertaVertical =
      (y < margenPuerta || y > height - margenPuerta) &&
      abs(x - width / 2) < 40 + 25;

    if (cercaPuertaHorizontal || cercaPuertaVertical) {
      return false;
    }

    if (f == fila && c == columna &&
      dist(x, y, width / 2, height / 2) < 100) {
      return false;
    }

    for (ObjetoMovible objeto : objetosMovibles) {

      if (objeto.fila == f && objeto.columna == c) {

        if (dist(x, y, objeto.x, objeto.y) < 65) {
          return false;
        }
      }
    }

    for (Enemigo enemigo : enemigos) {

      if (enemigo.fila == f && enemigo.columna == c) {

        if (dist(x, y, enemigo.x, enemigo.y) < 55) {
          return false;
        }
      }
    }

    for (BebidaEnergetica bebida : bebidas) {

      if (bebida.fila == f && bebida.columna == c) {

        if (dist(x, y, bebida.x, bebida.y) < 45) {
          return false;
        }
      }
    }

    for (Pila pila : pilas) {

      if (pila.fila == f && pila.columna == c) {

        if (dist(x, y, pila.x, pila.y) < 45) {
          return false;
        }
      }
    }

    return true;
  }


  // Dibuja la sala en la que se encuentra actualmente el jugador.
  void dibujarSalaActual() {
    salas[fila][columna].dibujar();
  }


  // Actualiza el comportamiento de todos los enemigos.
  void actualizarEnemigos(Jugador jugador) {

    for (Enemigo enemigo : enemigos) {
      enemigo.actualizar(jugador, this);
    }
  }


  // Dibuja únicamente los enemigos que están en la sala actual.
  void dibujarEnemigos() {

    for (Enemigo enemigo : enemigos) {

      if (enemigo.fila == fila && enemigo.columna == columna) {
        enemigo.dibujar();
      }
    }
  }


  // Comprueba si el jugador recoge alguna bebida energética.
  void actualizarBebidas(Jugador jugador) {
    for (BebidaEnergetica bebida : bebidas) {
      if (bebida.fila == fila && bebida.columna == columna) {
        bebida.comprobarJugador(jugador);
      }
    }
  }


  // Dibuja las bebidas energéticas que están en la sala actual.
  void dibujarBebidas() {

    for (BebidaEnergetica bebida : bebidas) {

      if (bebida.fila == fila && bebida.columna == columna) {
        bebida.dibujar();
      }
    }
  }


  // Comprueba si el jugador recoge alguna pila y aplica sus efectos.
  void actualizarPilas(Jugador jugador, Linterna linterna, SistemaParticulas sistemaParticulas) {

    for (Pila pila : pilas) {

      if (pila.fila == fila && pila.columna == columna) {
        pila.comprobarJugador(jugador, linterna, sistemaParticulas);
      }
    }
  }


  // Dibuja las pilas que están en la sala actual.
  void dibujarPilas() {

    for (Pila pila : pilas) {

      if (pila.fila == fila && pila.columna == columna) {
        pila.dibujar();
      }
    }
  }


  // Dibuja los objetos movibles que pertenecen a la sala actual.
  void dibujarObjetosMovibles() {

    for (ObjetoMovible objeto : objetosMovibles) {

      if (objeto.fila == fila && objeto.columna == columna) {
        objeto.dibujar();
      }
    }
  }


  // Detecta si se hizo clic sobre un objeto movible para comenzar a arrastrarlo.
  void mousePresionado() {

    objetoArrastrado = null;

    for (int i = objetosMovibles.size() - 1; i >= 0; i--) {

      ObjetoMovible objeto = objetosMovibles.get(i);

      if (objeto.fila == fila && objeto.columna == columna) {

        if (objeto.contiene(mouseX, mouseY)) {
          objetoArrastrado = objeto;
          objeto.iniciarArrastre(mouseX, mouseY);
          break;
        }
      }
    }
  }


  // Actualiza la posición del objeto mientras se arrastra con el mouse.
  void mouseArrastrado() {

    if (objetoArrastrado != null) {
      objetoArrastrado.moverConMouse(mouseX, mouseY);
    }
  }


  // Finaliza el arrastre y libera el objeto seleccionado.
  void mouseSoltado() {

    if (objetoArrastrado != null) {
      objetoArrastrado.soltar();
      objetoArrastrado = null;
    }
  }


  // Comprueba si algún enemigo alcanzó al jugador.
  boolean enemigoAlcanzoJugador(Jugador jugador) {

    for (Enemigo enemigo : enemigos) {

      if (enemigo.fila == fila && enemigo.columna == columna) {

        float distancia = dist(
          enemigo.x,
          enemigo.y,
          jugador.x,
          jugador.y
          );

        if (distancia < 18) {
          return true;
        }
      }
    }

    return false;
  }


  // Comprueba si el jugador llegó a la sala de victoria.
  boolean jugadorGano() {
    return salas[fila][columna].tipo.equals("Victoria");
  }


  // Limita el movimiento del jugador según las paredes, puertas y objetos.
  void limitarColisiones(Jugador j) {

    Sala s = salas[fila][columna];

    boolean enPuertaHorizontal = j.y > height / 2 - 40 && j.y < height / 2 + 40;
    boolean enPuertaVertical = j.x > width / 2 - 40 && j.x < width / 2 + 40;

    if (j.x - radioJugador < 0 &&
      !(s.puertaIzquierda &&
      enPuertaHorizontal &&
      !puertaBloqueada(fila, columna, "izquierda"))) {

      j.x = radioJugador;
    }

    if (j.x + radioJugador > width &&
      !(s.puertaDerecha &&
      enPuertaHorizontal &&
      !puertaBloqueada(fila, columna, "derecha"))) {

      j.x = width - radioJugador;
    }

    if (j.y - radioJugador < 0 &&
      !(s.puertaArriba &&
      enPuertaVertical &&
      !puertaBloqueada(fila, columna, "arriba"))) {

      j.y = radioJugador;
    }

    if (j.y + radioJugador > height &&
      !(s.puertaAbajo &&
      enPuertaVertical &&
      !puertaBloqueada(fila, columna, "abajo"))) {

      j.y = height - radioJugador;
    }

    limitarColisionesObjetos(j);
  }


  // Evita que el jugador atraviese los objetos movibles.
  void limitarColisionesObjetos(Jugador j) {

    for (ObjetoMovible objeto : objetosMovibles) {

      if (objeto.fila != fila || objeto.columna != columna) {
        continue;
      }

      float izquierda = objeto.x - objeto.ancho / 2;
      float derecha = objeto.x + objeto.ancho / 2;
      float arriba = objeto.y - objeto.alto / 2;
      float abajo = objeto.y + objeto.alto / 2;

      float puntoX = constrain(j.x, izquierda, derecha);
      float puntoY = constrain(j.y, arriba, abajo);

      float dx = j.x - puntoX;
      float dy = j.y - puntoY;

      float distanciaCuadrada = dx * dx + dy * dy;

      if (distanciaCuadrada < radioJugador * radioJugador) {

        if (distanciaCuadrada > 0) {

          float distancia = sqrt(distanciaCuadrada);
          float penetracion = radioJugador - distancia;

          float nx = dx / distancia;
          float ny = dy / distancia;

          j.x += nx * penetracion;
          j.y += ny * penetracion;

          if (abs(nx) > abs(ny)) {
            j.velocidadX = 0;
          } else {
            j.velocidadY = 0;
          }

        } else {

          float distanciaIzquierda = abs(j.x - izquierda);
          float distanciaDerecha = abs(derecha - j.x);
          float distanciaArriba = abs(j.y - arriba);
          float distanciaAbajo = abs(abajo - j.y);

          float menor = min(
            min(distanciaIzquierda, distanciaDerecha),
            min(distanciaArriba, distanciaAbajo)
            );

          if (menor == distanciaIzquierda) {
            j.x = izquierda - radioJugador;
            j.velocidadX = 0;
          } else if (menor == distanciaDerecha) {
            j.x = derecha + radioJugador;
            j.velocidadX = 0;
          } else if (menor == distanciaArriba) {
            j.y = arriba - radioJugador;
            j.velocidadY = 0;
          } else {
            j.y = abajo + radioJugador;
            j.velocidadY = 0;
          }
        }
      }
    }
  }


  // Comprueba si el jugador puede atravesar una puerta y cambia su ubicación.
  void verificarPuertas(Jugador j) {

    Sala s = salas[fila][columna];

    if (j.x > width && s.puertaDerecha) {
      columna++;
      j.x = 5;
    }

    if (j.x < 0 && s.puertaIzquierda) {
      columna--;
      j.x = width - 5;
    }

    if (j.y > height && s.puertaAbajo) {
      fila++;
      j.y = 5;
    }

    if (j.y < 0 && s.puertaArriba) {
      fila--;
      j.y = height - 5;
    }

    j.x = constrain(j.x, -5, width + 5);
    j.y = constrain(j.y, -5, height + 5);
  }


  // Comprueba si un objeto movible está bloqueando una puerta determinada.
  boolean puertaBloqueada(int f, int c, String direccion) {

    for (ObjetoMovible objeto : objetosMovibles) {

      if (objeto.fila != f || objeto.columna != c) {
        continue;
      }

      if (direccion.equals("derecha")) {
        if (objeto.x + objeto.ancho / 2 >= width - 5 &&
          abs(objeto.y - height / 2) < 40 + objeto.alto / 2) {
          return true;
        }
      }

      if (direccion.equals("izquierda")) {
        if (objeto.x - objeto.ancho / 2 <= 5 &&
          abs(objeto.y - height / 2) < 40 + objeto.alto / 2) {
          return true;
        }
      }

      if (direccion.equals("arriba")) {
        if (objeto.y - objeto.alto / 2 <= 5 &&
          abs(objeto.x - width / 2) < 40 + objeto.ancho / 2) {
          return true;
        }
      }

      if (direccion.equals("abajo")) {
        if (objeto.y + objeto.alto / 2 >= height - 5 &&
          abs(objeto.x - width / 2) < 40 + objeto.ancho / 2) {
          return true;
        }
      }
    }

    return false;
  }


  // Evita que los enemigos atraviesen los objetos movibles.
  void limitarColisionesEnemigo(Enemigo enemigo) {

    for (ObjetoMovible objeto : objetosMovibles) {

      if (objeto.fila != enemigo.fila ||
        objeto.columna != enemigo.columna) {
        continue;
      }

      float radio = 10;

      float izquierda = objeto.x - objeto.ancho / 2;
      float derecha = objeto.x + objeto.ancho / 2;
      float arriba = objeto.y - objeto.alto / 2;
      float abajo = objeto.y + objeto.alto / 2;

      float puntoX = constrain(enemigo.x, izquierda, derecha);
      float puntoY = constrain(enemigo.y, arriba, abajo);

      float dx = enemigo.x - puntoX;
      float dy = enemigo.y - puntoY;

      float distanciaCuadrada = dx * dx + dy * dy;

      if (distanciaCuadrada < radio * radio) {

        if (distanciaCuadrada > 0) {

          float distancia = sqrt(distanciaCuadrada);
          float penetracion = radio - distancia;

          float nx = dx / distancia;
          float ny = dy / distancia;

          enemigo.x += nx * penetracion;
          enemigo.y += ny * penetracion;

        } else {

          float izquierdaDist = abs(enemigo.x - izquierda);
          float derechaDist = abs(derecha - enemigo.x);
          float arribaDist = abs(enemigo.y - arriba);
          float abajoDist = abs(abajo - enemigo.y);

          float menor = min(
            min(izquierdaDist, derechaDist),
            min(arribaDist, abajoDist)
            );

          if (menor == izquierdaDist) {
            enemigo.x = izquierda - radio;
          } else if (menor == derechaDist) {
            enemigo.x = derecha + radio;
          } else if (menor == arribaDist) {
            enemigo.y = arriba - radio;
          } else {
            enemigo.y = abajo + radio;
          }
        }
      }
    }
  }
}
