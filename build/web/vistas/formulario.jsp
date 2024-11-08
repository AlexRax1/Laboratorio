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
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

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

            <!-- Select vacío inicialmente -->
            <select id="usuariosSelect" required> 
                <option value="">Seleccione un usuario</option>
            </select>



            <button id="cargarUsuariosBtn">Cargar Usuarios</button>

            <!-- Select para cargar usuarios excluyendo el seleccionado -->
            <h2>Usuarios Disponibles</h2>
            <select id="usuarioExcluidoSelect" required>
                <option value="">Seleccione un usuario</option>
            </select>
        </div>




        <button id="generar">Generar</button>

        <div id="button-container"></div>

        <script>
            $(document).ready(function () {
                $('#generar').click(function () {
                    $('#button-container').append(button);

                    // Crear el botón con el valor del PDF

                    // Añadir el botón al contenedor

                    // Añadir el evento click al botón recién creado
                    var pdfPath = 'http://localhost:8080/pdfsEtiqueta/Etiqueta_AR-13-2024.pdf'; // esta será una ruta diferente, de cada archivo de tu JSP
                    var button = $('<button></button>').text('Haz clic aquí').val(pdfPath);
                    button.click(function () {
                        window.open($(this).val(), '_blank');
                    });
                });
            });
        </script>


        <script>
            //cargar Usuarios para el select
            $(document).ready(function () {

                $.ajax({
                    url: '${pageContext.request.contextPath}/cargarAnalistas', // La URL del servlet
                    type: 'GET',
                    dataType: 'json', // El formato de la respuesta es JSON
                    success: function (data) {
                        // Recorre cada objeto del arreglo JSON recibido
                        $.each(data, function (index, usuario) {
                            // Agregar una opción al select por cada usuario
                            $('#usuariosSelect').append(
                                    $('<option></option>').val(usuario.nombre).text(usuario.nombre)
                                    );
                        });
                    },
                    error: function (xhr, status, error) {
                        alert("Error al cargar los usuarios: " + error);
                    }
                });
            });
        </script>
        <script>
            // Cargar Usuarios para el select menos uno
            $(document).ready(function () {
                // Evento click en el botón
                $('#cargarUsuariosBtn').on('click', function () {
                    // Obtener el valor del select
                    var valorSeleccionado = $('#usuariosSelect').val();

                    // Hacer la llamada AJAX
                    $.ajax({
                        url: '${pageContext.request.contextPath}/cargarAnalistas2', // Cambia la URL si es necesario
                        type: 'GET',
                        dataType: 'json',
                        data: {valor: valorSeleccionado}, // Pasar el valor seleccionado como parámetro
                        success: function (data) {
                            // Limpiar el select de usuarios excluidos
                            $('#usuarioExcluidoSelect').empty();
                            $('#usuarioExcluidoSelect').append('<option value="">Seleccione un usuario</option>');

                            // Recorre cada objeto del arreglo JSON recibido
                            $.each(data, function (index, usuario) {
                                // Agregar una opción al select por cada usuario
                                $('#usuarioExcluidoSelect').append(
                                        $('<option></option>').val(usuario.nit).text(usuario.nombre) // Cambia el valor a NIT si es necesario
                                        );
                            });
                        },
                        error: function (xhr, status, error) {
                            alert("Error al cargar los usuarios: " + error);
                        }
                    });
                });
            });
        </script>
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
