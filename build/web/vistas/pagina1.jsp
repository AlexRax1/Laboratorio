<%-- 
    Document   : pagina1
    Created on : 21/09/2024, 07:23:13 AM
    Author     : alex1
--%>

<%@page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
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
