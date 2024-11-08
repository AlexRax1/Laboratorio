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

        String query = "INSERT INTO Entidades(nit, nombre, tipo, correo, direccion, telefono) VALUES (?, ?, ?, ? , ? ,?)";
        try (Connection con = new Conexion().getConnection(); // Obtener la conexión aquí
                PreparedStatement preparedStatement = con.prepareStatement(query)) {
            preparedStatement.setString(1, entidad.getNit());
            preparedStatement.setString(2, entidad.getNombre());
            preparedStatement.setString(3, entidad.getTipo());
            preparedStatement.setString(4, entidad.getCorreo());
            preparedStatement.setString(5, entidad.getDireccion());
            preparedStatement.setString(6, entidad.getTelefono());
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

    public Entidad datosEntidad(String nit) {
        Entidad entidad = null; // Cambiamos a null, ya que solo queremos una entidad
        String query = "SELECT nombre, direccion, correo, telefono FROM Entidades WHERE nit = ?"; // Seleccionamos solo los campos necesarios

        try (Connection con = new Conexion().getConnection(); // Asegúrate de tener tu método de conexión
                PreparedStatement preparedStatement = con.prepareStatement(query)) {

            preparedStatement.setString(1, nit); // Establece el valor del NIT

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) { // Solo necesitamos una entidad, así que usamos if
                    entidad = new Entidad(); // Creamos una nueva instancia de Entidad
                    entidad.setNit(nit); // Almacenamos el NIT
                    entidad.setNombre(resultSet.getString("nombre"));
                    entidad.setDireccion(resultSet.getString("direccion"));
                    entidad.setCorreo(resultSet.getString("correo"));
                    entidad.setTelefono(resultSet.getString("telefono"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Manejo de errores
        }
        return entidad;
    }

}
