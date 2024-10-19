/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controlador;

import Modelo.Usuario;
import ModeloDAO.UsuarioDAO;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author alex1
 */
@WebServlet("/Controlador")
public class ControladorLogin extends HttpServlet {
    

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        Usuario usuario = new Usuario();
        usuario.setLogin(request.getParameter("usuario"));
        usuario.setPassword(request.getParameter("password"));

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        if (usuarioDAO.validar(usuario)) {
            // Asegúrate de que el rol se esté configurando correctamente en la validación
            int rol = usuario.getRol();
            
            HttpSession session = request.getSession(); 
            designarDatos(session, usuario );

            switch (rol) {
                case 1:
                    response.sendRedirect("vistas/pagina1.jsp");
                    break;
                case 2:        
                    response.sendRedirect("vistas/pagina2.jsp");
                    break;
                case 3:
                    response.sendRedirect("vistas/RegistroSolicitudMuestra.jsp");
                    break;
                case 4:
                    response.sendRedirect("vistas/Formulario.jsp");
                    break;
                default:
                    request.setAttribute("errorMessage", "Algo salió mal");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
                    dispatcher.forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Usuario o contraseña inválidos");
            RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    private void designarDatos(HttpSession session, Usuario usuario) {
        session.setAttribute("usuario", usuario.getLogin());
        session.setAttribute("rol", usuario.getRol());
        session.setAttribute("puesto", usuario.getActor());
        
    }
 
}
