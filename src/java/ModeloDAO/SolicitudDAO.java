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
import java.sql.Timestamp;
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

    public List<Solicitud> buscarSolicitudesMuestraProveedor(String numeroMuestra, String nitProveedor) {
        List<Solicitud> solicitudes = new ArrayList<>();
        StringBuilder query = new StringBuilder(
                "SELECT id_solicitud, fecha, nit_proveedor, nombre_proveedor,numero_muestra, estado_solicitud, estado_muestra, "
                + "estado_porcion, usuario_asignado, rol_usuario "
                + "FROM SolicitudMuestraAnalisis "
                + "WHERE estado_solicitud <> 'Finalizada'");

        // Añadir condiciones según los parámetros ingresados
        if (numeroMuestra != null && !numeroMuestra.isEmpty()) {
            query.append(" AND id_solicitud = ?");
        }
        if (nitProveedor != null && !nitProveedor.isEmpty()) {
            query.append(" AND nit_proveedor = ?");
        }

        try (Connection con = cn.getConnection();
                PreparedStatement preparedStatement = con.prepareStatement(query.toString())) {

            int index = 1;
            if (numeroMuestra != null && !numeroMuestra.isEmpty()) {
                preparedStatement.setString(index++, numeroMuestra);
            }
            if (nitProveedor != null && !nitProveedor.isEmpty()) {
                preparedStatement.setString(index++, nitProveedor);
            }

            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                Solicitud solicitud = new Solicitud();
                solicitud.setIdSolicitud(resultSet.getString("id_solicitud"));
                solicitud.setFecha(resultSet.getTimestamp("fecha"));
                solicitud.setNitProveedor(resultSet.getString("nit_proveedor"));
                solicitud.setNombreProveedor(resultSet.getString("nombre_proveedor"));
                solicitud.setNumeroMuestra(resultSet.getString("numero_muestra"));
                solicitud.setEstadoSolicitud(resultSet.getString("estado_solicitud"));
                solicitud.setEstadoMuestra(resultSet.getString("estado_muestra"));
                solicitud.setEstadoPorcion(resultSet.getString("estado_porcion"));
                solicitud.setUsuarioAsignado(resultSet.getString("usuario_asignado"));
                solicitud.setRolUsuario(resultSet.getString("rol_usuario"));

                solicitudes.add(solicitud);
            }

            System.out.println("Solicitudes encontradas: " + solicitudes.size());

        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (solicitudes.isEmpty()) {
            System.out.println("No se encontraron solicitudes.");
        }

        return solicitudes;
    }

    public List<Solicitud> reporteRAnalista(String numeroMuestra, List<String> analistas, String fechaInicio, String fechaFin) {
        List<Solicitud> solicitudes = new ArrayList<>();
        StringBuilder query = new StringBuilder(
                "SELECT id_solicitud, fecha, fecha_fin, nit_proveedor, estado_solicitud, estado_muestra, "
                + "usuario_asignado, tipo_solicitud, nombreSolicitante, descripcion "
                + "FROM SolicitudMuestraAnalisis");

        boolean hasWhere = false; // Para verificar si ya agregamos una cláusula WHERE

        // Condición para el número de muestra
        if (numeroMuestra != null && !numeroMuestra.isEmpty()) {
            query.append(" WHERE id_solicitud = ?");
            hasWhere = true;
        }

        // Condición para la lista de analistas
        if (analistas != null && !analistas.isEmpty()) {
            query.append(hasWhere ? " AND" : " WHERE");
            query.append(" usuario_asignado IN (");

            // Usar StringBuilder para generar los signos de interrogación separados por comas
            StringBuilder placeholders = new StringBuilder();
            for (int i = 0; i < analistas.size(); i++) {
                placeholders.append("?");
                if (i < analistas.size() - 1) {
                    placeholders.append(",");
                }
            }

            query.append(placeholders.toString());
            query.append(")");
            hasWhere = true;
        }

        // Condición para el rango de fechas
        if ((fechaInicio != null && !fechaInicio.isEmpty()) && (fechaFin != null && !fechaFin.isEmpty())) {
            query.append(hasWhere ? " AND" : " WHERE");
            query.append(" fecha BETWEEN ? AND ?");
        }

        try (Connection con = cn.getConnection();
                PreparedStatement preparedStatement = con.prepareStatement(query.toString())) {

            int index = 1;

            // Asignación de parámetros para el número de muestra
            if (numeroMuestra != null && !numeroMuestra.isEmpty()) {
                preparedStatement.setString(index++, numeroMuestra);
            }

            // Asignación de parámetros para los analistas
            if (analistas != null && !analistas.isEmpty()) {
                for (String analista : analistas) {
                    preparedStatement.setString(index++, analista);
                }
            }

            // Asignación de parámetros para el rango de fechas
            if ((fechaInicio != null && !fechaInicio.isEmpty()) && (fechaFin != null && !fechaFin.isEmpty())) {
                preparedStatement.setTimestamp(index++, Timestamp.valueOf(fechaInicio + " 00:00:00"));
                preparedStatement.setTimestamp(index++, Timestamp.valueOf(fechaFin + " 23:59:59"));
            }

            // Ejecutar la consulta
            ResultSet resultSet = preparedStatement.executeQuery();

            // Procesar los resultados
            while (resultSet.next()) {
                Solicitud solicitud = new Solicitud();
                solicitud.setUsuarioAsignado(obtenerNombre(resultSet.getString("usuario_asignado")));
                solicitud.setEstadoMuestra(resultSet.getString("estado_muestra"));
                solicitud.setEstadoSolicitud(resultSet.getString("estado_solicitud"));
                solicitud.setFecha(resultSet.getTimestamp("fecha"));
                solicitud.setIdSolicitud(resultSet.getString("id_solicitud"));
                solicitud.setTipoSolicitud(resultSet.getString("tipo_solicitud"));
                solicitud.setNitProveedor(resultSet.getString("nit_proveedor"));
                solicitud.setNombreSolicitante(resultSet.getString("nombreSolicitante"));
                solicitud.setFechaFin(resultSet.getTimestamp("fecha_fin"));
                solicitud.setDescripcion(resultSet.getString("descripcion"));

                solicitudes.add(solicitud);
            }

            System.out.println("Solicitudes encontradas: " + solicitudes.size());

        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (solicitudes.isEmpty()) {
            System.out.println("No se encontraron solicitudes.");
        }

        return solicitudes;
    }

    
    
    private String obtenerNombre(String nit) {
        String query = "SELECT nombre FROM Usuario WHERE nit = ? ";
        try (Connection con = cn.getConnection(); // Obtener la conexión a la base de datos
                PreparedStatement preparedStatement = con.prepareStatement(query)) {

            preparedStatement.setString(1, nit);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                String nombreU = resultSet.getString("nombre");
                return nombreU;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
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
