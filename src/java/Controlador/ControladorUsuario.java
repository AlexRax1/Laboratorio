/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controlador;

import Modelo.Solicitud;
import Modelo.Usuario;
import Modelo.UsuarioG;
import ModeloDAO.SolicitudDAO;
import ModeloDAO.UsuarioDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author alex1
 */
//name = "srvUsuario", urlPatterns = {"/srvUsuario"}
@WebServlet(urlPatterns = {"/datosUsuario", "/cambiarEstado", "/agregarUsuario", "/buscarUsuario", "/verificarSolicitudes", "/obtenerSolicitudesAnalista"})
public class ControladorUsuario extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();  // Obtener la ruta actual
        switch (action) {
            case "/datosUsuario":
                obtenerDatosUsuario(request, response);
                break;
            case "/cambiarEstado":
                cambiarEstadoUsuario(request, response);
                break;
            case "/buscarUsuario":
                buscarUsuario(request, response); // Para mostrar el formulario de agregar usuario
                break;
            case "/verificarSolicitudes":
                verificarSolicitudes(request, response); // Para mostrar el formulario de agregar usuario
                break;
            case "/obtenerSolicitudesAnalista":
                solicitudesAnalista(request, response); // Para mostrar el formulario de agregar usuario
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/cambiarEstado":
                cambiarEstadoUsuario(request, response); // Cambiar estado con POST
                break;
            case "/agregarUsuario":
                agregarUsuario(request, response); // Insertar usuario nuevo
                break;

            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    // Función para obtener los datos de los usuarios y llenar la tabla
    private void obtenerDatosUsuario(HttpServletRequest request, HttpServletResponse response) throws IOException {
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        List<Usuario> usuarios = usuarioDAO.obtenerUsuarios();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("[");

        for (int i = 0; i < usuarios.size(); i++) {
            Usuario usuario = usuarios.get(i);
            jsonBuilder.append("{")
                    .append("\"nit\":\"").append(usuario.getNit()).append("\",")
                    .append("\"nombre\":\"").append(usuario.getNombre()).append("\",")
                    .append("\"rolNombre\":\"").append(usuario.getRolNombre()).append("\",")
                    .append("\"actor\":\"").append(usuario.getActor()).append("\",")
                    .append("\"estado\":").append(usuario.isEstado()).append(",")
                    .append("\"cargoTrabajo\":\"").append(usuario.getCargoTrabajo()).append("\"")
                    .append("}");

            if (i < usuarios.size() - 1) {
                jsonBuilder.append(",");
            }
        }

        jsonBuilder.append("]");

        response.getWriter().write(jsonBuilder.toString());
    }

    // Función para cambiar el estado de un usuario basado en el ID
    private void cambiarEstadoUsuario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nit = request.getParameter("nit"); // Obtener el ID del usuario seleccionado
        String estado = request.getParameter("nuevoEstado"); // Obtener el nuevo estado
        String motivo = request.getParameter("motivo"); // Obtener el nuevo estado
        String nitAdicion = request.getParameter("nitAdicion"); // Obtener el nuevo estado

        UsuarioDAO usuarioDao = new UsuarioDAO();

        if (nit == null || estado == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        boolean nuevoEstado = false;
        if ("true".equals(estado)) {
            nuevoEstado = true;
        }

        if (usuarioDao.cambiarEstado(nit, nuevoEstado)) {
            usuarioDao.agregarBitacora(nit, nuevoEstado, motivo, nitAdicion);
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void buscarUsuario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String login = request.getParameter("login");
        String nit = request.getParameter("nit");

        UsuarioDAO usuarioDao = new UsuarioDAO();
        UsuarioG usuario = usuarioDao.obtenerPorNit(nit, login); // Método para obtener datos del usuario

        if (usuario != null) {
            // Devolver datos del usuario en formato JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            PrintWriter out = response.getWriter();
            out.print("{");
            out.print("\"nombre\":\"" + usuario.getNombre() + "\",");
            out.print("\"login\":\"" + usuario.getLogin() + "\",");
            out.print("\"nit\":\"" + usuario.getNit() + "\",");
            out.print("\"rol\":\"" + usuario.getPuesto() + "\""); // Verifica que no sea nulo
            out.print("}");
            out.flush();
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "acao buoesatnouhtn soeuhtn");
        }
    }

    private void solicitudesAnalista(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nit = request.getParameter("nit");

        SolicitudDAO solicitudDao = new SolicitudDAO();
        List<Solicitud> solicitudes = solicitudDao.obtenerSolicitudes(nit);

        // Configurar la respuesta para que sea en formato JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Usamos StringBuilder para construir el JSON manualmente
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"solicitudes\": [");

        // Iteramos sobre las solicitudes y agregamos cada una al JSON
        for (int i = 0; i < solicitudes.size(); i++) {
            Solicitud solicitud = solicitudes.get(i);

            json.append("{");
            json.append("\"numero_muestra\": \"").append(solicitud.getIdSolicitud()).append("\",");
            json.append("\"estado_solicitud\": \"").append(solicitud.getEstadoSolicitud()).append("\",");
            json.append("\"estado_muestra\": \"").append(solicitud.getEstadoMuestra()).append("\"");
            json.append("}");

            if (i < solicitudes.size() - 1) {
                json.append(","); // No agregar coma después del último objeto
            }
        }

        json.append("]");
        json.append("}");
        
        // Escribir el JSON en la respuesta
        response.getWriter().write(json.toString());
    }

    private void verificarSolicitudes(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nit = request.getParameter("nit");
        UsuarioDAO usuarioDao = new UsuarioDAO();

        // Llamar al método cargaTrabajo para obtener el número de solicitudes activas
        int cantidadSolicitudesActivas = usuarioDao.cargaTrabajo(nit);
        boolean tieneSolicitudesActivas = cantidadSolicitudesActivas > 0; // Verificar si hay solicitudes activas

        // Construir la respuesta JSON con StringBuilder
        StringBuilder jsonResponse = new StringBuilder();
        jsonResponse.append("{");
        jsonResponse.append("\"tieneSolicitudesActivas\":").append(tieneSolicitudesActivas);
        jsonResponse.append("}");

        // Enviar respuesta al cliente
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8"); // Asegurarse de que se maneje correctamente la codificación
        response.getWriter().write(jsonResponse.toString());
    }

    private void agregarUsuario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nit = request.getParameter("nit");
        String login = "1";
        if (nit == null || nit.isEmpty()) {
            return; // Asegúrate de que nit no sea nulo o vacío
        }

        UsuarioDAO usuarioDao = new UsuarioDAO();
        UsuarioG usuariog = usuarioDao.obtenerPorNit(nit, login); // Obtener datos del usuario

        if (usuariog != null) {
            // Extraer datos de usuariog
            String logini = usuariog.getLogin();
            String nombre = usuariog.getNombre();
            String actor = usuariog.getActor();
            String rol_nombre = usuariog.getPuesto();
            String password = usuariog.getPassword(); // Asegúrate de que este valor esté presente en UsuarioG
            boolean estado = true; // Define el estado (true o false según tu lógica)
            int id_rol = obtenerIdRolPorPuesto(rol_nombre); // Método para mapear el puesto a un id_rol
            String correo = usuarioDao.correoUsuario(nit);
            // Llama al DAO para insertar el nuevo usuario
            boolean usuarioAgregado = usuarioDao.agregarUsuario(nit, logini, nombre, estado, id_rol, rol_nombre, actor, password, correo);

            if (usuarioAgregado) {
                response.getWriter().write("Usuario agregado correctamente.");
            } else {
                response.getWriter().write("Error al agregar usuario.");
            }
        } else {
            response.getWriter().write("Usuario no encontrado.");
        }
    }

// Método para obtener id_rol según el puesto
    private int obtenerIdRolPorPuesto(String puesto) {
        switch (puesto) {
            case "Administrador":
                return 1;
            case "RegistroMuestras":
                return 2;
            case "AnalistadeLaboratorio":
                return 3;
            case "AlmacenamientodeMuestra":
                return 4;
            case "SupervisorLaboratorio":
                return 5;
            case "JefeUnidadLaboratorio":
                return 6;
            case "LaboratorioExterno":
                return 7;
            case "Reportes":
                return 8;
            case "VisualizacionDocumentos":
                return 9;
            default:
                return 0; // O cualquier otro valor predeterminado
        }
    }

}
