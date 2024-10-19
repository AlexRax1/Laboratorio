<%-- 
    Document   : ReasignacionSolicitudes
    Created on : 15/10/2024, 12:47:23 AM
    Author     : alex1
--%>

<%@ include file="barraNavegacion.jsp" %>
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
                // Al hacer clic en el botón "Buscar", realizar la consulta para llenar la tabla
                $("#btnBuscar").on('click', function (event) {
                    $("#ingresoSolicitud").hide();
                            // Mostrar la tabla
                            $("#tablaDatos").show();
                    event.preventDefault(); // Evitar que el botón envíe el formulario
                    $.ajax({
                        url: '${pageContext.request.contextPath}/buscarSolicitudes', // Servlet que devuelve los datos
                        type: 'GET',
                        dataType: 'json',
                        success: function (data) {
                            var tbody = $('#tablaCuerpo');
                            tbody.empty(); // Limpiar tabla

                            // Llenar la tabla con los datos obtenidos del servlet
                            data.forEach(function (fila) {
                                var row = `
                                <tr>
                                    <td class="dato1">${fila.id}</td>
                                    <td class="dato2">${fila.dato}</td>
                                    <td>
                                        <button type="button" class="btn btn-warning open-modal-btn" data-bs-toggle="modal" data-bs-target="#modalTabla">
                                            Abrir Modal
                                        </button>
                                    </td>
                                </tr>`;
                                tbody.append(row);
                            });

                            // Actualizar el atributo aria-hidden del div
                            $("#div1").attr("aria-hidden", "true");
                            
                            
                        }
                            
                    });
                });
                $('#btnOtra').on('click', function () {
                    location.reload();
                });

                // Al hacer clic en "Abrir Modal", capturar los datos de la fila
                $('.open-modal-btn').on('click', function () {
                    var row = $(this).closest('tr'); // Encontrar la fila más cercana
                    var id = row.find('.dato1').text(); // Obtener el valor de la columna 1 (id)
                    var dato2 = row.find('.dato2').text(); // Obtener el valor de la columna 2
                    // Guardar el ID en un campo oculto del modal
                    $('#modalId').val(id);
                    // Aquí haces la consulta AJAX para llenar la tabla del modal con los datos del servidor
                    $.ajax({
                        url: '${pageContext.request.contextPath}/buscarModal', // El servlet para hacer la segunda consulta
                        type: 'POST',
                        data: {id: id}, // Mandar el ID de la fila al servlet
                        success: function (response) {
                            // Llenar la tabla dentro del modal con los datos obtenidos
                            $('#modalDato1').text(response.dato1);
                            $('#modalDato2').text(response.dato2);
                            // Si el servlet devuelve más datos, puedes agregarlos aquí
                        }
                    });
                });
            });
        </script>
    </head>
    <body class="container mt-4">

        <!-- Primer apartado con 2 inputs y un botón -->
        <div class="mb-4" id="ingresoSolicitud">
            <form id="primerFormulario"  method="POST">
                <div class="row">
                    <div class="col-12 col-md-6 mb-3">
                        <label for="input1" class="form-label">Nombre 1</label>
                        <input type="text" class="form-control" id="input1" name="nombre1" placeholder="Ingrese el primer nombre">
                    </div>
                    <div class="col-12 col-md-6 mb-3">
                        <label for="input2" class="form-label">Nombre 2</label>
                        <input type="text" class="form-control" id="input2" name="nombre2" placeholder="Ingrese el segundo nombre">
                    </div>
                </div>
                <div class="text-center">
                    <button type="submit" class="btn btn-primary" id="btnBuscar">Buscar</button>
                </div>
            </form>
        </div>

        <!-- Tabla dinámica (Segundo paso) -->
        <div class="mb-4" id="tablaDatos" style="display:none;">
            <form action="tuSegundoServlet" method="POST">
                <div class="table-responsive">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Col 1</th>
                                <th>Col 2</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody id="tablaCuerpo">
                            <!-- Las filas de la tabla se llenarán dinámicamente aquí -->
                            
                        </tbody>
                    </table>
                </div>
            </form>
            <div class="text-center">
                <button type="submit" class="btn btn-warning" id="btnOtra" name="accion" value="botonUnico">Cargar Otra Solicitud</button>
            </div>
        </div>

        <!-- Modal (Tercer paso) -->
        <div class="modal fade" id="modalTabla" tabindex="-1" aria-labelledby="modalTablaLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalTablaLabel">Detalles de la fila</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="tuTercerServlet" method="POST">
                            <input type="hidden" id="modalId" name="id"> <!-- Campo oculto con el ID de la fila -->
                            <div class="table-responsive">
                                <table class="table table-bordered">
                                    <thead>
                                        <tr>
                                            <th>Col 1</th>
                                            <th>Col 2</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td id="modalDato1">Dato 1</td>
                                            <td id="modalDato2">Dato 2</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>

</html>