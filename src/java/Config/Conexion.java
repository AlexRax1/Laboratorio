
package Config;

import java.sql.*;

public class Conexion {
    
    
    public static Connection getConnection() {
        Connection con = null;
        try {
            // Cargar el driver de PostgreSQL
            Class.forName("org.postgresql.Driver");

            // Establecer la conexión
            con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/progra2prueba", "postgres", "1234");
            System.out.println("Conexión correcta a la base de datos");
        } catch (ClassNotFoundException e) {
            System.err.println("Driver no encontrado: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Error de conexión: " + e.getMessage());
        }
        return con;
    }

}
