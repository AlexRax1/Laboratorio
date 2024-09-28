<%-- 
    Document   : barraNavegacion
    Created on : 26/09/2024, 04:16:37 PM
    Author     : alex1
--%>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Verifica si el usuario está autenticado
    if (session.getAttribute("usuario") == null) {
        // Redirige a index.jsp si no hay usuario
        response.sendRedirect("../index.jsp");
        return; // Asegura que no continúe ejecutando el resto de la página después de la redirección
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <title>Mi Aplicación</title>
        <style>
            nav.navbar {
              flex-flow: column nowrap !important;
            }
      </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-light bg-light" >
            <div class="container-fluid">
                <a class="navbar-brand" href="#">Mi Aplicación</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <!-- Barra superior usuario y cerrar sesión -->
                <div class="d-flex justify-content-between w-100">
                    <!-- Usuario y Rol -->
                    <div>
                        <span class="navbar-text">Usuario: ${sessionScope.usuario} | Rol: 
                            <c:choose>
                                <c:when test="${sessionScope.rol == 1}">Administrador</c:when>
                                <c:when test="${sessionScope.rol == 2}">Editor</c:when>
                                <c:when test="${sessionScope.rol == 3}">Usuario</c:when>
                                <c:when test="${sessionScope.rol == 4}">Usuario formulario</c:when>
                                <c:otherwise>No asignado</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <!-- Botón de Cerrar Sesión -->
                    <div>
                        <c:if test="${not empty sessionScope.usuario}">
                            <a class="btn btn-danger" href="barraNavegacion.jsp?action=logout">Cerrar Sesión</a>
                        </c:if>
                    </div>
                    
                    <% 
                        // Verifica si el parámetro "action" tiene el valor "logout"
                        String action = request.getParameter("action");
                        if ("logout".equals(action)) {
                            // Invalida la sesión si existe
                            if (session != null) {
                                session.invalidate();
                            }
                            // Redirige al index.jsp (una carpeta atrás)
                            response.sendRedirect("../index.jsp");
                            return; // Asegura que no continúe ejecutando el resto de la página después de la redirección
                        }
                    %>
                    
                </div>
            </div>

            <!-- Opciones de Navegación dependientes del rol -->
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav">
                    <!-- Opciones comunes para todos los usuarios -->
                    <li class="nav-item">
                        <a class="nav-link" href="paginaPrincipal.jsp">Inicio</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="perfil.jsp">Perfil</a>
                    </li>

                    <!-- Opciones solo para Administrador (rol 1) -->
                    <c:if test="${sessionScope.rol == 1}">
                        <li class="nav-item">
                            <a class="nav-link" href="pagina2.jsp">Gestionar Usuarios</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="pagina3.jsp">Reportes</a>
                        </li>
                    </c:if>

                    <!-- Opciones solo para Editor (rol 2) -->
                    <c:if test="${sessionScope.rol == 2}">
                        <li class="nav-item">
                            <a class="nav-link" href="editorPage1.jsp">Publicar Artículos</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="editorPage2.jsp">Revisar Comentarios</a>
                        </li>
                    </c:if>

                    <!-- Opciones solo para Usuario (rol 3) -->
                    <c:if test="${sessionScope.rol == 3 or sessionScope.rol == 4}">
                        <li class="nav-item">
                            <a class="nav-link" href="userPage1.jsp">Ver Contenido</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="userPage2.jsp">Enviar Comentarios</a>
                        </li>
                    </c:if>
                </ul>
            </div>
        </nav>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
