<%-- 
    Document   : navegacion
    Created on : 21/09/2024, 07:47:36 AM
    Author     : alex1
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Barra de Navegación</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <a class="navbar-brand" href="#">Mi Aplicación</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="pagina1.jsp">Página 1</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="pagina2.jsp">Página 2</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="pagina3.jsp">Página 3</a>
                    </li>
                </ul>
                <span class="navbar-text">
                    Usuario: <c:out value="${usuario}"/> | Rol: <c:out value="${rol}"/>
                </span>
            </div>
        </nav>
    </body>
</html>