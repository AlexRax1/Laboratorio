<%-- 
    Document   : pagina3
    Created on : 21/09/2024, 07:23:26 AM
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
    </head>
    <body>
        <h1>Pagina 3</h1>
    </body>
</html>
