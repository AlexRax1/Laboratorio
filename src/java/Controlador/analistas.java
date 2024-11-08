/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controlador;

import Config.Conexion;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author alex1
 */
@WebServlet(urlPatterns = {"/cargarAnalistas", "/cargarAnalistas2"})
public class analistas extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getServletPath(); // Obtener la URL llamada
        StringBuilder json = new StringBuilder();

        try (Connection con = new Conexion().getConnection()) {
            switch (action) {
                case "/cargarAnalistas":
                    json.append(cargarAnalistas(con));
                    break;

                case "/cargarAnalistas2":
                    String usuarioExcluido = request.getParameter("valor");
                    json.append(cargarAnalistasExcluyendo(con, usuarioExcluido));
                    break;

                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"error\":\"Acción no válida\"}");
                    return;
            }

            out.print(json.toString());
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Error al obtener los datos\"}");
        }
    }

    private String cargarAnalistas(Connection con) throws SQLException {
        StringBuilder json = new StringBuilder();
        json.append("["); // Empieza la estructura JSON

        String sql = "SELECT nombre, nit FROM Usuario where id_rol = 3 AND estado = true";
        try (PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            boolean first = true;
            while (rs.next()) {
                if (!first) {
                    json.append(","); // Agregar coma para separar objetos
                }
                json.append("{");
                json.append("\"nombre\":\"").append(rs.getString("nombre")).append("\",");
                json.append("\"nit\":\"").append(rs.getString("nit")).append("\""); // Agrega el NIT
                json.append("}");
                first = false;
            }
        }
        json.append("]"); // Cierra la estructura JSON como arreglo
        return json.toString();
    }

    private String cargarAnalistasExcluyendo(Connection con, String usuarioExcluido) throws SQLException {
        StringBuilder json = new StringBuilder();
        json.append("["); // Empieza la estructura JSON

        String sql = "SELECT nombre, nit FROM Usuario WHERE nit <> ? AND id_rol = 3 AND estado = true";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usuarioExcluido); // Establecer el parámetro para excluir
            try (ResultSet rs = ps.executeQuery()) {

                boolean first = true;
                while (rs.next()) {
                    if (!first) {
                        json.append(","); // Agregar coma para separar objetos
                    }
                    json.append("{");
                    json.append("\"nombre\":\"").append(rs.getString("nombre")).append("\",");
                    json.append("\"nit\":\"").append(rs.getString("nit")).append("\""); // Agrega el NIT
                    json.append("}");
                    first = false;
                }
            }
        }
        json.append("]"); // Cierra la estructura JSON como arreglo
        return json.toString();
    }
}
