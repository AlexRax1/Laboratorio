/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controlador;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 *
 * @author alex1
 */

@WebServlet(urlPatterns = {"/buscarSolicitudes", "/datosModal"})
public class ControladorRegistroSolicitudMuestra extends HttpServlet{
    //private SolicitudDAO solicitudDAO = new SolicitudDAO(); // Asumiendo que ya tienes configurado tu DAO

    // Método para buscar las solicitudes y llenar la tabla (buscarSolicitudes)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        if (action.equals("/buscarSolicitudes")) {
            buscarSolicitudes(request, response);
        } else if (action.equals("/datosModal")) {
            buscarDatosModal(request, response);
        }
    }

    private void buscarSolicitudes(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<Solicitud> solicitudes = solicitudDAO.obtenerSolicitudes();  // Llama a tu DAO para obtener las solicitudes
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Construir JSON manualmente
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("[");

        for (int i = 0; i < solicitudes.size(); i++) {
            Solicitud solicitud = solicitudes.get(i);
            jsonBuilder.append("{")
                        .append("\"id\":\"").append(solicitud.getId()).append("\",")
                        .append("\"dato1\":\"").append(solicitud.getDato1()).append("\",")
                        .append("\"dato2\":\"").append(solicitud.getDato2()).append("\"")
                        .append("}");

            if (i < solicitudes.size() - 1) {
                jsonBuilder.append(",");
            }
        }

        jsonBuilder.append("]");  // Cierra el JSON array

        // Envía el JSON al frontend
        response.getWriter().write(jsonBuilder.toString());
    }

    // Método para manejar los datos del modal (datosModal)
    private void buscarDatosModal(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");  // Obtener el id que se mandó desde el modal

        // Llama a tu DAO para obtener los detalles de esa solicitud específica
        Solicitud solicitud = solicitudDAO.obtenerSolicitudPorId(Integer.parseInt(id));
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Construir JSON para la solicitud del modal
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("{")
                   .append("\"id\":\"").append(solicitud.getId()).append("\",")
                   .append("\"detalle1\":\"").append(solicitud.getDetalle1()).append("\",")
                   .append("\"detalle2\":\"").append(solicitud.getDetalle2()).append("\",")
                   .append("\"detalle3\":\"").append(solicitud.getDetalle3()).append("\"")
                   .append("}");

        // Envía el JSON al frontend para llenar el modal
        response.getWriter().write(jsonBuilder.toString());
    }
}
