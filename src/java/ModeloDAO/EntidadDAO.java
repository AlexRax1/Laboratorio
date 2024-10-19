/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ModeloDAO;

import Config.Conexion;
import Modelo.Entidad;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author alex1
 */
public class EntidadDAO {
    
    public void guardarEntidad(Entidad entidad) {
        
        
        System.out.println("hasta aca llega a guardar la entidad");
        System.out.println(entidad);
        String query = "INSERT INTO Entidades(nit, nombre, tipo) VALUES (?, ?, ?)";
        try (Connection con = new Conexion().getConnection(); // Obtener la conexión aquí
             PreparedStatement preparedStatement = con.prepareStatement(query)) {
            preparedStatement.setString(1, entidad.getNit());
            preparedStatement.setString(2, entidad.getNombre());
            preparedStatement.setString(3, entidad.getTipo());
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean existenciaNit(String nit) {
        String query = "SELECT * from Entidades where nit = ?";
        try (Connection con = new Conexion().getConnection(); // Obtener la conexión aquí
             PreparedStatement preparedStatement = con.prepareStatement(query)) {
            preparedStatement.setString(1, nit);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return true; // NIT encontrado
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; // NIT no encontrado
    }
    
    public List<Entidad> obtenerEntidadesPrivadas() {
        List<Entidad> entidades = new ArrayList<>();
        String query = "SELECT nit, nombre FROM Entidades where tipo = 'privada'"; // Ajusta tu consulta según la estructura de tu tabla

        try (Connection con = new Conexion().getConnection(); // Asegúrate de tener tu método de conexión
             PreparedStatement preparedStatement = con.prepareStatement(query);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                Entidad entidad = new Entidad();
                entidad.setNit(resultSet.getString("nit"));
                entidad.setNombre(resultSet.getString("nombre"));
                // Si tienes más campos, añádelos aquí
                entidades.add(entidad);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Manejo de errores
        }
        return entidades;
    }
    public List<Entidad> obtenerEntidadesPublicas() {
        List<Entidad> entidades = new ArrayList<>();
        String query = "SELECT nit, nombre FROM Entidades where tipo = 'publica'"; // Ajusta tu consulta según la estructura de tu tabla

        try (Connection con = new Conexion().getConnection(); // Asegúrate de tener tu método de conexión
             PreparedStatement preparedStatement = con.prepareStatement(query);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                Entidad entidad = new Entidad();
                entidad.setNit(resultSet.getString("nit"));
                entidad.setNombre(resultSet.getString("nombre"));
                // Si tienes más campos, añádelos aquí
                entidades.add(entidad);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Manejo de errores
        }
        return entidades;
    }
    
    
}
