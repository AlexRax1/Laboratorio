/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controlador;

import Modelo.Persona;
import ModeloDAO.PersonaDAO;
import static com.sun.corba.se.spi.presentation.rmi.StubAdapter.request;
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
    
    private PersonaDAO personaDAO = new PersonaDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        Persona persona = new Persona();
        persona.setUsuario(request.getParameter("usuario"));
        persona.setPassword(request.getParameter("password"));

        PersonaDAO personaDAO = new PersonaDAO();
        if (personaDAO.validar(persona)) {
            // Asegúrate de que el rol se esté configurando correctamente en la validación
            int rol = persona.getRol();
            
            HttpSession session = request.getSession(); 
            designarDatos(session, persona);

            switch (rol) {
                case 1:
                    response.sendRedirect("vistas/pagina1.jsp");
                    break;
                case 2:        
                    response.sendRedirect("vistas/pagina2.jsp");
                    break;
                case 3:
                    response.sendRedirect("vistas/pagina3.jsp");
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
    
    private void designarDatos(HttpSession session, Persona persona) {
        session.setAttribute("usuario", persona.getUsuario());
        session.setAttribute("rol", persona.getRol());
    }
 
}
