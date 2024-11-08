/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ModeloDAO;

import Config.Conexion;
import Modelo.Documentos;
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
public class ReasignarDAO {

    private final Conexion cn = new Conexion(); // Usa tu clase de conexión

    // Método para reasignar una solicitud en la tabla SolicitudMuestraAnalisis
    public boolean reasignarSolicitud(String nitN, String idSolicitud) {
        boolean success = false;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            // Obtener conexión a la base de datos
            connection = cn.getConnection(); // Asegúrate de que este método existe

            // Consulta SQL para actualizar el estado de la solicitud
            String sql = "UPDATE SolicitudMuestraAnalisis SET usuario_asignado = ? WHERE id_solicitud = ?"; // Verifica que el nombre sea correcto
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, nitN); // Establece el nuevo NIT asignado
            preparedStatement.setString(2, idSolicitud); // Establece la condición para el update

            // Ejecutar la consulta
            int rowsAffected = preparedStatement.executeUpdate();
            success = rowsAffected > 0; // Si se actualiza al menos una fila, el éxito es verdadero
            
            
            
            //Mandar correo
            RegistrarSolicitudDAO correo = new RegistrarSolicitudDAO();
            correo.emailReasignacion(idSolicitud);
            

        } catch (SQLException e) {
            e.printStackTrace(); // Considera usar un logger para manejar errores
        } finally {
            // Cerrar recursos
            try {
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace(); // Manejar excepciones al cerrar
            }
        }

        return success; // Retorna el resultado de la operación
    }
    
    
    
    
    
    public List<Solicitud> buscarSolicitudesCorreo(String id_solicitud) {
        List<Solicitud> solicitudes = new ArrayList<>();
        String query = "SELECT usuario_asignado, tipo_solicitud, id_solicitud, tipo_doc, numero_doc WHERE estado_solicitud <> 'Finalizada' AND id_solicitud = ?";

        try (Connection con = cn.getConnection();
                PreparedStatement preparedStatement = con.prepareStatement(query)) {
            preparedStatement.setString(1, id_solicitud);
            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                Solicitud solicitud = new Solicitud();
                // Asignar valores a la solicitud
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
    
    
    public Documentos obtenerDocumentos(Documentos doc){
        String query = "SELECT * FROM documentos WHERE id_solicitud = ?";
        String id_solicitud = doc.getIdSolicitud();
        try (Connection con = cn.getConnection();
                PreparedStatement preparedStatement = con.prepareStatement(query)) {
            
            preparedStatement.setString(1, id_solicitud);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                // Asignar valores a la solicitud
                doc.setEtiquetaMuestra(resultSet.getString("etiqueta_muestra"));
                doc.setEtiquetaPorcion(resultSet.getString("etiqueta_porcion"));
                doc.setCertificadoEnsayo(resultSet.getString("certificado_ensayo"));
                doc.setOpinionTecnica(resultSet.getString("opinion_tecnica"));
                doc.setInforme(resultSet.getString("informe"));
                doc.setProvidencia(resultSet.getString("providencia"));
                doc.setDocAnalisis(resultSet.getString("doc_analisis"));
                }

        } catch (SQLException e) {
            e.printStackTrace(); // Manejo de errores
        }
        return doc;
    }
}
