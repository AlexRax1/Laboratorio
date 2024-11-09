/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controlador;

import Modelo.Solicitud;
import ModeloDAO.SolicitudDAO;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author alex1
 */
@WebServlet(urlPatterns = {"/datosTablaReporteAnalisis"})
public class ControladorReportes extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/datosTablaReporteAnalisis":
                datosRAnalista(request, response);

                break;
            case "/":
                break;

            default:
                response.getWriter().println("Ruta no reconocida");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/":
                break;

        }
    }

    private SolicitudDAO solicitudDAO = new SolicitudDAO();

    private void datosRAnalista(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Obtener los parámetros de búsqueda
        String analistasParam = request.getParameter("analistas"); // Parámetro que viene como un string separado por comas
        String numeroMuestra = request.getParameter("numeroMuestra");
        String fechaInicioi = request.getParameter("fechaInicio");
        String fechaFini = request.getParameter("fechaFin");

        // Convertir el string de analistas a una lista
        List<String> listaAnalistas = new ArrayList<>();
        if (analistasParam != null && !analistasParam.isEmpty()) {
            listaAnalistas = Arrays.asList(analistasParam.split(","));
        }

        try {
            // Obtener los resultados desde el DAO usando los parámetros
            List<Solicitud> solicitudes = solicitudDAO.reporteRAnalista(numeroMuestra, listaAnalistas, fechaInicioi, fechaFini);

            // Si no hay solicitudes, enviar un error
            if (solicitudes.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("[]"); // Devolver un array vacío
                return;
            }

            // Construir la respuesta JSON
            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("[");

            for (int i = 0; i < solicitudes.size(); i++) {
                Solicitud solicitud = solicitudes.get(i);

                // Personalizar el tipo de solicitud
                if (solicitud.getTipoSolicitud() != null) {
                    switch (solicitud.getTipoSolicitud()) {
                        case "AR":
                            solicitud.setTipoSolicitud("Muestra para análisis");
                            break;
                        case "OTM":
                            solicitud.setTipoSolicitud("Solicitud sin Muestra");
                            break;
                        case "PM":
                            solicitud.setTipoSolicitud("Porción de Muestra");
                            break;
                    }
                }

                // Formatear las fechas en un formato legible
                String fechaSolicitud = solicitud.getFecha() != null
                        ? new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(solicitud.getFecha()) : "";
                String fechaFin = solicitud.getFechaFin() != null
                        ? new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(solicitud.getFechaFin()) : "";

                // Construir el objeto JSON para cada solicitud
                jsonBuilder.append("{")
                        .append("\"usuarioAsignado\":\"").append(solicitud.getUsuarioAsignado()).append("\",")
                        .append("\"estadoMuestra\":\"").append(solicitud.getEstadoMuestra()).append("\",")
                        .append("\"estadoSolicitud\":\"").append(solicitud.getEstadoSolicitud()).append("\",")
                        .append("\"fechaSolicitud\":\"").append(fechaSolicitud).append("\",")
                        .append("\"idSolicitud\":\"").append(solicitud.getIdSolicitud()).append("\",")
                        .append("\"tipoSolicitud\":\"").append(solicitud.getTipoSolicitud()).append("\",")
                        .append("\"nitProveedor\":\"").append(solicitud.getNitProveedor()).append("\",")
                        .append("\"nombreSolicitante\":\"").append(solicitud.getNombreSolicitante()).append("\",")
                        .append("\"fechaFin\":\"").append(fechaFin).append("\",")
                        .append("\"descripcion\":\"").append(solicitud.getDescripcion()).append("\"")
                        .append("}");

                // Agregar una coma entre objetos JSON, excepto después del último
                if (i < solicitudes.size() - 1) {
                    jsonBuilder.append(",");
                }
            }

            jsonBuilder.append("]");

            // Enviar la respuesta JSON al cliente
            response.getWriter().write(jsonBuilder.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al obtener las solicitudes.");
        }
    }

}
