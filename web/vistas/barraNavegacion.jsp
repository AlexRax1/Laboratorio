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
        <title>Barra Navegacion</title>
        <style>
            nav.navbar {
                flex-flow: column nowrap !important;
            }

            /* Estilos para el submenú */
            .dropdown-submenu {
                position: relative;
            }

            .dropdown-submenu .dropdown-menu {
                display: none;
                position: absolute;
                top: 0;
                left: 100%;
                margin-top: -1px;
            }

            .dropdown-submenu:hover .dropdown-menu {
                display: block;
            }

            /* Asegura que los submenús funcionen bien en pantallas móviles */
            @media (max-width: 768px) {
                .dropdown-submenu .dropdown-menu {
                    position: relative;
                    left: 0;
                    top: 0;
                    margin-top: 0;
                }
            };
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
                            | Cargo: ${sessionScope.puesto}
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
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="adminDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                Servicios
                            </a>
                            <ul class="dropdown-menu" aria-labelledby="adminDropdown">
                                <li><a class="dropdown-item" href="pagina2.jsp">Gestionar Usuarios</a></li>
                                <li><a class="dropdown-item" href="MantenimientoCatalogo.jsp">Mantenimiento de Catálogos</a></li>

                                <!-- Submenú dentro del menú desplegable -->
                                <li class="dropdown-submenu">
                                    <a class="dropdown-item dropdown-toggle" href="#">Sistema de Control de Muestras-SCM</a>
                                    <ul class="dropdown-menu">

                                        <li><a class="dropdown-item" href="MantenimientoCatalogo.jsp">Mantenimento de catalogos</a></li>
                                        <li><a class="dropdown-item" href="ReasignacionSolicitudes.jsp">Reasignación de Solicitudes.</a></li>
                                        <li><a class="dropdown-item" href="MantenimientoUsuarios.jsp">Mantenimiento Usuarios.</a></li>

                                </li>                                        
                            </ul>
                        </li>

                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="#">Opción Separada</a></li>
                    </ul>
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
