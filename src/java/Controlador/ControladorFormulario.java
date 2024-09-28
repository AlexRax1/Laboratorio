/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controlador;

import Config.Conexion;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;

/**
 *
 * @author alex1
 */
@WebServlet("/ProcesarFormulario")
public class ControladorFormulario extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fechaNacimientoStr = request.getParameter("fechaNacimiento");
        String genero = request.getParameter("genero");

        // Conversión de String a java.sql.Date
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd"); // Asegúrate de usar el formato correcto
        java.sql.Date fechaNacimiento = null;
        try {
            java.util.Date parsedDate = format.parse(fechaNacimientoStr); // Parsear la fecha
            fechaNacimiento = new java.sql.Date(parsedDate.getTime()); // Convertir a java.sql.Date
        } catch (ParseException e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Error en el formato de la fecha.");
            request.getRequestDispatcher("vistas/formulario.jsp").forward(request, response);
            return;
        }

        Conexion conexionDB = new Conexion();
        try (Connection conn = conexionDB.getConnection()) {
            String sql = "INSERT INTO usuarios (nombre, email, password, fecha_nacimiento, genero) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, nombre);
                stmt.setString(2, email);
                stmt.setString(3, password);
                stmt.setDate(4, fechaNacimiento);  // Usa el objeto java.sql.Date
                stmt.setString(5, genero);
                stmt.executeUpdate();
            }

            // Establecer mensaje de éxito
            request.setAttribute("mensaje", "Registro exitoso");

        } catch (SQLException e) {
            e.printStackTrace();
            // Establecer mensaje de error
            request.setAttribute("mensaje", "Error al registrar los datos. Inténtalo de nuevo.");
        }

        // Reenviar la solicitud al JSP original con el mensaje
        request.getRequestDispatcher("vistas/formulario.jsp").forward(request, response);
    }
}
