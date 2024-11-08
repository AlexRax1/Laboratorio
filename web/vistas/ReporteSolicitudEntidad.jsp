<%-- 
    Document   : ReporteSolicitudEntidad
    Created on : 24/10/2024, 12:46:02 AM
    Author     : alex1
--%>

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
        <title>Reportes Solicitud Entidad</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <style>
            .is-invalid {
                border-color: red; /* Cambia el borde a rojo para campos inválidos */
            }
        </style>
        <script>
            $(document).ready(function () {
                const today = new Date().toISOString().split("T")[0];
                $("#fechaDesde, #fechaHasta").attr("max", today);
                $("#fechaDesde, #fechaHasta").val(today);

                $("#reportForm").on("submit", function (event) {
                    event.preventDefault();
                    let isValid = true;
                    $("input").removeClass("is-invalid");
                    $("select").removeClass("is-invalid");

                    const desde = $("#fechaDesde").val().trim();
                    const hasta = $("#fechaHasta").val().trim();
                    if (desde === "") {
                        $("#fechaDesde").addClass("is-invalid");
                        isValid = false;
                    }
                    if (hasta === "") {
                        $("#fechaHasta").addClass("is-invalid");
                        isValid = false;
                    }

                    const nit = $("#nitSolicitante").val().trim();
                    const nombreSolicitante = $("#nombreSolicitante").val().trim();
                    const unidadAdministrativa = $("#unidadAdministrativa").val();
                    const entidadPrivada = $("#nombreEntidadPrivada").val();
                    const entidadPublica = $("#nombreEntidadPublica").val();

                    if (nit === "" && nombreSolicitante === "" &&
                            unidadAdministrativa === "" &&
                            entidadPrivada === "" &&
                            entidadPublica === "") {
                        alert("Debes llenar al menos un campo adicional.");
                        isValid = false;
                    }

                    if (!isValid) {
                        return;
                    }

                    const data = {
                        fechaDesde: desde,
                        fechaHasta: hasta,
                        nitSolicitante: nit,
                        nombreSolicitante: nombreSolicitante,
                        unidadAdministrativa: unidadAdministrativa,
                        nombreEntidadPrivada: entidadPrivada,
                        nombreEntidadPublica: entidadPublica
                    };

                    $.get("tuServletRN1", data, function (response) {
                        $("#formContainer").hide();
                        $("#tableContainer").show();
                        $("#reportTable tbody").empty();

                        // Título y metadatos
                        const now = new Date();
                        const creationDate = now.toLocaleString(); // Fecha y hora de creación
                        $("#reportTitle").text("REPORTE DE SOLICITUDES POR NIT Y NOMBRE");
                        $("#creationDate").text("Fecha y hora de creación: " + creationDate);
                        $("#fechaRango").text("Desde: " + desde + " Hasta: " + hasta);

                        response.forEach(function (item) {
                            $("#reportTable tbody").append(`
                                <tr>
                                    <td>${item.columna1}</td>
                                    <td>${item.columna2}</td>
                                    <td>${item.columna3}</td>
                                    <td>${item.columna4}</td>
                                    <td>${item.columna5}</td>
                                </tr>
                            `);
                        });
                    });
                });

                // Función para exportar la tabla a CSV
                $("#exportButton").click(function () {
                    let csv = [];
                    let rows = $("#reportTable tr");

                    for (let i = 0; i < rows.length; i++) {
                        let row = [];
                        $(rows[i]).find("td, th").each(function () {
                            row.push($(this).text());
                        });
                        csv.push(row.join(","));
                    }

                    const now = new Date();
                    const formattedDate = now.toISOString().replace(/T/, ' ').replace(/\..+/, '').replace(/:/g, '-'); // Formato para evitar caracteres no válidos en nombres de archivos
                    let csvFile = new Blob([csv.join("\n")], {type: "text/csv"});
                    let downloadLink = document.createElement("a");
                    downloadLink.download = `reporte_${formattedDate}.csv`; // Nombre del archivo con fecha y hora
                    downloadLink.href = window.URL.createObjectURL(csvFile);
                    downloadLink.style.display = "none";
                    document.body.appendChild(downloadLink);
                    downloadLink.click();
                    document.body.removeChild(downloadLink);
                });
            });
        </script>
    </head>
    <body>
        <div class="container mt-5" id="formContainer">
            <h2>Generar Reportes RN1</h2>
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
                    <label for="nitSolicitante" class="form-label">NIT del Solicitante:</label>
                    <input type="text" id="nitSolicitante" name="nitSolicitante" class="form-control" placeholder="Ingrese NIT">
                </div>
                <div class="mb-3">
                    <label for="nombreSolicitante" class="form-label">Nombre del Solicitante:</label>
                    <input type="text" id="nombreSolicitante" name="nombreSolicitante" class="form-control" placeholder="Ingrese Nombre">
                </div>
                <div class="mb-3">
                    <label for="unidadAdministrativa" class="form-label">Unidad Administrativa:</label>
                    <select id="unidadAdministrativa" name="unidadAdministrativa" class="form-select">
                        <option value="">Seleccione</option>
                        <option value="Unidad1">Unidad 1</option>
                        <option value="Unidad2">Unidad 2</option>
                        <!-- Añade más unidades según sea necesario -->
                    </select>
                </div>
                <div class="mb-3">
                    <label for="nombreEntidadPrivada" class="form-label">Nombre de Entidad Privada:</label>
                    <select id="nombreEntidadPrivada" name="nombreEntidadPrivada" class="form-select">
                        <option value="">Seleccione</option>
                        <option value="Entidad1">Entidad 1</option>
                        <option value="Entidad2">Entidad 2</option>
                        <!-- Añade más entidades privadas según sea necesario -->
                    </select>
                </div>
                <div class="mb-3">
                    <label for="nombreEntidadPublica" class="form-label">Nombre de Entidad Pública:</label>
                    <select id="nombreEntidadPublica" name="nombreEntidadPublica" class="form-select">
                        <option value="">Seleccione</option>
                        <option value="EntidadP1">Entidad Pública 1</option>
                        <option value="EntidadP2">Entidad Pública 2</option>
                        <!-- Añade más entidades públicas según sea necesario -->
                    </select>
                </div>
                <div class="d-flex justify-content-between">
                    <button type="submit" class="btn btn-primary">Buscar</button>
                    <button type="reset" class="btn btn-secondary" onclick="window.location.reload();">Limpiar Filtro</button>
                </div>
            </form>
        </div>

        <div class="container mt-5" id="tableContainer" style="display:none;">
            <h2 id="reportTitle"></h2>
            <p id="creationDate"></p>
            <p id="fechaRango"></p>
            <button id="exportButton" class="btn btn-success mt-3">Exportar a Excel</button>
            <table class="table table-bordered" id="reportTable">
                <thead>
                    <tr>
                        <th>Columna 1</th>
                        <th>Columna 2</th>
                        <th>Columna 3</th>
                        <th>Columna 4</th>
                        <th>Columna 5</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Aquí se llenarán los datos del reporte -->
                </tbody>
            </table>
        </div>

    </body>
</html>
