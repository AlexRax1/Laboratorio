<%-- 
    Document   : index
    Created on : 21/09/2024, 06:34:55 AM
    Author     : alex1
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Login</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
        <style>
        /* Modo oscuro */
        @media (prefers-color-scheme: dark) {
            body {
                background-color: #121212;
                color: #f5f5f5;
            }
        }
    </style>
    </head>
    <body>
        <div class="container">
            <h2>Login</h2>
            <form action="Controlador" method="post" class="form-group">
                <input type="hidden" name="accion" value="login">
                <label for="usuario">Usuario:</label>
                <input type="text" id="usuario" name="usuario" class="form-control" required><br>

                <label for="password">Contraseña:</label>
                <input type="password" id="password" name="password" class="form-control" required><br>

                <button type="submit" class="btn btn-primary">Iniciar Sesión</button>
            </form>
            <br>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">${errorMessage}</div>
            </c:if>
        </div>
    </body>
</html>
