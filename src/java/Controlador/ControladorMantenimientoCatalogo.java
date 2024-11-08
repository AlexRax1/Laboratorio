/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controlador;

import Modelo.Entidad;
import Modelo.EntidadGuardada;
import ModeloDAO.EntidadDAO;
import ModeloDAO.EntidadGuardadaDAO;
import java.io.IOException;
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
@WebServlet(urlPatterns = {"/buscarNit", "/guardar", "/buscarEntidadesPrivada", "/buscarEntidadesPublica"})
public class ControladorMantenimientoCatalogo extends HttpServlet {
    
    private EntidadDAO entidadDAO = new EntidadDAO(); 
    private EntidadGuardadaDAO entidadGuardadaDAO = new EntidadGuardadaDAO(); 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        switch (path) {
            case "/buscarNit":
                buscar(request, response);
                break;
            case "/buscarEntidadesPrivada":
                buscarEntidadesPrivada(response);
                break;
            case "/buscarEntidadesPublica":
                buscarEntidadesPublica(response);
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
            case "/guardar":
                guardar(request, response);
                break;
            default:
                response.getWriter().println("Ruta no reconocida");
                break;
        }
    }

    private void buscar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String nit = request.getParameter("codigo");
        String nombre = entidadGuardadaDAO.obtenerNombreNit(nit);
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        if (nombre != null && !nombre.isEmpty()) {
            response.getWriter().write(nombre);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "No se encontró una entidad con ese NIT.");
        }
    }

    private void guardar(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String nit = request.getParameter("nit");
        String tipo = request.getParameter("tipo");
        EntidadGuardadaDAO daoeg = new EntidadGuardadaDAO();
        EntidadGuardada entidadg = daoeg.obtenerPorNit(nit);
        String nombre = entidadg.getNombre();
        String correo = entidadg.getCorreo();
        String direccion = entidadg.getDireccion();
        String telefono = entidadg.getTelefono();
        // Validar datos
        if (nit == null || nombre == null || tipo == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Faltan datos para guardar la entidad.");
            return;
        }

        Entidad entidad = new Entidad();
        if (entidadDAO.existenciaNit(nit)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "La entidad ya existe.");
            return;
        }

        entidad.setNit(nit);
        entidad.setNombre(nombre);
        entidad.setCorreo(correo);
        entidad.setDireccion(direccion);
        entidad.setTelefono(telefono);
        if (tipo.equals("opcion1")) {
            entidad.setTipo("privada");
        } else if (tipo.equals("opcion2")) {
            entidad.setTipo("publica");
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tipo no válido.");
            return;
        }

        entidadDAO.guardarEntidad(entidad);

        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("Entidad guardada exitosamente.");
    }

    private void buscarEntidadesPrivada(HttpServletResponse response) throws IOException {
        List<Entidad> entidades = entidadDAO.obtenerEntidadesPrivadas();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("[");

        for (int i = 0; i < entidades.size(); i++) {
            Entidad entidad = entidades.get(i);
            jsonBuilder.append("{")
                        .append("\"nit\":\"").append(entidad.getNit()).append("\",")
                        .append("\"nombre\":\"").append(entidad.getNombre()).append("\"")
                        .append("}");

            if (i < entidades.size() - 1) {
                jsonBuilder.append(",");
            }
        }

        jsonBuilder.append("]"); 

        response.getWriter().write(jsonBuilder.toString());
    }

    private void buscarEntidadesPublica(HttpServletResponse response) throws IOException {
        List<Entidad> entidades = entidadDAO.obtenerEntidadesPublicas();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("[");

        for (int i = 0; i < entidades.size(); i++) {
            Entidad entidad = entidades.get(i);
            jsonBuilder.append("{")
                        .append("\"nit\":\"").append(entidad.getNit()).append("\",")
                        .append("\"nombre\":\"").append(entidad.getNombre()).append("\"")
                        .append("}");

            if (i < entidades.size() - 1) {
                jsonBuilder.append(",");
            }
        }

        jsonBuilder.append("]"); 

        response.getWriter().write(jsonBuilder.toString());
    }
}