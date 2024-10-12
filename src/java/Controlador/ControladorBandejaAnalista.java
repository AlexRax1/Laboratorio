/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author alex1
 */
@WebServlet("/FormularioBandejaAnalista")
public class ControladorBandejaAnalista {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String step = request.getParameter("step");

        if ("final".equals(step)) {
            // Recuperar todos los campos del formulario
            String campo1 = request.getParameter("campo1");
            String campo2 = request.getParameter("campo2");
            String campo3 = request.getParameter("campo3");
            String campo4 = request.getParameter("campo4");

            // Procesar y guardar los datos en la base de datos
            // (esto dependerá de la lógica de tu aplicación)
            // Redirigir a una página de confirmación o mostrar un mensaje de éxito
            response.sendRedirect("exito.jsp");
        } else {
            // Manejar otros pasos si es necesario (por ejemplo, validación)
        }
    }
}
