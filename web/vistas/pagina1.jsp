<%-- 
    Document   : pagina1
    Created on : 21/09/2024, 07:23:13 AM
    Author     : alex1
--%>

<%@ include file="barraNavegacion.jsp" %>

<%
    // Verifica si el usuario está autenticado
    if (session.getAttribute("usuario") == null) {
        // Redirige a index.jsp si no hay usuario
        response.sendRedirect("../index.jsp");
        return; // Asegura que no continúe ejecutando el resto de la página después de la redirección
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">

    </head>
    <body>
        
        <div>
            <p>Usuario: ${sessionScope.usuario}</p> <!-- Acceder al usuario desde la sesión -->
            <p>Rol: ${sessionScope.rol}</p>       <!-- Acceder al rol desde la sesión -->
        </div>
        
        
        <div class="container">
            <h2>Contenido de la Página 1</h2>
            <!-- Tu contenido aquí -->
        </div>
    </bod
