<%-- 
    Document   : MantenimientoCatalogo
    Created on : 11/10/2024, 01:09:16 AM
    Author     : alex1
--%>

<%@ include file="barraNavegacion.jsp" %>
<%    // Verifica si el usuario está autenticado
    if (session.getAttribute("usuario") == null) {
        // Redirige a index.jsp si no hay usuario
        response.sendRedirect("../index.jsp");
        return; // Asegura que no continúe ejecutando el resto de la página después de la redirección
    }
%><!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mantenimiento de calatolos</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
        <script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>

        <!-- cargar datos de NIT -->
        <script>
            $(document).ready(function () {
                // Al presionar Enter en el campo NIT
                $("#nit").on("keydown", function (event) {
                    if (event.key === "Enter") {
                        event.preventDefault(); // Evita el envío automático del formulario

                        let inputValue = $(this).val(); // Obtiene el valor ingresado

                        // Llamada AJAX al servlet
                        $.ajax({
                            url: "${pageContext.request.contextPath}/buscarNit",
                            method: "GET",
                            data: {codigo: inputValue},
                            success: function (response) {
                                console.log("Nombre encontrado: " + response);
                                $("#nombreEntidadIngresar").val(response); // Actualiza con el nombre obtenido
                            },
                            error: function (xhr, status, error) {
                                if (xhr.status === 404) {
                                    alert("No se encontró una entidad con ese NIT.");
                                } else {
                                    console.error("Ocurrió un error: ", error);
                                }
                            }
                        });
                    }
                });
            });
        </script>

        <script>
            $(document).ready(function () {
                // Mostrar elementos de opción 1 y ocultar los de opción 2 por defecto
                $("#opcion2-content").hide();

                $("input[name='opciones']").change(function () {
                    if ($(this).val() === "opcion1") {
                        // Mostrar contenido de opción 1 y ocultar opción 2
                        $("#opcion1-content").show();
                        $("#opcion2-content").hide();
                    } else if ($(this).val() === "opcion2") {
                        // Mostrar contenido de opción 2 y ocultar opción 1
                        $("#opcion1-content").hide();
                        $("#opcion2-content").show();
                    }
                });

                // Mostrar el modal cuando se haga clic en el botón
                $(".action-button").click(function () {
                    $("#myModal").modal('show');
                });

                //cerrar ventana emergente
                $('.close, .btn-secondary').on('click', function () {
                    $('#myModal').modal('hide');
                });
            });


        </script>

        <!--guardar entidad-->
        <script>
            $(document).ready(function () {
                // Maneja el evento de clic en el botón "Guardar"
                $("#submit-btn").on("click", function () {
                    // Obtener datos
                    var tipoEntidad = $("input[name='opciones']:checked").val(); // "opcion1" o "opcion2"
                    var nitEntidad = $("#nit").val();
                    var nombreEntidad = $("#nombreEntidadIngresar").val();
                    if (nombreEntidad === null || nombreEntidad.trim() === "") {
                        alert("Llene los campos requeridos.");
                        return;
                    }
                    // Aquí puedes hacer la llamada AJAX para insertar en la tabla
                    $.ajax({
                        url: "${pageContext.request.contextPath}/guardar", // URL de tu Servlet
                        method: "POST", // Usa POST para insertar datos
                        data: {
                            nit: nitEntidad, // Cambiar a 'nit'
                            nombre: nombreEntidad, // Cambiar a 'nombre'
                            tipo: tipoEntidad // Cambiar a 'tipo'
                        },
                        success: function (response) {
                            // Maneja la respuesta del servidor aquí
                            alert("Entidad guardada exitosamente!");
                            // Aquí puedes cerrar el modal y limpiar los campos si lo deseas
                            $('#myModal').modal('hide');
                            $("#entity-form")[0].reset(); // Resetea el formulario
                            location.reload();
                        },
                        error: function (xhr, status, error) {
                            console.error("Ocurrió un error: ", error);
                            alert("La entidad ya existe.");
                        }
                    });
                });
            });
        </script>

        <style>
            /* Estilos personalizados */
            body {
                background-color: #f7f7f7;
                padding: 20px;
            }

            h1, h2 {
                font-family: 'Arial', sans-serif;
                color: #343a40;
            }

            .content-box {
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 20px;
                background-color: #fff;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px;
            }

            .radio-options {
                margin-bottom: 20px;
            }

            .hidden-content {
                display: none;
            }

            .btn-radio {
                margin-right: 10px;
            }
            .action-button {
                display: block; /* Hace que el botón se comporte como un bloque */
                margin: 20px auto; /* Centra el botón horizontalmente */
            }
        </style>


    </head>
    <body>
        <div class="container">
            <h1 class="text-center mb-4">Página Dinámica con Bootstrap 4</h1>

            <!-- Radios para seleccionar opción -->
            <div class="radio-options text-center">
                <div class="btn-group btn-group-toggle" data-toggle="buttons">
                    <label class="btn btn-outline-primary btn-radio ">
                        <input type="radio" name="opciones" value="opcion1" autocomplete="off" > Entidad Privada
                    </label>
                    <label class="btn btn-outline-primary btn-radio">
                        <input type="radio" name="opciones" value="opcion2" autocomplete="off"> Entidad Publica
                    </label>
                </div>
            </div>

            <!-- Contenido de Opción 1 -->
            <div id="opcion1-content" class="content-box hidden-content">
                <h2>Contenido de Opción 1</h2>
                <table class="table table-striped mt-3">
                    <thead>
                        <tr>
                            <th>NIT</th>
                            <th>Nombre</th>
                        </tr>
                    </thead>
                    <tbody id="tablaEntidadesPrivada">
                        <!-- Aquí se llenarán las filas de la tabla -->
                    </tbody>
                </table>
                <button class="btn btn-primary action-button">Agregar Entidad Privada</button>
            </div>

            <script>
                $(document).ready(function () {
                    // Realizar la consulta automáticamente al cargar la página
                    $.ajax({
                        url: '${pageContext.request.contextPath}/buscarEntidadesPrivada', // URL del servlet
                        type: 'GET',
                        dataType: 'json',
                        success: function (data) {
                            // Limpiar la tabla antes de agregar nuevos datos
                            $("#tablaEntidadesPrivada").empty();

                            // Agregar cada entidad como una fila en la tabla
                            $.each(data, function (index, entidad) {
                                $("#tablaEntidadesPrivada").append(
                                        "<tr>" +
                                        "<td>" + entidad.nit + "</td>" +
                                        "<td>" + entidad.nombre + "</td>" +
                                        "</tr>"
                                        );
                            });
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            alert("Error al cargar entidades: " + textStatus);
                        }
                    });
                });
            </script>



            <!-- Contenido de Opción 2 -->
            <div id="opcion2-content" class="content-box hidden-content">
                <h2>Contenido de Opción 2</h2>
                <table class="table table-striped mt-3">
                    <thead>
                        <tr>
                            <th>NIT</th>
                            <th>Nombre</th>
                        </tr>
                    </thead>
                    <tbody id="tablaEntidadesPublica">
                        <!-- Aquí se llenarán las filas de la tabla -->
                    </tbody>
                </table>
                <button class="btn btn-primary action-button">Agregar Entidad Pública</button>
            </div>
        </div>

        <script>
            $(document).ready(function () {
                // Realizar la consulta automáticamente al cargar la página
                $.ajax({
                    url: '${pageContext.request.contextPath}/buscarEntidadesPublica', // URL del servlet
                    type: 'GET',
                    dataType: 'json',
                    success: function (data) {
                        // Limpiar la tabla antes de agregar nuevos datos
                        $("#tablaEntidadesPublica").empty();

                        // Agregar cada entidad como una fila en la tabla
                        $.each(data, function (index, entidad) {
                            $("#tablaEntidadesPublica").append(
                                    "<tr>" +
                                    "<td>" + entidad.nit + "</td>" +
                                    "<td>" + entidad.nombre + "</td>" +
                                    "</tr>"
                                    );
                        });
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        alert("Error al cargar entidades: " + textStatus);
                    }
                });
            });
        </script>



        <!-- Agregar nueva entidad -->
        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="myModalLabel">Agregar Entidad</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <form id="entity-form">
                            <div class="form-group">
                                <label for="input1">Nit Entidad</label>
                                <input type="text" class="form-control" id="nit" placeholder="Ingrese el NIT" required="">
                            </div>
                            <div class="form-group">
                                <label for="input2">Nombre Entidad</label>
                                <input type="text" class="form-control" id="nombreEntidadIngresar" readonly="">
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                                <button type="button" class="btn btn-primary" id="submit-btn">Guardar</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
