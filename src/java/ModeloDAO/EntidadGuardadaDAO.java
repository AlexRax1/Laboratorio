/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ModeloDAO;

import Config.Conexion;
import Modelo.EntidadGuardada;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author alex1
 */
public class EntidadGuardadaDAO {

    Conexion cn = new Conexion(); // Instancia para obtener la conexión
    
    
    // Método para obtener el nombre de una entidad usando el NIT
    public String obtenerNombreNit(String nit) {
        System.out.println(nit);
        String query = "SELECT nombre FROM EntidadesGuardadas WHERE nit = ?";
        try (Connection con = cn.getConnection(); // Obtener la conexión a la base de datos
             PreparedStatement preparedStatement = con.prepareStatement(query)) {
             
            preparedStatement.setString(1, nit);
            ResultSet resultSet = preparedStatement.executeQuery();
            
            if (resultSet.next()) {
                System.out.println(resultSet.getString("nombre"));
                return resultSet.getString("nombre");
            }
        } catch (SQLException e) {

            e.printStackTrace(); // Manejo de errores
        }
        return null; // Si no se encuentra el NIT, devuelve null
    }

    // Método para obtener una entidad completa usando el NIT
    public EntidadGuardada obtenerPorNit(String nit) {
        String query = "SELECT nit, nombre, direccion, correo, telefono FROM EntidadesGuardadas WHERE nit = ?";
        try (Connection con = cn.getConnection(); // Obtener la conexión a la base de datos
             PreparedStatement preparedStatement = con.prepareStatement(query)) {
             
            preparedStatement.setString(1, nit);
            ResultSet resultSet = preparedStatement.executeQuery();
            
            if (resultSet.next()) {
                return new EntidadGuardada(
                        resultSet.getString("nit"),
                        resultSet.getString("nombre"),
                        resultSet.getString("direccion"),
                        resultSet.getString("correo"),
                        resultSet.getString("telefono")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Manejo de errores
        }
        return null; // Si no se encuentra el NIT, devuelve null
    }
}