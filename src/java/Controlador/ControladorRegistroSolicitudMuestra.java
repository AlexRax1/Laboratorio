/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controlador;

import Modelo.Entidad;
import Modelo.Solicitud;
import ModeloDAO.EntidadDAO;
import ModeloDAO.RegistrarSolicitudDAO;
import static com.sun.corba.se.spi.presentation.rmi.StubAdapter.request;
import java.io.IOException;
import java.io.PrintWriter;
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
@WebServlet(urlPatterns = {"/buscarNitProveedor", "/guardarSolicitud"})
public class ControladorRegistroSolicitudMuestra extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/buscarNitProveedor":
                buscarNitProveedor(request, response);
                break;
            case "/buscarEntidadesPrivada":
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
            case "/guardarSolicitud":
        {
            try {
                guardarSolicitud(request, response);
            } catch (MessagingException ex) {
                Logger.getLogger(ControladorRegistroSolicitudMuestra.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
                break;
            default:
                break;
        }

    }

    private void buscarNitProveedor(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String nit = request.getParameter("codigo");

        // Crea un objeto de tu DAO para obtener los datos del proveedor
        EntidadDAO proveedorDAO = new EntidadDAO();
        Entidad datosEntidad = proveedorDAO.datosEntidad(nit); // Implementa este método en tu DAO

        // Configura la respuesta
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Crea un objeto JSON para la respuesta
        PrintWriter out = response.getWriter();

        if (datosEntidad != null) {
            // Construye el JSON de respuesta
            String jsonResponse = String.format("{\"nombre\":\"%s\", \"direccion\":\"%s\", \"correo\":\"%s\", \"telefono\":\"%s\"}",
                    datosEntidad.getNombre(),
                    datosEntidad.getDireccion(),
                    datosEntidad.getCorreo(),
                    datosEntidad.getTelefono());
            out.print(jsonResponse);
        } else {
            // Si no se encuentra la entidad, se puede devolver un JSON vacío o un mensaje de error
            out.print("{\"error\":\"Proveedor no encontrado\"}");
        }

        out.flush(); // Asegúrate de enviar la respuesta
    }

    private void guardarSolicitud(HttpServletRequest request, HttpServletResponse response) throws IOException, MessagingException {
        String tipoSolicitud = request.getParameter("tipoSolicitud");
        String tipoEntidad = request.getParameter("tipoEntidad");
        String tipoDocumento = request.getParameter("tipoDocumento");
        String numeroDocumento = request.getParameter("numeroDocumento");
        String nitProveedor = request.getParameter("nitProveedor");
        String nombreProveedor = request.getParameter("nombreProveedor");
        String correoProveedor = request.getParameter("correoProveedor");
        String direccionProveedor = request.getParameter("direccionProveedor");
        String telefonoProveedor = request.getParameter("telefonoProveedor");
        String nitSolicitante = request.getParameter("nitSolicitante");
        String nombreSolicitante = request.getParameter("nombreSolicitante");
        String correoSolicitante = request.getParameter("correoSolicitante");
        String numeroMuestra = request.getParameter("numeroMuestra");
        String descripcionProducto = request.getParameter("descripcionProducto");
        String usuariosSelect = request.getParameter("usuariosSelect");

        // Crear objeto Solicitud
        Solicitud solicitud = new Solicitud();
        solicitud.setTipoSolicitud(tipoSolicitud);
        solicitud.setTipoEntidad(tipoEntidad);
        solicitud.setTipoDoc(tipoDocumento);
        solicitud.setNumeroDoc(numeroDocumento);
        solicitud.setNitProveedor(nitProveedor);
        solicitud.setNombreProveedor(nombreProveedor);
        solicitud.setCorreoProveedor(correoProveedor);
        solicitud.setDireccionProveedor(direccionProveedor);
        solicitud.setTelefonoProveedor(telefonoProveedor);
        solicitud.setNitSolicitante(nitSolicitante);
        solicitud.setNombreSolicitante(nombreSolicitante);
        solicitud.setCorreoSolicitante(correoSolicitante);
        solicitud.setNumeroMuestra(numeroMuestra);
        solicitud.setDescripcion(descripcionProducto);
        solicitud.setUsuarioAsignado(usuariosSelect);

        // Pasar el objeto al DAO para guardar la solicitud
        RegistrarSolicitudDAO registrarSolicitudDAO = new RegistrarSolicitudDAO();
        boolean exito = registrarSolicitudDAO.guardarSolicitud(solicitud); 
        if (exito) {
            response.getWriter().write("Solicitud guardada con éxito");
        } else {
            response.getWriter().write("Error al guardar la solicitud");
        }
    }

}
