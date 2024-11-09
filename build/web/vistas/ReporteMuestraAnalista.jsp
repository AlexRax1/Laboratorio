<%-- 
    Document   : ReporteMuestraAnalista
    Created on : 24/10/2024, 12:45:35 AM
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
        <title>Reporte de Muestras Asignadas por analista</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.1/xlsx.full.min.js"></script>
        <style>
            .is-invalid {
                border-color: red; /* Cambia el borde a rojo para campos inv�lidos */
            }
        </style>
        <script>
            $(document).ready(function () {
                // Obtener la fecha actual
                const hoy = new Date();
                const fechaActual = hoy.toLocaleDateString('en-CA');   // Formato YYYY-MM-DD

                // Establecer la fecha actual por defecto en los inputs
                $("#fechaDesde").val(fechaActual);
                $("#fechaHasta").val(fechaActual);

                // Establecer el rango de fechas permitido
                const unAnoAntes = new Date();
                unAnoAntes.setFullYear(hoy.getFullYear() - 1);
                const fechaUnAnoAntes = unAnoAntes.toISOString().split("T")[0];  // Formato YYYY-MM-DD

                // Establecer el atributo min y max de los inputs
                $("#fechaDesde, #fechaHasta").attr("min", fechaUnAnoAntes);
                $("#fechaDesde, #fechaHasta").attr("max", fechaActual);

                // Validaci�n de fechas
                function validarFechas() {
                    const fechaDesde = new Date($("#fechaDesde").val());
                    const fechaHasta = new Date($("#fechaHasta").val());

                    // Validar que la fecha de inicio no sea posterior a la fecha actual
                    if (fechaDesde > hoy) {
                        alert("La fecha de inicio no puede ser posterior a la fecha actual.");
                        return false;
                    }

                    // Validar que la fecha de fin no sea posterior a la fecha actual
                    if (fechaHasta > hoy) {
                        alert("La fecha de fin no puede ser posterior a la fecha actual.");
                        return false;
                    }

                    // Validar que las fechas no sean m�s antiguas que un a�o
                    if (fechaDesde < unAnoAntes || fechaHasta < unAnoAntes) {
                        alert("Las fechas no pueden ser anteriores a un a�o.");
                        return false;
                    }

                    return true;
                }

                // Exportar a Excel
                $("#exportButton").on("click", function () {
                    const fechaDesde = $("#fechaDesde").val();  // Obtener valor de fecha de inicio
                    const fechaHasta = $("#fechaHasta").val();  // Obtener valor de fecha de fin

                    // Obtener la fecha y hora de creaci�n
                    const now = new Date();
                    const creationDate = now.toLocaleString();
                    const usuarioSesion = '${sessionScope.usuario}';

                    // Crear el encabezado con los nombres de las columnas y las fechas
                    const header = [
                        ["Usuario:  ", usuarioSesion],
                        ["Fecha de Creaci�n", creationDate],
                        ["Hora de Creaci�n", creationDate.split(",")[1].trim()],
                        ["Reporte de Muestras Asignadas por Analista"],
                        ["Fecha Inicio: " + fechaDesde, "Fecha Fin: " + fechaHasta], // Concatenar fechas aqu�
                        ["No.", "Nombre Analista", "Estado de la Muestra", "Estado de la Solicitud",
                            "Fecha Inicio An�lisis", "N�mero de Muestra", "Tipo de Solicitud",
                            "NIT Proveedor", "Nombre Solicitante", "Fecha Fin An�lisis", "Descripci�n del Producto"]
                    ];

                    // Crear el contenido de la tabla
                    let tableData = [];
                    $("#reportTable tbody tr").each(function () {
                        const row = [];
                        $(this).find("td").each(function () {
                            row.push($(this).text());
                        });
                        tableData.push(row);
                    });

                    // Unir el encabezado con los datos
                    const excelData = [...header, ...tableData];

                    // Crear un libro de trabajo con la librer�a xlsx
                    const wb = XLSX.utils.book_new();
                    const ws = XLSX.utils.aoa_to_sheet(excelData);
                    XLSX.utils.book_append_sheet(wb, ws, "Reporte");

                    // Descargar el archivo Excel
                    XLSX.writeFile(wb, "reporte_muestras_asignadas_" + creationDate + ".xlsx");
                });

                // Validaci�n del formulario
                $("#reportForm").on("submit", function (event) {
                    event.preventDefault();

                    // Validaci�n de los datos del formulario
                    let isValid = true;
                    $("input").removeClass("is-invalid");

                    const desde = $("#fechaDesde").val().trim();
                    const hasta = $("#fechaHasta").val().trim();
                    const numeroMuestra = $("#numeroMuestra").val().trim();

                    // Obtener analistas seleccionados
                    const analistasSeleccionados = $("#usuariosSelect").val(); // Obtiene un array con los valores

                    // Validaci�n de fechas
                    if (!validarFechas()) {
                        isValid = false;
                    }

                    // Validaci�n de campos
                    if (desde === "") {
                        $("#fechaDesde").addClass("is-invalid");
                        isValid = false;
                    }
                    if (hasta === "") {
                        $("#fechaHasta").addClass("is-invalid");
                        isValid = false;
                    }
                    if (analistasSeleccionados.length === 0 && numeroMuestra === "") {
                        alert("Debes llenar 'Analista' o 'N�mero de muestra'.");
                        isValid = false;
                    }

                    if (!isValid)
                        return;

                    // Par�metros para enviar con la solicitud GET
                    const params = {
                        fechaInicio: desde,
                        fechaFin: hasta,
                        analistas: analistasSeleccionados.join(','), // Convertir el array a un string separado por comas
                        numeroMuestra: numeroMuestra
                    };

                    // Llamada AJAX manual usando $.ajax()
                    $.ajax({
                        url: "${pageContext.request.contextPath}/datosTablaReporteAnalisis",
                        type: "GET",
                        data: params,
                        dataType: "json",
                        success: function (response) {
                            // Mostrar y llenar la tabla con los datos recibidos
                            $("#formContainer").hide();
                            $("#tableContainer").show();
                            $("#reportTable tbody").empty();

                            // Llenar metadatos
                            const now = new Date();
                            const creationDate = now.toLocaleString();
                            $("#reportTitle").text("REPORTE DE MUESTRAS ASIGNADAS POR ANALISTA");
                            $("#creationDate").text("Fecha y hora de creaci�n: " + creationDate);
                            $("#fechaRango").text("Desde: " + desde + " Hasta: " + hasta);

                            // Iterar sobre los datos recibidos y agregarlos a la tabla
                            response.forEach(function (item, index) {
                                $("#reportTable tbody").append(
                                        "<tr>" +
                                        "<td>" + (index + 1) + "</td>" +
                                        "<td>" + item.usuarioAsignado + "</td>" +
                                        "<td>" + item.estadoMuestra + "</td>" +
                                        "<td>" + item.estadoSolicitud + "</td>" +
                                        "<td>" + item.fechaSolicitud + "</td>" +
                                        "<td>" + item.idSolicitud + "</td>" +
                                        "<td>" + item.tipoSolicitud + "</td>" +
                                        "<td>" + item.nitProveedor + "</td>" +
                                        "<td>" + item.nombreSolicitante + "</td>" +
                                        "<td>" + item.fechaFin + "</td>" +
                                        "<td>" + item.descripcion + "</td>" +
                                        "</tr>"
                                        );
                            });
                        },
                        error: function (xhr, status, error) {
                            alert("No se encontraron muestras con los par�metros ingresados");
                        }
                    });
                });
            });
        </script>


    </head>
    <body>
        <div class="container mt-5" id="formContainer">
            <h2>Generar Reportes</h2>
            <form id="reportForm" method="GET">
                <div class="mb-3">
                    <label for="fechaDesde" class="form-label">Desde:</label>
                    <input type="date" id="fechaDesde" name="fechaDesde" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label for="fechaHasta" class="form-label">Hasta:</label>
                    <input type="date" id="fechaHasta" name="fechaHasta" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label for="usuariosSelect" class="form-label">Seleccione uno o m�s analistas</label>
                        <select id="usuariosSelect" class="form-select" name="analista[]" multiple size="5">
                        <option value="">Seleccione uno o m�s analistas</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="numeroMuestra" class="form-label">N�mero de muestra:</label>
                    <input type="text" id="numeroMuestra" name="numeroMuestra" class="form-control" placeholder="N�mero de muestra">
                </div>
                <div class="d-flex justify-content-between">
                    <button type="submit" class="btn btn-primary">Buscar</button>
                </div>
            </form>
        </div>
        <button type="reset" class="btn btn-secondary" onclick="window.location.reload();">Limpiar Filtro</button>

        <div class="container mt-5" id="tableContainer" style="display:none;">
            <h2 id="reportTitle"></h2>
            <p id="creationDate"></p>
            <p id="fechaRango"></p>
            <button id="exportButton" class="btn btn-success mt-3">Exportar a Excel</button>
            <table class="table table-bordered" id="reportTable">
                <thead>
                    <tr>
                        <th>No.</th>
                        <th>Nombre Analista</th>
                        <th>Estado de la muestra</th>
                        <th>Estado de la solicitud</th>
                        <th>Fecha Inicio An�lisis</th>
                        <th>N�mero de Muestra</th>
                        <th>Tipo de Solicitud</th>
                        <th>NIT Proveedor</th>
                        <th>Nombre Solicitante</th>
                        <th>Fecha Fin An�lisis</th>
                        <th>Descripci�n del Producto</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Se llenar� din�micamente con AJAX -->
                </tbody>
            </table>
        </div>


        <script>
            $(document).ready(function () {
                $.ajax({
                    url: '${pageContext.request.contextPath}/cargarAnalistas3', // La URL del servlet
                    type: 'GET',
                    dataType: 'json', // El formato de la respuesta es JSON
                    success: function (data) {
                        // Limpiar las opciones antes de agregar nuevas
                        $('#usuariosSelect').empty();

                        // Agregar la opci�n por defecto
                        $('#usuariosSelect').append('<option value="">Seleccione uno o m�s analistas</option>');

                        // Recorre cada objeto del arreglo JSON recibido
                        $.each(data, function (index, usuario) {
                            // Agregar una opci�n al select por cada usuario
                            $('#usuariosSelect').append(
                                    $('<option></option>')
                                    .val(usuario.nit)
                                    .text('nit: ' + usuario.nit + '   Usuario: ' + usuario.nombre)
                                    );
                        });
                    },
                    error: function (xhr, status, error) {
                        alert("Error al cargar los usuarios: " + error);
                    }
                });
            });
        </script>
    </body>
</html>
