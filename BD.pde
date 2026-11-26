
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

class BaseDatos {

  Connection conexion;

  String url = "jdbc:sqlite:" + sketchPath("laberinto.db");

  // Conecta con SQLite y prepara la base de datos si todavía no existe.
  boolean conectar() {

    try {

      Class.forName("org.sqlite.JDBC");

      conexion = DriverManager.getConnection(url);

      Statement sentencia = conexion.createStatement();

      sentencia.executeUpdate(
        "CREATE TABLE IF NOT EXISTS record (" +
        "id INTEGER PRIMARY KEY, " +
        "tiempo_ms INTEGER NOT NULL)"
      );

      sentencia.executeUpdate(
        "INSERT OR IGNORE INTO record (id, tiempo_ms) VALUES (1, 0)"
      );

      sentencia.close();

      println("Base de datos SQLite conectada correctamente.");

      return true;

    } catch (Exception e) {

      println("Error al conectar con SQLite: " + e.getMessage());

      return false;
    }
  }


  // Consulta el mejor tiempo guardado.
  long obtenerRecord() {

    if (conexion == null) {
      return 0;
    }

    String consulta = "SELECT tiempo_ms FROM record WHERE id = 1";

    try (
      PreparedStatement sentencia = conexion.prepareStatement(consulta);
      ResultSet resultado = sentencia.executeQuery()
    ) {

      if (resultado.next()) {
        return resultado.getLong("tiempo_ms");
      }

    } catch (SQLException e) {

      println("Error al consultar el récord: " + e.getMessage());
    }

    return 0;
  }


  // Actualiza el récord únicamente si el nuevo tiempo es menor.
  boolean guardarSiEsMenor(long tiempo) {

    if (conexion == null) {
      return false;
    }

    String consulta =
      "UPDATE record SET tiempo_ms = ? " +
      "WHERE id = 1 AND (tiempo_ms = 0 OR tiempo_ms > ?)";

    try (
      PreparedStatement sentencia = conexion.prepareStatement(consulta)
    ) {

      sentencia.setLong(1, tiempo);
      sentencia.setLong(2, tiempo);

      return sentencia.executeUpdate() > 0;

    } catch (SQLException e) {

      println("Error al guardar el récord: " + e.getMessage());

      return false;
    }
  }
}
