import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

class RegistroRanking {
  int posicion;
  String nombre;
  long tiempoMs;
  String fecha;

  RegistroRanking(int posicion, String nombre, long tiempoMs, String fecha) {
    this.posicion = posicion;
    this.nombre = nombre;
    this.tiempoMs = tiempoMs;
    this.fecha = fecha;
  }
}

class BaseDatos {

  Connection conexion;

  String url = "jdbc:sqlite:" + sketchPath("laberinto.db");

  // Conecta con SQLite y crea la tabla de ranking si no existe.
  boolean conectar() {

    try {

      Class.forName("org.sqlite.JDBC");

      conexion = DriverManager.getConnection(url);

      Statement sentencia = conexion.createStatement();

      sentencia.executeUpdate(
        "CREATE TABLE IF NOT EXISTS ranking (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
        "nombre TEXT NOT NULL UNIQUE, " +
        "tiempo_ms INTEGER NOT NULL, " +
        "fecha TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP)"
      );

      sentencia.close();

      println("Base de datos SQLite conectada correctamente.");

      return true;

    } catch (Exception e) {

      println("Error al conectar con SQLite: " + e.getMessage());

      return false;
    }
  }

  // Guarda un jugador nuevo o actualiza su tiempo si es menor al anterior.
  boolean registrarTiempo(String nombre, long tiempo) {

    if (conexion == null || tiempo <= 0) {
      return false;
    }

    String nombreLimpio = (nombre == null) ? "" : nombre.trim();
    if (nombreLimpio.isEmpty()) {
      nombreLimpio = "Jugador";
    }

    String consultaBuscar = "SELECT tiempo_ms FROM ranking WHERE nombre = ?";

    try (PreparedStatement buscarStmt = conexion.prepareStatement(consultaBuscar)) {

      buscarStmt.setString(1, nombreLimpio);

      try (ResultSet resultado = buscarStmt.executeQuery()) {

        if (resultado.next()) {
          long tiempoActual = resultado.getLong("tiempo_ms");

          if (tiempo < tiempoActual) {
            String consultaActualizar =
              "UPDATE ranking SET tiempo_ms = ?, fecha = datetime('now', 'localtime') " +
              "WHERE nombre = ?";

            try (PreparedStatement actualizarStmt = conexion.prepareStatement(consultaActualizar)) {
              actualizarStmt.setLong(1, tiempo);
              actualizarStmt.setString(2, nombreLimpio);
              return actualizarStmt.executeUpdate() > 0;
            }
          }

          return false;
        }
      }

      String consultaInsertar =
        "INSERT INTO ranking (nombre, tiempo_ms, fecha) " +
        "VALUES (?, ?, datetime('now', 'localtime'))";

      try (PreparedStatement insertarStmt = conexion.prepareStatement(consultaInsertar)) {
        insertarStmt.setString(1, nombreLimpio);
        insertarStmt.setLong(2, tiempo);
        return insertarStmt.executeUpdate() > 0;
      }

    } catch (SQLException e) {

      println("Error al registrar tiempo en el ranking: " + e.getMessage());

      return false;
    }
  }
  // Consulta los mejores N registros ordenados de menor a mayor tiempo.
  ArrayList<RegistroRanking> obtenerTop(int limite) {

    ArrayList<RegistroRanking> lista = new ArrayList<RegistroRanking>();

    if (conexion == null || limite <= 0) {
      return lista;
    }

    String consulta =
      "SELECT nombre, tiempo_ms, fecha " +
      "FROM ranking " +
      "ORDER BY tiempo_ms ASC " +
      "LIMIT ?";

    try (
      PreparedStatement sentencia = conexion.prepareStatement(consulta)
    ) {

      sentencia.setInt(1, limite);

      try (ResultSet resultado = sentencia.executeQuery()) {
        int pos = 1;
        while (resultado.next()) {
          lista.add(new RegistroRanking(
            pos++,
            resultado.getString("nombre"),
            resultado.getLong("tiempo_ms"),
            resultado.getString("fecha")
          ));
        }
      }

    } catch (SQLException e) {

      println("Error al consultar el ranking: " + e.getMessage());
    }

    return lista;
  }

  // Consulta el mejor tiempo general del ranking (0 si aún no hay registros).
  long obtenerMejorRecord() {

    if (conexion == null) {
      return 0;
    }

    String consulta = "SELECT tiempo_ms FROM ranking ORDER BY tiempo_ms ASC LIMIT 1";

    try (
      PreparedStatement sentencia = conexion.prepareStatement(consulta);
      ResultSet resultado = sentencia.executeQuery()
    ) {

      if (resultado.next()) {
        return resultado.getLong("tiempo_ms");
      }

    } catch (SQLException e) {

      println("Error al consultar el mejor récord: " + e.getMessage());
    }

    return 0;
  }

  // Cierra la conexión al finalizar el programa.
  void cerrar() {

    if (conexion != null) {
      try {
        conexion.close();
        conexion = null;
      } catch (SQLException e) {
        println("Error al cerrar la conexión: " + e.getMessage());
      }
    }
  }
}
