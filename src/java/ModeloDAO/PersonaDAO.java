/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ModeloDAO;

import Config.Conexion;
import Modelo.Persona;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author alex1
 */
public class PersonaDAO {
    // Método para validar el login
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    public boolean validar(Persona persona) {
        String sql = "SELECT rol FROM persona WHERE usuario = ? AND password = ?";
        try {
            con = new Conexion().getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, persona.getUsuario());
            ps.setString(2, persona.getPassword());
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                persona.setRol(rs.getInt("rol")); // Asigna el rol al objeto persona
                return true; // Usuario y contraseña válidos
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Imprime cualquier error
        }
        return false; // Usuario o contraseña incorrectos
    }


}
