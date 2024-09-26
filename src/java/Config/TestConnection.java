/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Config;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/testConnection")
public class TestConnection extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Connection connection = null;
        try {
            // Obtener el contexto JNDI
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            DataSource ds = (DataSource) envContext.lookup("jdbc/PostgresDB");

            // Obtener la conexión
            connection = ds.getConnection();
            System.out.println("prubea coneccion");
            if (connection != null) {
                response.getWriter().println("Conexión exitosa a la base de datos.");
            } else {
                response.getWriter().println("No se pudo obtener la conexión.");
            }
        } catch (NamingException | SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error en la conexión: " + e.getMessage());
        } finally {
            if (connection != null) {
                try {
                    
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}