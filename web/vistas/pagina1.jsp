<%-- 
    Document   : pagina1
    Created on : 21/09/2024, 07:23:13 AM
    Author     : alex1
--%>

<%@ include file="barraNavegacion.jsp" %>

<%
    // Verifica si el usuario est� autenticado
    if (session.getAttribute("usuario") == null) {
        // Redirige a index.jsp si no hay usuario
        response.sendRedirect("../index.jsp");
        return; // Asegura que no contin�e ejecutando el resto de la p�gina despu�s de la redirecci�n
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
            <p>Usuario: ${sessionScope.usuario}</p> <!-- Acceder al usuario desde la sesi�n -->
            <p>Rol: ${sessionScope.rol}</p>       <!-- Acceder al rol desde la sesi�n -->
        </div>
        
        
        <div class="container">
            <h2>Contenido de la P�gina 1</h2>
            <!-- Tu contenido aqu� -->
        </div>
    </bod
