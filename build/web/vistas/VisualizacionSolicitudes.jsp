<%-- 
    Document   : VisualizacionSolicitudes
    Created on : 24/10/2024, 12:46:21 AM
    Author     : alex1
--%>
<%@ include file="barraNavegacion.jsp" %>
<%    // Verifica si el usuario est� autenticado
    if (session.getAttribute("usuario") == null) {
        // Redirige a index.jsp si no hay usuario
        response.sendRedirect("../index.jsp");
        return; // Asegura que no contin�e ejecutando el resto de la p�gina despu�s de la redirecci�n
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Vizualisaciones de solicitudes</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
        <script>
            $(document).ready(function () {
                // Funci�n para el bot�n de buscar
                $("#searchBtn").on('click', function (event) {
                    event.preventDefault(); // Evitar que el bot�n env�e el formulario

                    // Obtener los valores de los inputs
                    const numeroMuestraV = $('#numeroMuestraV').val().trim();
                    const nitProveedorV = $('#nitProveedorV').val().trim();

                    // Validar que los campos no est�n vac�os
                    if (!numeroMuestraV && !nitProveedorV) {
                        alert("Por favor, ingrese al menos el N�mero de Muestra o el NIT del Proveedor.");
                        return; // Salir si ambos est�n vac�os
                    }

                    $.ajax({
                        url: '${pageContext.request.contextPath}/buscarSolicitudesRE2', // Cambia esta URL por tu Servlet
                        type: 'GET',
                        dataType: 'json', // Aseg�rate de que la respuesta sea en formato JSON
                        data: {
                            numeroMuestra: numeroMuestraV,
                            nitProveedor: nitProveedorV
                        },
                        success: function (data) {
                            console.log("Datos recibidos:", data); // Verificar los datos recibidos

                            // Comprobar si la respuesta contiene datos
                            if (data && data.length > 0) {
                                $("#search-section").hide();
                                $("#segundoDiv").show();

                                const tbody = $('#resultTableBody');
                                tbody.empty(); // Limpiar la tabla antes de llenarla

                                // Agregar cada solicitud como una fila en la tabla
                                $.each(data, function (index, solicitud) {
                                    tbody.append(
                                            "<tr>" +
                                            "<td>" + solicitud.idSolicitud + "</td>" +
                                            "<td>" + solicitud.fechaSolicitud + "</td>" +
                                            "<td>" + solicitud.nitProveedor + "</td>" +
                                            "<td>" + solicitud.nombreProveedor + "</td>" +
                                            "<td>" + solicitud.numeroMuestra + "</td>" +
                                            "<td>" + solicitud.estadoSolicitud + "</td>" +
                                            "<td>" + solicitud.estadoMuestra + "</td>" +
                                            "<td>" + solicitud.estadoPorcionMuestra + "</td>" +
                                            "<td>" + solicitud.usuarioAsignado + "</td>" +
                                            "<td>" + solicitud.rolUsuarioAsignado + "</td>" +
                                            "<td>" +
                                            "<button class='btn btn-info btn-sm verSolicitudBtn'>Ver solicitud</button>" +
                                            "</td>" +
                                            "</tr>"
                                            );
                                });
                            } else {
                                alert("No se encontraron solicitudes con los criterios proporcionados.");
                            }
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            console.log('Error al buscar los datos:', jqXHR);
                            alert('Error al buscar los datos: ' + (textStatus || errorThrown || 'desconocido'));
                        }
                    });
                });

                // Delegaci�n del evento de clic para los botones "Ver solicitud"
                $(document).on('click', '.verSolicitudBtn', function () {
                    var idSolicitud = $(this).closest('tr').find('td:eq(0)').text(); // Obtener el n�mero de la solicitud

                    // Llamada AJAX al servlet
                    $.ajax({
                        url: '${pageContext.request.contextPath}/obtenerDocumentos', // Ajusta esta URL a tu ruta
                        method: 'GET',
                        dataType: 'json',
                        data: {idSolicitud: idSolicitud},
                        success: function (data) {
                            console.log(data); // Verifica los datos recibidos

                            if (data) {
                                $('#modalTabla').modal('show');

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
                                $('#etiquetaPorcionMuestra').append(generarBotones(data.etiqueta_porcion, 'pdfsEtiqueta', 'Etiqueta de Porci�n de Muestra'));
                                $('#certificadoEnsayo').append(generarBotones(data.certificado_ensayo, 'pdfsCertificado', 'Certificado de Ensayo'));
                                $('#opinionTecnica').append(generarBotones(data.opinion_tecnica, 'pdfsOpinion', 'Opini�n T�cnica Merceol�gica'));
                                $('#informe').append(generarBotones(data.informe, 'pdfsInforme', 'Informe'));
                                $('#providencia').append(generarBotones(data.providencia, 'pdfsProvidencia', 'Providencia'));
                                $('#documentosAnalisisExterno').append(generarBotones(data.doc_analisis, 'pdfsAnalisis', 'Documentos An�lisis Externo'));
                                $('#cartaNotificacion').append(generarBotones(data.notificacion, 'pdfsNotificacion', 'Carta de Notificaci�n'));
                                $('#constanciaDevolucionMuestra').append(generarBotones(data.devolucion, 'pdfsDevolucion', 'Constancia de Devoluci�n de Muestra'));
                            } else {
                                console.error("No se recibieron documentos correctamente.");
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error("Error en la petici�n AJAX: " + status + ", " + error);
                        }
                    });
                });

                // Funci�n para generar los botones de Ver y Descargar para cada documento
                function generarBotones(nombreArchivo, carpeta, tipoDocumento) {
                    // Verificar si el archivo est� vac�o o es nulo
                    if (!nombreArchivo || nombreArchivo.trim() === "") {
                        // Si no hay archivo, mostrar el nombre del documento como "No asignado"
                        return $('<p></p>').text(tipoDocumento + " - Documento no asignado").addClass('sin-dato');
                    }

                    // Asignamos la URL completa del archivo
                    var rutaCompleta = nombreArchivo;  // Asignamos el valor correctamente
                    console.log('Ruta Completa:', rutaCompleta); // Verificar la ruta que se est� construyendo

                    // Crear el t�tulo para el tipo de documento
                    var tituloDocumento = $('<h4></h4>').text(tipoDocumento).addClass('documento-titulo');

                    // Crear el bot�n de Ver usando jQuery
                    var verButton = $('<button></button>').text('Ver').val(rutaCompleta).addClass('view-btn');
                    verButton.click(function () {
                        window.open($(this).val(), '_blank');
                    });

                    // Crear el bot�n de Descargar usando jQuery
                    var descargarButton = $('<button></button>').text('Descargar').val(rutaCompleta).addClass('download-btn');
                    descargarButton.click(function () {
                        var pdfPath = $(this).val();
                        var link = document.createElement('a');
                        link.href = pdfPath;
                        link.download = pdfPath.split('/').pop(); // Obtener el nombre del archivo
                        link.click(); // Simula el clic para descargar
                    });

                    // Devolver los botones dentro de un contenedor, junto con el t�tulo
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


      
        </style>
    </head>
    <body>
        <div class="container mt-4">
            <!-- Primera Parte -->
            <div id="search-section" class="mb-4">
                <h3>Buscar Solicitud</h3>
                <div class="row g-3">
                    <div class="col-md-5">
                        <input type="text" id="numeroMuestraV" class="form-control" placeholder="Ingrese el N�mero de Muestra" required>
                    </div>
                    <div class="col-md-5">
                        <input type="text" id="nitProveedorV" class="form-control" placeholder="Ingrese el NIT del Proveedor" required>
                    </div>
                    <div class="col-md-2">
                        <button id="searchBtn" class="btn btn-primary">Buscar</button>
                    </div>
                </div>
            </div>

            <!-- Segunda Parte -->
            <div id="segundoDiv" style="display:none;">
                <h3>Resultados de la Solicitud</h3>
                <button class="btn btn-warning mt-3" onclick="location.reload();">Cargar otra solicitud</button>
                <div class="table-responsive">
                    <table id="resultTable" class="table table-bordered">

                        <thead>
                            <tr>
                                <th>Numero Muestra</th>
                                <th>Fecha Solicitud</th>
                                <th>NIT Proveedor</th>
                                <th>Nombre Proveedor</th>
                                <th>Numero Muestra</th>
                                <th>Estado Solicitud</th>
                                <th>Estado Muestra</th>
                                <th>Estado Porci�n Muestra</th>
                                <th>Usuario Asignado</th>
                                <th>Rol Usuario Asignado</th>
                                <th>Acci�n</th>
                            </tr>
                        </thead>
                        <tbody id="resultTableBody">
                            <!-- Aqu� se insertar�n las filas din�micamente -->
                        </tbody>
                    </table>



                </div>

                <!-- Modal de detalles de la solicitud -->
                <div class="modal fade" id="modalTabla" tabindex="-1" aria-labelledby="modalTablaLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="modalDetallesLabel">Detalles de la Solicitud</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div id="documentosContainer">
                                    <!-- Secciones de documentos generadas din�micamente -->
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
                                            <p class="sin-dato">Etiqueta de Porci�n de Muestra - Documento no asignado</p>
                                        </div>
                                    </div>

                                    <div class="seccion">
                                        <h3>An�lisis de la Muestra</h3>
                                        <div class="subseccion pdf-container" id="certificadoEnsayo">
                                            <p class="sin-dato">Certificado de Ensayo - Documento no asignado</p>
                                        </div>
                                        <div class="subseccion pdf-container" id="opinionTecnica">
                                            <p class="sin-dato">Opini�n T�cnica Merceologica - Documento no asignado</p>
                                        </div>
                                        <div class="subseccion pdf-container" id="informe">
                                            <p class="sin-dato">Informe - Documento no asignado</p>
                                        </div>
                                        <div class="subseccion pdf-container" id="providencia">
                                            <p class="sin-dato">Providencia - Documento no asignado</p>
                                        </div>
                                        <div class="subseccion pdf-container" id="documentosAnalisisExterno">
                                            <p class="sin-dato">Documentos An�lisis Externo - Documento no asignado</p>
                                        </div>
                                    </div>

                                    <div class="seccion">
                                        <h3>Otros</h3>
                                        <div class="subseccion pdf-container" id="documentoTecnico">
                                            <p class="sin-dato">Documento T�cnico - Documento no asignado</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </body>
</html>
