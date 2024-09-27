<%-- 
    Document   : pagina2
    Created on : 21/09/2024, 07:23:19 AM
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
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tabla con Botones en Cada Fila</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">

    </head>
    <body>
        <div class="container mt-4">
            <h2>Datos en la Tabla</h2>
            <!-- Tabla de datos -->
            <table class="table table-bordered" id="dataTable">
                <thead class="thead-light">
                    <tr>
                        <th>#</th>
                        <th>Nombre</th>
                        <th>Edad</th>
                        <th>Correo</th>
                        <th>Acciones</th> <!-- Nueva columna para botones -->
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>1</td>
                        <td>Juan Pérez</td>
                        <td>28</td>
                        <td>juan@example.com</td>
                        <td>
                            <!-- Botones en cada fila -->
                            <button class="btn btn-primary btn-sm">Editar</button>
                            <button class="btn btn-danger btn-sm">Eliminar</button>
                            <button class="btn btn-info btn-sm">Ver</button>
                        </td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>Ana Gómez</td>
                        <td>32</td>
                        <td>ana@example.com</td>
                        <td>
                            <!-- Botones en cada fila -->
                            <button class="btn btn-primary btn-sm">Editar</button>
                            <button class="btn btn-danger btn-sm">Eliminar</button>
                            <button class="btn btn-info btn-sm">Ver</button>
                        </td>
                    </tr>
                    <tr>
                        <td>3</td>
                        <td>Mario Ruiz</td>
                        <td>40</td>
                        <td>mario@example.com</td>
                        <td>
                            <!-- Botones en cada fila -->
                            <button class="btn btn-primary btn-sm">Editar</button>
                            <button class="btn btn-danger btn-sm">Eliminar</button>
                            <button class="btn btn-info btn-sm">Ver</button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Bootstrap JS, Popper.js, and jQuery -->
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    </body>
</html>
