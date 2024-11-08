<%-- 
    Document   : pagina3
    Created on : 21/09/2024, 07:23:26 AM
    Author     : alex1
--%>

<%@page import="Modelo.Usuario"%>
<%@page import="Modelo.Persona"%>
<%@page import="java.util.ArrayList"%>
<%@ include file="barraNavegacion.jsp" %>
<%    // Verifica si el usuario está autenticado
    if (session.getAttribute("usuario") == null) {
        // Redirige a index.jsp si no hay usuario
        response.sendRedirect("../index.jsp");
        return; // Asegura que no continúe ejecutando el resto de la página después de la redirección
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Formulario Paso a Paso</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        <style>
            .step {
                display: none; /* Ocultar pasos por defecto */
            }
            .step.active {
                display: block; /* Mostrar el paso activo */
            }
            .button {
                margin-top: 10px; /* Margen superior para botones */
            }
        </style>


        <!--mostrar o ocualtar pasos-->
        <script>
            $(document).ready(function () {
                // Mostrar u ocultar campos según la selección de "tipo de solicitud"
                $("input[name='tipoSolicitud']").on('change', function () {
                    const tipoSolicitud = $("input[name='tipoSolicitud']:checked").val();
                    if (tipoSolicitud === 'AR') { // Muestra para análisis
                        $("#numeroMuestraDiv, #descripcionProductoDiv").show(); // Mostrar estos campos
                    } else {
                        $("#numeroMuestraDiv, #descripcionProductoDiv").hide(); // Ocultar estos campos
                    }
                });
            });
        </script>


        <!-- AJAX para cargar datos de NIT -->
        <script>
            $(document).ready(function () {
                // Al presionar Enter en el campo NIT
                $("#nitProveedor").on("keydown", function (event) {
                    if (event.key === "Enter") {
                        event.preventDefault(); // Evita el envío automático del formulario

                        let inputValue = $(this).val(); // Obtiene el valor ingresado

                        // Llamada AJAX al servlet
                        $.ajax({
                            url: "${pageContext.request.contextPath}/buscarNitProveedor", // URL de tu Servlet
                            method: "GET", // Puede ser POST si prefieres
                            data: {codigo: inputValue}, // Envía el valor ingresado como parámetro
                            success: function (response) {
                                // Actualiza los otros inputs con la respuesta del servlet
                                $("#nombreProveedor").val(response.nombre);
                                $("#correoProveedor").val(response.correo);
                                $("#direccionProveedor").val(response.direccion || '');
                                $("#telefonoProveedor").val(response.telefono || '');
                            },
                            error: function (xhr, status, error) {
                                console.error("Ocurrió un error: ", error);
                            }
                        });
                    }
                });
            });
        </script>
        <!--Seleccionar el usuario a asignar-->
        <!--script>
            $(document).ready(function () {
                // Obtener el ID del usuario seleccionado
                $("input[name='selectedUser']").on('change', function () {
                    var selectedUserId = $(this).val();
                    $("#selectedUserId").val(selectedUserId); // Almacenar el ID seleccionado
                });
            });
        </script-->
        <script>
            // Cargar usuarios para el select
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
                                    $('<option></option>').val(usuario.nit).text(usuario.nombre) // Establece el NIT como valor
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
            //Guardar Solicitud
            $(document).ready(function () {
                $('#multiStepForm').on('submit', function (event) {
                    event.preventDefault(); // Prevenir el envío por defecto

                    // Recolectar datos del formulario
                    var formData = $(this).serialize(); // Serializar datos del formulario

                    // Enviar datos a un servlet
                    $.ajax({
                        type: 'POST',
                        url: '${pageContext.request.contextPath}/guardarSolicitud', // Cambia esto por la URL de tu servlet
                        data: formData,
                        success: function (response) {
                            // Manejar la respuesta del servidor
                            alert('El registro de la muestra se realizo con éxito Número de Muestra ?Número de Muestra?.');
                            location.reload();
                        },
                        error: function (xhr, status, error) {
                            // Manejar errores
                            alert('Por favor verifique, el número de muestra de ya se encuentra registrado en otra solicitud, número de solicitud: ?número de solicitud?.');
                        }
                    });
                });
            });
        </script>
        <script>
            $(document).ready(function () {
                // Ejecutar la búsqueda al presionar Enter en el campo de entrada "loginu"
                $("#nitSolicitante").on("keydown", function (event) {
                    if (event.key === "Enter") {
                        event.preventDefault(); // Evita el envío automático del formulario

                        var login = "";
                        var nit = $('#nitSolicitante').val();

                        // Llamada AJAX al servlet para buscar el usuario
                        $.ajax({
                            url: `${pageContext.request.contextPath}/buscarUsuario`,
                            type: 'GET',
                            data: {
                                login: login,
                                nit: nit
                            },
                            success: function (data) {
                                // Actualizar los campos con la respuesta del servidor
                                $('#nombreSolicitante').val(data.nombre);
                            },
                            error: function () {
                                alert('Usuario no encontrado');
                            }
                        });
                    }
                });
            });
        </script>
    </head>
    <body>
        <div class="container mt-5">
            <h1 class="text-center">Nueva Solicitud de Muestra</h1>

            <form id="multiStepForm" action="#" method="post" class="needs-validation" autocomplete="off" novalidate>
                <!-- Paso 1 -->
                <div class="step active">
                    <div class="form-group">
                        <label>Ingrese el tipo de solicitud</label>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" id="radio1" name="tipoSolicitud" value="AR" required>
                            <label class="form-check-label" for="radio1">Muestra para análisis</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" id="radio2" name="tipoSolicitud" value="OTM" required>
                            <label class="form-check-label" for="radio2">Solicitud sin muestra</label>
                        </div>
                        <div class="invalid-feedback">Por favor, seleccione una opción.</div>
                    </div>
                    <button type="button" class="btn btn-primary button" onclick="nextStep()">Siguiente</button>
                </div>

                <!-- Paso 2 - Tipo de entidad -->
                <div class="step">
                    <div class="form-group">
                        <label>Ingrese el tipo de entidad</label>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" id="radioEntidad1" name="tipoEntidad" value="privada" required>
                            <label class="form-check-label" for="radioEntidad1">Entidad Privada</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" id="radioEntidad2" name="tipoEntidad" value="publica" required>
                            <label class="form-check-label" for="radioEntidad2">Entidad Pública</label>
                        </div>
                        <div class="invalid-feedback">Por favor, seleccione una opción.</div>
                    </div>
                    <button type="button" class="btn btn-secondary button" onclick="prevStep()">Volver</button>
                    <button type="button" class="btn btn-primary button" onclick="nextStep()">Siguiente</button>
                </div>

                <!-- Paso 3 - Información General -->
                <div class="step">
                    <div class="form-group">
                        <label for="fechaSolicitud">Fecha:</label>
                        <input type="text" class="form-control" id="fechaSolicitud" name="fechaSolicitud" readonly>
                    </div>

                    <div class="form-group">
                        <label for="tipoDocumento">Tipo de documento*:</label>
                        <select class="form-control" id="tipoDocumento" name="tipoDocumento" required>
                            <option value="" disabled selected>Seleccione una opción</option>
                            <option value="expediente">Número de expediente</option>
                            <option value="hojaTramite">Hoja de trámite</option>
                            <option value="memorandum">Memorándum</option>
                        </select>
                        <div class="invalid-feedback">Por favor, seleccione una opción.</div>
                    </div>

                    <div class="form-group">
                        <label for="numeroDocumento">Número de documento*:</label>
                        <input type="text" class="form-control" id="numeroDocumento" name="numeroDocumento" required>
                        <div class="invalid-feedback">Por favor, ingrese el número de documento.</div>
                    </div>

                    <div class="form-group">
                        <label for="nitProveedor">NIT del proveedor*:</label>
                        <input type="text" class="form-control" id="nitProveedor" name="nitProveedor" placeholder="Ingrese el NIT y presione Enter" required>
                        <div class="invalid-feedback">Por favor, ingrese el NIT.</div>
                    </div>

                    <div class="form-group">
                        <label for="nombreProveedor">Nombre proveedor*:</label>
                        <input type="text" class="form-control" id="nombreProveedor" name="nombreProveedor" readonly>
                    </div>

                    <div class="form-group">
                        <label for="correoProveedor">Correo proveedor*:</label>
                        <input type="text" class="form-control" id="correoProveedor" name="correoProveedor" readonly>
                    </div>

                    <div class="form-group">
                        <label for="direccionProveedor">Dirección proveedor (opcional):</label>
                        <input type="text" class="form-control" id="direccionProveedor" name="direccionProveedor" readonly>
                    </div>

                    <div class="form-group">
                        <label for="telefonoProveedor">Teléfono proveedor (opcional):</label>
                        <input type="text" class="form-control" id="telefonoProveedor" name="telefonoProveedor" readonly>
                    </div>

                    <div class="form-group">
                        <label for="nitSolicitante">NIT del solicitante:</label>
                        <input type="text" class="form-control" id="nitSolicitante" name="nitSolicitante">
                        <div class="invalid-feedback">Por favor, ingrese el NIT del solicitante.</div>
                    </div>

                    <div class="form-group">
                        <label for="nombreSolicitante">Nombre Solicitante</label>
                        <input type="text" class="form-control" id="nombreSolicitante" name="nombreSolicitante" readonly>
                    </div>

                    <div class="form-group">
                        <label for="correoSolicitante">Correo electrónico solicitante:</label>
                        <input type="email" class="form-control" id="correoSolicitante" name="correoSolicitante" required>
                        <div class="invalid-feedback">Por favor, ingrese un correo electrónico válido.</div>
                    </div>

                    <div id="numeroMuestraDiv" style="display:none;">
                        <div class="form-group">
                            <label for="numeroMuestra">Número de muestra:</label>
                            <input type="text" class="form-control" id="numeroMuestra" name="numeroMuestra">
                        </div>
                    </div>

                    <div id="descripcionProductoDiv" style="display:none;">
                        <div class="form-group">
                            <label for="descripcionProducto">Descripción del producto:</label>
                            <textarea class="form-control" id="descripcionProducto" name="descripcionProducto" style="resize: none;"></textarea>
                            <div class="invalid-feedback">Por favor, ingrese la descripción del producto.</div>
                        </div>
                    </div>

                    <!-- seleccionar analista-->
                    <div class="mb-3">
                        <label for="usuariosSelect" class="form-label">Seleccione un analista</label>
                        <select id="usuariosSelect" class="form-select" name="usuariosSelect" required>
                            <option value="">Seleccione un analista</option>
                        </select>
                    </div>

                    <button type="button" class="btn btn-secondary button" onclick="prevStep()">Volver</button>
                    <button type="submit" class="btn btn-primary button">Guardar</button>

                </div>
            </form>
        </div>

        <script>
            let currentStep = 0;
            const steps = document.querySelectorAll('.step');
            const form = document.getElementById('multiStepForm');
            // Mostrar el paso actual
            function showStep(stepIndex) {
                steps.forEach((step, index) => {
                    step.classList.remove('active');
                    if (index === stepIndex) {
                        step.classList.add('active');
                    }
                });
            }

            // Función para avanzar al siguiente paso
            function nextStep() {
                if (validateStep(currentStep)) {
                    currentStep++;
                    showStep(currentStep);
                }
            }

            // Función para volver al paso anterior
            function prevStep() {
                currentStep--;
                showStep(currentStep);
            }

            // Validar el paso actual antes de avanzar
            function validateStep(stepIndex) {
                let valid = true;
                const step = steps[stepIndex];
                const inputs = step.querySelectorAll('input, select, textarea');
                inputs.forEach(input => {
                    if (!input.checkValidity()) {
                        input.classList.add('is-invalid');
                        valid = false;
                    } else {
                        input.classList.remove('is-invalid');
                    }
                });
                return valid;
            }

        </script>
        <script>
            // Establecer la fecha actual en el campo "Fecha"
            $("#fechaSolicitud").val(new Date().toLocaleDateString());
        </script>
    </body>
</html>
