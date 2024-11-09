/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controlador;

import Modelo.Documentos;
import Modelo.Solicitud;
import ModeloDAO.ReasignarDAO;
import ModeloDAO.SolicitudDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.text.SimpleDateFormat;

/**
 *
 * @author alex1
 */
@WebServlet(urlPatterns = {"/buscarSolicitudesRE", "/reasignarUsuario", "/obtenerDocumentos", "/buscarSolicitudesRE2"})
public class ControladorReasignacion extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/buscarSolicitudesRE":
                buscarSolicitud(request, response);
                break;
            case "/buscarSolicitudesRE2":
                buscarSolicitudesRE2(request, response);
                break;
            case "/obtenerDocumentos":
                documentos(request, response);
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
            case "/reasignarUsuario":
                reasignarUsuario(request, response);
                break;
            default:
                break;
        }

    }

    private SolicitudDAO solicitudDAO = new SolicitudDAO(); // Instancia de tu DAO

    private void buscarSolicitud(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Obtener el parámetro idBuscar
        String idBuscar = request.getParameter("idBuscar").toUpperCase();

        try {
            // Obtener los resultados desde el DAO usando el idBuscar
            List<Solicitud> solicitudes = solicitudDAO.buscarSolicitudes(idBuscar);

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

                if (solicitud.getTipoSolicitud().equals("AR")) {
                    solicitud.setTipoSolicitud("Muestra para análisis");
                } else if (solicitud.getTipoSolicitud().equals("OTM")) {
                    solicitud.setTipoSolicitud("Solicitud sin Muestra");
                } else if (solicitud.getTipoSolicitud().equals("PM")) {
                    solicitud.setTipoSolicitud("Porcion de Muestra");
                }

                jsonBuilder.append("{")
                        .append("\"nombreProveedor\":\"").append(solicitud.getNombreProveedor()).append("\",")
                        .append("\"nitProveedor\":\"").append(solicitud.getNitProveedor()).append("\",")
                        .append("\"nitSolicitante\":\"").append(solicitud.getNitSolicitante()).append("\",")
                        .append("\"nombreSolicitante\":\"").append(solicitud.getNombreSolicitante()).append("\",")
                        .append("\"usuario\":\"").append(solicitud.getUsuarioAsignado()).append("\",")
                        .append("\"estadoSolicitud\":\"").append(solicitud.getEstadoSolicitud()).append("\",")
                        .append("\"estadoMuestra\":\"").append(solicitud.getEstadoMuestra()).append("\",")
                        .append("\"estadoPorcion\":\"").append(solicitud.getEstadoPorcion()).append("\",")
                        .append("\"tipoSolicitud\":\"").append(solicitud.getTipoSolicitud()).append("\",")
                        .append("\"rol\":\"").append(solicitud.getRolUsuario()).append("\"")
                        .append("}");

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

    private void buscarSolicitudesRE2(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Obtener los parámetros de búsqueda
        String numeroMuestra = request.getParameter("numeroMuestra");
        String nitProveedor = request.getParameter("nitProveedor");

       

        try {
            // Obtener los resultados desde el DAO usando los parámetros
            List<Solicitud> solicitudes = solicitudDAO.buscarSolicitudesMuestraProveedor(numeroMuestra, nitProveedor);

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

                // Formatear la fecha en un formato legible
                String fechaSolicitud = solicitud.getFecha() != null
                        ? new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(solicitud.getFecha()) : "";

                // Construir el objeto JSON para cada solicitud
                jsonBuilder.append("{")
                        .append("\"idSolicitud\":\"").append(solicitud.getIdSolicitud()).append("\",")
                        .append("\"fechaSolicitud\":\"").append(fechaSolicitud).append("\",")
                        .append("\"nitProveedor\":\"").append(solicitud.getNitProveedor()).append("\",")
                        .append("\"nombreProveedor\":\"").append(solicitud.getNombreProveedor()).append("\",")
                        .append("\"numeroMuestra\":\"").append(solicitud.getNumeroMuestra()).append("\",")
                        .append("\"estadoSolicitud\":\"").append(solicitud.getEstadoSolicitud()).append("\",")
                        .append("\"estadoMuestra\":\"").append(solicitud.getEstadoMuestra()).append("\",")
                        .append("\"estadoPorcionMuestra\":\"").append(solicitud.getEstadoPorcion()).append("\",")
                        .append("\"usuarioAsignado\":\"").append(solicitud.getUsuarioAsignado()).append("\",")
                        .append("\"rolUsuarioAsignado\":\"").append(solicitud.getRolUsuario()).append("\"")
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

    public void reasignarUsuario(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Recuperar el valor del parámetro enviado desde el AJAX
        String usuarioNIT = request.getParameter("usuarioNIT");
        String idSolicitud = request.getParameter("idSolicitud");

        // Validar que el usuarioNIT no esté vacío
        if (usuarioNIT != null && !usuarioNIT.isEmpty()) {
            // Crear instancia del DAO
            ReasignarDAO reasignarSolicitudDAO = new ReasignarDAO();

            // Llamar al método de reasignación
            boolean resultado = reasignarSolicitudDAO.reasignarSolicitud(usuarioNIT, idSolicitud);

            // Preparar respuesta
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();

            if (resultado) {
                // Respuesta exitosa
                response.setStatus(HttpServletResponse.SC_OK);
                out.print("{\"mensaje\": \"Usuario reasignado exitosamente: " + usuarioNIT + "\"}");
            } else {
                // Respuesta de error si la reasignación falla
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"mensaje\": \"Error: No se pudo reasignar el usuario\"}");
            }
            out.flush();
        } else {
            // Preparar respuesta de error si el usuarioNIT está vacío
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            PrintWriter out = response.getWriter();
            out.print("{\"mensaje\": \"Error: usuario NIT no válido\"}");
            out.flush();
        }
    }

    private static final String BASE_URL = "http://localhost:8080/pdfsEtiqueta/";

    private void documentos(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String idSolicitud = request.getParameter("idSolicitud");

        if (idSolicitud == null || idSolicitud.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"El parámetro idSolicitud es requerido.\"}");
            return;
        }

        try {
            Documentos documentos = new Documentos();
            documentos.setIdSolicitud(idSolicitud);
            ReasignarDAO reasignar = new ReasignarDAO();
            reasignar.obtenerDocumentos(documentos);

            // Convertir las rutas de archivos a URLs accesibles
            String etiquetaMuestraUrl = documentos.getEtiquetaMuestra() != null ? BASE_URL + new File(documentos.getEtiquetaMuestra()).getName() : "";
            String etiquetaPorcionUrl = documentos.getEtiquetaPorcion() != null ? BASE_URL + new File(documentos.getEtiquetaPorcion()).getName() : "";
            String certificadoEnsayoUrl = documentos.getCertificadoEnsayo() != null ? BASE_URL + new File(documentos.getCertificadoEnsayo()).getName() : "";
            String opinionTecnicaUrl = documentos.getOpinionTecnica() != null ? BASE_URL + new File(documentos.getOpinionTecnica()).getName() : "";
            String informeUrl = documentos.getInforme() != null ? BASE_URL + new File(documentos.getInforme()).getName() : "";
            String providenciaUrl = documentos.getProvidencia() != null ? BASE_URL + new File(documentos.getProvidencia()).getName() : "";
            String docAnalisisUrl = documentos.getDocAnalisis() != null ? BASE_URL + new File(documentos.getDocAnalisis()).getName() : "";

            // Construcción del JSON manualmente con StringBuilder
            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("{")
                    .append("\"idSolicitud\":\"").append(documentos.getIdSolicitud()).append("\",")
                    .append("\"etiqueta_muestra\":\"").append(etiquetaMuestraUrl).append("\",")
                    .append("\"etiqueta_porcion\":\"").append(etiquetaPorcionUrl).append("\",")
                    .append("\"certificado_ensayo\":\"").append(certificadoEnsayoUrl).append("\",")
                    .append("\"opinion_tecnica\":\"").append(opinionTecnicaUrl).append("\",")
                    .append("\"informe\":\"").append(informeUrl).append("\",")
                    .append("\"providencia\":\"").append(providenciaUrl).append("\",")
                    .append("\"doc_analisis\":\"").append(docAnalisisUrl).append("\"")
                    .append("}");

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(jsonBuilder.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Error al obtener los documentos de la solicitud.\"}");
        }
    }

}
