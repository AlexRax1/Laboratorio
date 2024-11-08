<%-- 
    Document   : ReasignacionSolicitudes
    Created on : 15/10/2024, 12:47:23 AM
    Author     : alex1
--%>

<%    // Verifica si el usuario está autenticado
    if (session.getAttribute("usuario") == null) {
        // Redirige a index.jsp si no hay usuario
        response.sendRedirect("../index.jsp");
        return; // Asegura que no continúe ejecutando el resto de la página después de la redirección
    }
%>
<%@ include file="barraNavegacion.jsp" %> <!-- Incluir la barra de navegación después de la verificación de sesión -->
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Formulario y Tablas Responsivas</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Mostrar u ocultar pasos -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>


        <script>
            $(document).ready(function () {
                $("#btnBuscar").on('click', function (event) {

                    event.preventDefault(); // Evitar que el botón envíe el formulario

                    var idbuscar = $('#idbuscar').val().trim(); // Eliminando espacios en blanco

                    // Validar que idbuscar no esté vacío
                    if (!idbuscar) {
                        alert("Por favor, ingrese un ID para buscar.");
                        return; // Salir si no hay ID
                    }

                    $.ajax({
                        url: '${pageContext.request.contextPath}/buscarSolicitudesRE',
                        type: 'GET',
                        dataType: 'json', // Asegúrate de que la respuesta sea en formato JSON
                        data: {
                            idBuscar: idbuscar
                        },
                        success: function (data) {
                            console.log("Datos recibidos:", data); // Verificar los datos recibidos
                            var tbody = $('#tablaCuerpo');
                            tbody.empty(); // Limpiar la tabla antes de llenarla

                            // Comprobar si hay resultados en el array
                            if (data.length === 0) {
                                alert("No se encontraron solicitudes.");
                            } else {
                                // Agregar cada solicitud como una fila en la tabla
                                $.each(data, function (index, solicitud) {
                                    tbody.append(
                                            "<tr>" +
                                            "<td>" + solicitud.nombreProveedor + "</td>" +
                                            "<td>" + solicitud.nitProveedor + "</td>" +
                                            "<td>" + solicitud.nitSolicitante + "</td>" +
                                            "<td>" + solicitud.nombreSolicitante + "</td>" +
                                            "<td>" + solicitud.usuario + "</td>" +
                                            "<td>" + solicitud.estadoSolicitud + "</td>" +
                                            "<td>" + solicitud.estadoMuestra + "</td>" +
                                            "<td>" + solicitud.estadoPorcion + "</td>" +
                                            "<td>" + solicitud.tipoSolicitud + "</td>" +
                                            "<td>" + solicitud.rol + "</td>" +
                                            "</tr>"
                                            );
                                });
                                $("#ingresoSolicitud").hide();
                                $("#tablaDatos").show();
                            }

                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            console.log('Error al buscar los datos:', jqXHR);
                            alert('Error al buscar los datos: ' + textStatus + ' ' + errorThrown);
                        }
                    });
                });

                $('#btnOtra').on('click', function () {
                    location.reload();
                });

            });
        </script>
        <script>
            $(document).ready(function () {
                // Mostrar el modal y el divSeleccionar al hacer clic en btnOtraNUsuario
                $('#btnOtraNUsuario').on('click', function () {
                    $('#divSeleccionar').show();
                    $('#divVer').hide();
                    $('#modalTabla').modal('show');
                });

                // Mostrar el modal y el divVer al hacer clic en btnVerSolicitud
                $('#btnVerSolicitud').on('click', function () {
                    $('#divVer').show();
                    $('#divSeleccionar').hide();
                    $('#modalTabla').modal('show');
                });
            });
        </script>

        <script>
            //ACTUALIZAR USUARIO
            //ACTUALIZAR USUARIO
            $(document).ready(function () {
                // Evento click en el botón de enviar
                $('#btnEnviarUsuario').on('click', function () {
                    // Obtener el valor del select
                    var valorSeleccionado = $('#usuarioExcluidoSelect').val();
                    var idSolicitud = $('#idbuscar').val();
                    var usuarioAnterior = $('#tablaDatos tbody tr:first td:nth-child(5)').text().trim();


                    // Verificar si se ha seleccionado un usuario
                    if (valorSeleccionado) {
                        console.log("Usuario seleccionado: " + valorSeleccionado); // Mostrar en consola

                        // Hacer la llamada AJAX
                        $.ajax({
                            url: '${pageContext.request.contextPath}/reasignarUsuario', // Cambia esto por la URL de tu servlet
                            type: 'POST',
                            dataType: 'json',
                            data: {usuarioNIT: valorSeleccionado, idSolicitud: idSolicitud}, // Enviar el valor seleccionado
                            success: function (data) {
                                // Manejar la respuesta del servidor
                                console.log("Respuesta del servidor: ", data);
                                alert("Se reasigno el usuario con éxito Usuario anterior: " + usuarioAnterior + ",Usuario nuevo: " + valorSeleccionado);
                                location.reload();
                                // Aquí puedes agregar lógica adicional para manejar la respuesta
                            },
                            error: function (xhr, status, error) {
                                alert("Error al enviar el usuario: " + error);
                            }
                        });
                    } else {
                        alert("Por favor, selecciona un usuario.");
                    }
                });
            });
        </script>



        <script>
            $(document).ready(function () {
                $('#btnVerSolicitud').on('click', function () {
                    var idSolicitud = $('#idbuscar').val(); // Obtener el ID de la solicitud

                    // Llamada AJAX al servlet
                    $.ajax({
                        url: '${pageContext.request.contextPath}/obtenerDocumentos', // Ajusta esta URL a tu ruta
                        method: 'GET',
                        dataType: 'json',
                        data: {idSolicitud: idSolicitud},
                        success: function (data) {
                            console.log(data); // Verifica los datos recibidos

                            if (data) {
                                // Limpiar las secciones para los nuevos botones
                                $('#solicitudRN02').empty();
                                $('#etiquetaMuestra').empty();
                                $('#etiquetaPorcionMuestra').empty();
                                $('#certificadoEnsayo').empty();
                                $('#opinionTecnica').empty();
                                $('#informe').empty();
                                $('#providencia').empty();
                                $('#documentosAnalisisExterno').empty();
                                $('#cartaNotificacion').empty();
                                $('#constanciaDevolucionMuestra').empty();

                                // Asignar el ID de la solicitud como texto plano
                                $('#solicitudRN02').append('<h2>ID Solicitud: ' + idSolicitud + '</h2>');
                                $('#etiquetaMuestra').append(generarBotones(data.etiqueta_muestra, 'pdfsEtiqueta', 'Etiqueta de Muestra'));
                                $('#etiquetaPorcionMuestra').append(generarBotones(data.etiqueta_porcion, 'pdfsEtiqueta', 'Etiqueta de Porción de Muestra'));
                                $('#certificadoEnsayo').append(generarBotones(data.certificado_ensayo, 'pdfsCertificado', 'Certificado de Ensayo'));
                                $('#opinionTecnica').append(generarBotones(data.opinion_tecnica, 'pdfsOpinion', 'Opinión Técnica Merceológica'));
                                $('#informe').append(generarBotones(data.informe, 'pdfsInforme', 'Informe'));
                                $('#providencia').append(generarBotones(data.providencia, 'pdfsProvidencia', 'Providencia'));
                                $('#documentosAnalisisExterno').append(generarBotones(data.doc_analisis, 'pdfsAnalisis', 'Documentos Análisis Externo'));
                                $('#cartaNotificacion').append(generarBotones(data.notificacion, 'pdfsNotificacion', 'Carta de Notificación'));
                                $('#constanciaDevolucionMuestra').append(generarBotones(data.devolucion, 'pdfsDevolucion', 'Constancia de Devolución de Muestra'));
                            } else {
                                console.error("No se recibieron documentos correctamente.");
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error("Error en la petición AJAX: " + status + ", " + error);
                        }
                    });
                });

                // Función para generar los botones de Ver y Descargar para cada documento
                function generarBotones(nombreArchivo, carpeta, tipoDocumento) {
                    // Verificar si el archivo está vacío o es nulo
                    if (!nombreArchivo || nombreArchivo.trim() === "") {
                        // Si no hay archivo, mostrar el nombre del documento como "No asignado"
                        return $('<p></p>').text(tipoDocumento + " - Documento no asignado").addClass('sin-dato');
                    }

                    // Asignamos la URL completa del archivo
                    var rutaCompleta = nombreArchivo;  // Asignamos el valor correctamente
                    console.log('Ruta Completa:', rutaCompleta); // Verificar la ruta que se está construyendo

                    // Crear el título para el tipo de documento
                    var tituloDocumento = $('<h4></h4>').text(tipoDocumento).addClass('documento-titulo');

                    // Crear el botón de Ver usando jQuery
                    var verButton = $('<button></button>').text('Ver').val(rutaCompleta).addClass('view-btn');
                    verButton.click(function () {
                        window.open($(this).val(), '_blank');
                    });

                    // Crear el botón de Descargar usando jQuery
                    var descargarButton = $('<button></button>').text('Descargar').val(rutaCompleta).addClass('download-btn');
                    descargarButton.click(function () {
                        var pdfPath = $(this).val();
                        var link = document.createElement('a');
                        link.href = pdfPath;
                        link.download = pdfPath.split('/').pop(); // Obtener el nombre del archivo
                        link.click(); // Simula el clic para descargar
                    });

                    // Devolver los botones dentro de un contenedor, junto con el título
                    var container = $('<div class="pdf-container"></div>');
                    container.append(tituloDocumento).append(verButton).append(descargarButton);

                    return container;
                }
            });
        </script>


        <style>
            .seccion {
                margin: 20px 0;
            }
            .subseccion {
                margin-left: 20px;
            }
            .pdf-container {
                border: 1px dashed #ccc;
                padding: 10px;
                min-height: 50px;
                color: #777;
                text-align: center;
            }
            .pdf-container .sin-dato {
                color: #aaa; /* Color gris para el texto cuando no hay PDF */
            }


            /* Modo oscuro 
            @media (prefers-color-scheme: dark) {
                body {
                    background-color: #121212;
                    color: #f5f5f5;
                }
            }*/
        </style>

    </head>
    <body class="container mt-4">

        <!-- Primer apartado con 2 inputs y un botón -->
        <div class="mb-4" id="ingresoSolicitud">
            <form id="primerFormulario"  method="POST">
                <div class="row">
                    <div class="col-12 col-md-6 mb-3">
                        <label for="input1" class="form-label">Reasignar Muestra o porcion de Muestra</label>
                        <input type="text" class="form-control" id="idbuscar" name="nombre1" placeholder="Ingrese el primer nombre">
                    </div>

                </div>
                <div class="text-center">
                    <button type="submit" class="btn btn-primary" id="btnBuscar">Buscar</button>
                </div>
            </form>
        </div>

        <!-- Tabla dinámica (Segundo paso) -->
        <div class="mb-4" id="tablaDatos" style="display:none;">
            <div class="table-responsive">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>Nombre Proveedor</th>
                            <th>NIT Proveedor</th>
                            <th>Nit Solicitante</th>
                            <th>Nombre Solicitante</th>
                            <th>Usuario Asignado(nit)</th>
                            <th>Estado de la Solicitud</th>
                            <th>Estado de la Muestra</th>
                            <th>Estado de la Porcion de Muestra</th>
                            <th>Tipo Solicitud</th>
                            <th>Rol</th>
                        </tr>
                    </thead>
                    <tbody id="tablaCuerpo">
                        <!-- Las filas de la tabla se llenarán dinámicamente aquí -->
                    </tbody>                    
                </table>
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-warning" id="btnOtra" name="accion" value="botonUnico">Cargar Otra Solicitud</button>
            </div>
            <div class="text-center">
                <button type="button" class="btn btn-primary open-modal-btn" id="btnOtraNUsuario" name="accion" value="">Seleccionar Nuevo Usuario</button>
            </div>
            <div class="text-center">
                <button type="button" class="btn btn-primary open-modal-btn" id="btnVerSolicitud" name="accion" value="">Ver Solicitud</button>
            </div>
        </div>

        <!-- Modal  -->
        <div class="modal fade" id="modalTabla" tabindex="-1" aria-labelledby="modalTablaLabel" aria-hidden="true">
            <div class="modal-dialog" id="divSeleccionar">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalSeleccionarLabel">Reasignar Usuario</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <h2>seleccione nuevo usuario</h2>
                        <select id="usuarioExcluidoSelect" required>
                            <option value="">Seleccione un usuario</option>
                        </select>
                        <button id="btnEnviarUsuario" class="btn btn-primary">Reasignar</button> <!-- Botón para enviar -->
                    </div>
                </div>
            </div>

            <div class="modal-dialog" id="divVer" style="display: none;">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalDetallesLabel">Detalles de la Solicitud</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div id="documentosContainer">
                            <!-- Secciones de documentos generadas dinámicamente -->
                            <div class="seccion">
                                <h3>Datos de la Solicitud</h3>
                                <div class="pdf-container" id="solicitudRN02">
                                    <p class="sin-dato">Documento no asignado</p>
                                </div>
                            </div>

                            <div class="seccion">
                                <h3>Etiquetas</h3>
                                <div class="subseccion pdf-container" id="etiquetaMuestra">
                                    <p class="sin-dato">Etiqueta de Muestra - Documento no asignado</p>
                                </div>
                                <div class="subseccion pdf-container" id="etiquetaPorcionMuestra">
                                    <p class="sin-dato">Etiqueta de Porción de Muestra - Documento no asignado</p>
                                </div>
                            </div>

                            <div class="seccion">
                                <h3>Análisis de la Muestra</h3>
                                <div class="subseccion pdf-container" id="certificadoEnsayo">
                                    <p class="sin-dato">Certificado de Ensayo - Documento no asignado</p>
                                </div>
                                <div class="subseccion pdf-container" id="opinionTecnica">
                                    <p class="sin-dato">Opinión Técnica Merceologica - Documento no asignado</p>
                                </div>
                                <div class="subseccion pdf-container" id="informe">
                                    <p class="sin-dato">Informe - Documento no asignado</p>
                                </div>
                                <div class="subseccion pdf-container" id="providencia">
                                    <p class="sin-dato">Providencia - Documento no asignado</p>
                                </div>
                                <div class="subseccion pdf-container" id="documentosAnalisisExterno">
                                    <p class="sin-dato">Documentos Análisis Externo - Documento no asignado</p>
                                </div>
                            </div>

                            <div class="seccion">
                                <h3>Notificación de la Muestra</h3>
                                <div class="subseccion pdf-container" id="cartaNotificacion">
                                    <p class="sin-dato">Carta y Notificación de la Carta - Documento no asignado</p>
                                </div>
                            </div>

                            <div class="seccion">
                                <h3>Devolución de la Muestra</h3>
                                <div class="subseccion pdf-container" id="constanciaDevolucionMuestra">
                                    <p class="sin-dato">Constancia de Devolución de Muestra - Documento no asignado</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>




        <script>
            // Cargar Usuarios para el select menos uno
            $(document).ready(function () {
                // Evento click en el botón
                $('#btnOtraNUsuario').on('click', function () {
                    // Obtener el valor del select
                    var valorSeleccionado = $('#tablaDatos tbody tr:first td:nth-child(5)').text().trim();
                    ;
                    console.log(" nit select: " + valorSeleccionado);

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
                                        $('<option></option>').val(usuario.nit).text('Nit: ' + usuario.nit + '   |   Usuario: ' + usuario.nombre) // Cambia el valor a NIT si es necesario
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
    </body>

</html>