<%-- 
    Document   : furmulario
    Created on : 27/09/2024, 07:16:03 PM
    Author     : alex1
--%>

<%@ include file="barraNavegacion.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Formulario de Registro</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">

    </head>
    <body>
        <div class="container">
            <h2>Formulario de Registro</h2>

            <!-- Mostrar mensaje de éxito o error -->
            
            <c:if test="${not empty mensaje}">
                <div class="alert alert-${mensaje == 'Registro exitoso' ? 'success' : 'danger'} alert-dismissible fade show" role="alert">
                    ${mensaje}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/ProcesarFormulario" method="post" class="needs-validation" novalidate>
                <!-- Nombre -->
                <div class="mb-3">
                    <label for="nombre" class="form-label">Nombre</label>
                    <input type="text" class="form-control" id="nombre" name="nombre" required>
                    <div class="invalid-feedback">Por favor, ingrese su nombre.</div>
                </div>

                <!-- Correo electrónico -->
                <div class="mb-3">
                    <label for="email" class="form-label">Correo Electrónico</label>
                    <input type="email" class="form-control" id="email" name="email" required>
                    <div class="invalid-feedback">Por favor, ingrese un correo electrónico válido.</div>
                </div>

                <!-- Contraseña -->
                <div class="mb-3">
                    <label for="password" class="form-label">Contraseña</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                    <div class="invalid-feedback">Por favor, ingrese una contraseña.</div>
                </div>

                <!-- Fecha de nacimiento -->
                <div class="mb-3">
                    <label for="fechaNacimiento" class="form-label">Fecha de Nacimiento</label>
                    <input type="date" class="form-control" id="fechaNacimiento" name="fechaNacimiento" required>
                    <div class="invalid-feedback">Por favor, seleccione su fecha de nacimiento.</div>
                </div>

                <!-- Género -->
                <div class="mb-3">
                    <label class="form-label">Género</label><br>
                    <input type="radio" id="masculino" name="genero" value="Masculino" required>
                    <label for="masculino">Masculino</label>
                    <input type="radio" id="femenino" name="genero" value="Femenino" required>
                    <label for="femenino">Femenino</label>
                    <div class="invalid-feedback">Por favor, seleccione su género.</div>
                </div>

                <!-- Aceptar términos -->
                <div class="mb-3 form-check">
                    <input type="checkbox" class="form-check-input" id="terminos" name="terminos" required>
                    <label class="form-check-label" for="terminos">Aceptar términos y condiciones</label>
                    <div class="invalid-feedback">Debe aceptar los términos y condiciones.</div>
                </div>

                <button type="submit" class="btn btn-primary">Enviar</button>
            </form>
        </div>

        <script>
            // Validación del formulario en el lado del cliente
            (function () {
                'use strict';
                var forms = document.querySelectorAll('.needs-validation');
                Array.prototype.slice.call(forms).forEach(function (form) {
                    form.addEventListener('submit', function (event) {
                        if (!form.checkValidity()) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            })();
        </script>
    </body>
</html>
