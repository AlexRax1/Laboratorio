/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ModeloDAO;

import Config.Conexion;
import Modelo.Solicitud;
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
public class SolicitudDAO {

    private Conexion cn = new Conexion(); // Instancia de la conexión a la base de datos

    // Método para buscar todas las solicitudes o filtrarlas con un criterio específico
    public List<Solicitud> buscarSolicitudes(String id_solicitud) {
        List<Solicitud> solicitudes = new ArrayList<>();
        String query = "SELECT nombre_proveedor,nit_proveedor, nit_solicitante, nombreSolicitante, usuario_asignado, "
                + "estado_solicitud, estado_muestra, estado_porcion, tipo_solicitud, rol_usuario "
                + "FROM SolicitudMuestraAnalisis "
                + "WHERE estado_solicitud <> 'Finalizada' AND id_solicitud = ?";

        try (Connection con = cn.getConnection();
                PreparedStatement preparedStatement = con.prepareStatement(query)) {
            preparedStatement.setString(1, id_solicitud);
            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                Solicitud solicitud = new Solicitud();
                // Asignar valores a la solicitud
                solicitud.setNombreProveedor(resultSet.getString("nombre_proveedor"));
                solicitud.setNitProveedor(resultSet.getString("nit_proveedor"));
                solicitud.setNitSolicitante(resultSet.getString("nit_solicitante"));
                solicitud.setNombreSolicitante(resultSet.getString("nombreSolicitante"));
                solicitud.setUsuarioAsignado(resultSet.getString("usuario_asignado"));
                solicitud.setEstadoSolicitud(resultSet.getString("estado_solicitud"));
                solicitud.setEstadoMuestra(resultSet.getString("estado_muestra"));
                solicitud.setEstadoPorcion(resultSet.getString("estado_porcion"));
                solicitud.setTipoSolicitud(resultSet.getString("tipo_solicitud"));
                solicitud.setRolUsuario(resultSet.getString("rol_usuario"));

                solicitudes.add(solicitud);
            }

            // Agrega esta línea para depurar
            System.out.println("Solicitudes encontradas: " + solicitudes.size());

        } catch (SQLException e) {
            e.printStackTrace(); // Manejo de errores
        }

        // Si no se encuentran solicitudes, lanzar una excepción o imprimir un mensaje
        if (solicitudes.isEmpty()) {
            System.out.println("No se encontraron solicitudes para el ID: " + id_solicitud);
        }

        return solicitudes;
    }

    public List<Solicitud> obtenerSolicitudes(String nit) {
        List<Solicitud> solicitudes = new ArrayList<>();
        String query = "SELECT id_solicitud, estado_solicitud, estado_muestra FROM SolicitudMuestraAnalisis WHERE estado_solicitud <> 'Finalizada' AND usuario_asignado = ?";

        try (Connection con = cn.getConnection();
                PreparedStatement preparedStatement = con.prepareStatement(query)) {

            preparedStatement.setString(1, nit);
            ResultSet resultSet = preparedStatement.executeQuery();

            // Verificamos si hay resultados y los procesamos
            while (resultSet.next()) {
                Solicitud solicitud = new Solicitud();
                // Asignar valores a la solicitud
                solicitud.setIdSolicitud(resultSet.getString("id_solicitud"));
                solicitud.setEstadoSolicitud(resultSet.getString("estado_solicitud"));
                solicitud.setEstadoMuestra(resultSet.getString("estado_muestra"));
                solicitudes.add(solicitud);
            }



        } catch (SQLException e) {
            e.printStackTrace(); // Puedes eliminar esto en producción
        }

        return solicitudes;
    }
}
