<%-- 
    Document   : MantenimientoUsuarios
    Created on : 17/10/2024, 05:44:40 PM
    Author     : alex1
--%>

<%@page import="java.util.List"%>
<%@page import="Modelo.Usuario"%>
<%@page import="java.util.ArrayList"%>
<%@ include file="barraNavegacion.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mantenimiento de Usuarios</title>
        <!-- Bootstrap CSS (Asegúrate de tener los archivos de Bootstrap o linkearlos a un CDN) -->
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

        <!-- jQuery (Necesario para las interacciones) -->
        <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
        <script>
            $(document).ready(function () {
                // Función para cargar los datos de usuarios al cargar la página
                $.ajax({
                    url: '${pageContext.request.contextPath}/datosUsuario',
                    type: 'GET',
                    dataType: 'json',
                    success: function (data) {
                        $("#tablaUsuarios tbody").empty();

                        $.each(data, function (index, usuario) {
                            var estado = usuario.estado ? "Activo" : "Inactivo";
                            $("#tablaUsuarios tbody").append(
                                    "<tr>" +
                                    "<td>" + usuario.nit + "</td>" +
                                    "<td>" + usuario.nombre + "</td>" +
                                    "<td>" + usuario.rolNombre + "</td>" +
                                    "<td>" + usuario.actor + "</td>" +
                                    "<td>" + estado + "</td>" +
                                    "<td>" + usuario.cargoTrabajo + "</td>" +
                                    "<td><button class='btn btn-primary cambiar-estado' data-id='" + usuario.nit + "'>Cambiar Estado</button></td>" +
                                    "</tr>"
                                    );
                        });

                        if (data.length === 0) {
                            $("#tablaUsuarios tbody").append('<tr><td colspan="7">No hay usuarios registrados</td></tr>');
                        }
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        alert("Error al cargar usuarios: " + textStatus);
                    }
                });

                // Cambiar Estado
                $(document).on('click', '.cambiar-estado', function () {
                    limpiarFormulario();
                    var nit = $(this).data('id'); // Obtener el NIT
                    var nombre = $(this).closest('tr').find('td:eq(1)').text(); // Obtener el nombre de la segunda celda
                    $('#nitEstado').val(nit);
                    $('#nombreEstado').val(nombre);

                    $('#modalCambiarEstado').modal('show');
                });


                // guardar nuevo estado
                // guardar nuevo estado
                // guardar nuevo estado
                $('#form-cambiar-estado').on('submit', function (e) {
                    e.preventDefault();

                    var nit = $('#nitEstado').val();
                    var reasignar = $('#reasignar').prop('checked');
                    ;

                    // Validar si el NIT tiene solicitudes activas
                    $.ajax({
                        url: '${pageContext.request.contextPath}/verificarSolicitudes', // Asegúrate de crear este servlet
                        type: 'GET',
                        data: {nit: nit},
                        success: function (response) {
                            if (response.tieneSolicitudesActivas) {
                                // Si tiene solicitudes activas, mostrar campos adicionales
                                if (reasignar) {
                                    cargarSolicitudes();
                                    $('#modalReasignar').hide();
                                    $('#tablaReasignar').show();

                                } else {
                                    alert("Este NIT tiene solicitudes activas. Llena los campos adicionales antes de continuar.");
                                }
                            } else {
                                // Si no tiene solicitudes activas, proceder a cambiar el estado
                                enviarCambioEstado();
                            }
                        },
                        error: function () {
                            alert('Error al verificar las solicitudes activas');
                        }
                    });
                });



                // Función para enviar la solicitud de cambio de estado
                function enviarCambioEstado() {
                    var nit = $('#nitEstado').val();
                    var nuevoEstado = $('#nuevoEstado').val();
                    var motivo = $('#comentario').val();
                    var nitAdicion = loginUsuario;

                    $.ajax({
                        url: '${pageContext.request.contextPath}/cambiarEstado',
                        type: 'POST',
                        data: {
                            nit: nit,
                            nuevoEstado: nuevoEstado,
                            motivo: motivo,
                            nitAdicion: nitAdicion
                        },
                        success: function () {
                            alert("Cambio realizado con éxito");
                            $('#modalCambiarEstado').modal('hide');
                            location.reload();
                        },
                        error: function () {
                            alert('Error al cambiar el estado');
                        }
                    });
                }




                // Manejar el clic en el botón "Agregar Usuario"
                $('#agregarUsuario').on('click', function () {
                    $('#main-content').hide();
                    $('#formulario-usuario').show();
                });

                // Manejar el clic en el botón "Volver"
                $('#volver').on('click', function () {
                    $('#formulario-usuario').hide();
                    $('#main-content').show();
                });



                //buscar Usuario
                $('#buscaru').on('click', function (e) {
                    e.preventDefault();

                    var login = $('#loginu').val();
                    var nit = $('#nitubuscar').val();
                    $.ajax({
                        url: '${pageContext.request.contextPath}/buscarUsuario',
                        type: 'GET',
                        data: {
                            login: login,
                            nit: nit
                        },
                        success: function (data) {

                            $('#nombreg').val(data.nombre);
                            $('#loging').val(data.login);
                            $('#nitg').val(data.nit);
                            $('#rolg').val(data.rol);

                        },
                        error: function () {
                            alert('Usuario no encontrado');
                        }
                    });
                });


                //Agregar Usuario
                $('#guardaru').on('click', function (e) {
                    e.preventDefault();
                    var nit = $('#nitg').val();
                    $.ajax({
                        url: '${pageContext.request.contextPath}/agregarUsuario',
                        type: 'POST',
                        data: {
                            nit: nit
                        },
                        success: function (data) {
                            alert('Usuario agregado correctamente');
                            location.reload();
                        },
                        error: function () {
                            alert('no se pudo agregar');
                        }
                    });
                });





                //REASIGNAR TODAS LAS SOLICITUDES
                //REASIGNAR TODAS LAS SOLICITUDES
                //REASIGNAR TODAS LAS SOLICITUDES
                function cargarSolicitudes() {
                    // Obtener el valor del NIT del estado
                    var usuario = $('#nitEstado').val();

                    // Realizar la solicitud AJAX para obtener las solicitudes, pasando el usuario como parámetro
                    $.ajax({
                        url: '${pageContext.request.contextPath}/obtenerSolicitudesAnalista', // URL del servlet o endpoint
                        type: 'GET',
                        data: {
                            nit: usuario // Enviamos el loginUsuario como parámetro
                        },
                        success: function (response) {
                            var solicitudes = response.solicitudes; // Asegúrate de que los datos devueltos tengan esta estructura
                            var tabla = $('#tablaSolicitudes tbody'); // Selecciona la tabla por su ID
                            tabla.empty(); // Limpia la tabla antes de agregar los nuevos datos

                            // Hacer una llamada AJAX para cargar los usuarios para el select, pasando también el loginUsuario
                            $.ajax({
                                url: '${pageContext.request.contextPath}/cargarAnalistas2', // Cambia la URL si es necesario
                                type: 'GET',
                                dataType: 'json',
                                data: {
                                    valor: usuario // Enviamos el loginUsuario aquí también
                                },
                                success: function (data) {
                                    // Verifica la estructura de los datos devueltos (depuración)
                                    console.log(data);

                                    // Recorre cada solicitud para agregarla a la tabla
                                    solicitudes.forEach(function (solicitud) {
                                        var row = $('<tr>');
                                        row.append('<td>' + solicitud.numero_muestra + '</td>');
                                        row.append('<td>' + solicitud.estado_solicitud + '</td>');
                                        row.append('<td>' + solicitud.estado_muestra + '</td>');

                                        // Columna con un select
                                        var select = $('<select required>');
                                        select.append('<option value="">Seleccione un usuario</option>'); // Opción predeterminada

                                        // Recorrer los usuarios cargados y agregar las opciones al select
                                        $.each(data, function (index, analista) {
                                            select.append(
                                                    $('<option></option>').val(analista.nit).text('Nit: ' + analista.nit + '   |   Usuario: ' + analista.nombre)
                                                    );
                                        });

                                        // Añadir el select a la fila
                                        row.append($('<td>').append(select));

                                        // Añadir la fila a la tabla
                                        tabla.append(row);
                                    });
                                },
                                error: function (xhr, status, error) {
                                    console.log(xhr.responseText); // Ver detalles del error
                                    alert("Error al cargar los usuarios: " + error);
                                }
                            });
                        },
                        error: function () {
                            alert('Error al cargar las solicitudes');
                        }
                    });
                }

                $('#btnCambiarEstadoRe').click(function () {
                    // Llamar a guardarAsignaciones y verificar si se ejecutó correctamente
                    var asignacionesGuardadas = guardarAsignaciones();

                    // Si las asignaciones fueron guardadas correctamente, llamar a enviarCambioEstado
                    if (asignacionesGuardadas) {
                        enviarCambioEstado(); // Llamamos a la función
                    }
                });

//Reasignar todo
                function guardarAsignaciones() {
                    // Variable para verificar si todos los selects están llenos
                    var todoSeleccionado = true;

                    // Recorremos cada fila de la tabla
                    $('#tablaSolicitudes tbody tr').each(function () {
                        // Obtener el valor de la primera columna (número de muestra)
                        var numeroMuestra = $(this).find('td').eq(0).text().trim(); // Primer columna de cada fila

                        // Obtener el valor seleccionado en el select de la misma fila
                        var analistaSeleccionado = $(this).find('td select').val(); // Valor del select en la fila actual

                        // Verificar si el select tiene un valor seleccionado (es requerido)
                        if (analistaSeleccionado === "") {
                            todoSeleccionado = false; // Si algún select está vacío, marcamos como no seleccionado
                            console.log('No se ha seleccionado un analista para el número de muestra: ' + numeroMuestra);
                        }
                    });

                    // Si algún select no está seleccionado, mostrar el mensaje de error y detener la ejecución
                    if (!todoSeleccionado) {
                        alert('Por favor, seleccione un analista para todas las solicitudes.');
                        return false; // Detenemos la ejecución de la función y devolvemos false
                    }

                    // Si todos los selects están seleccionados, continuar con la llamada AJAX
                    $('#tablaSolicitudes tbody tr').each(function () {
                        // Obtener el valor de la primera columna (número de muestra)
                        var numeroMuestra = $(this).find('td').eq(0).text().trim(); // Primer columna de cada fila

                        // Obtener el valor seleccionado en el select de la misma fila
                        var analistaSeleccionado = $(this).find('td select').val(); // Valor del select en la fila actual

                        // Llamada AJAX para enviar los datos al servlet
                        $.ajax({
                            url: '${pageContext.request.contextPath}/reasignarUsuario', // URL del servlet para asignar
                            type: 'POST',
                            data: {
                                idSolicitud: numeroMuestra,
                                usuarioNIT: analistaSeleccionado // Enviar el NIT del analista seleccionado
                            },
                            success: function (response) {
                                console.log('Asignación exitosa para el número de muestra: ' + numeroMuestra);
                            },
                            error: function (xhr, status, error) {
                                console.log('Error al asignar el analista para el número de muestra: ' + numeroMuestra);
                                console.log(xhr.responseText); // Ver detalles del error
                            }
                        });
                    });

                    // Si todo fue correctamente asignado, devolvemos true para que se ejecute la siguiente función
                    return true;
                }


                function limpiarFormulario() {
                    // Limpiar los inputs de texto
                    $('#modalCambiarEstado').find('input[type="text"], input[type="checkbox"], textarea').val('').prop('checked', false);

                    // Restablecer los valores de los selects a sus valores por defecto
                    $('#modalCambiarEstado').find('select').each(function () {
                        $(this).val($(this).find('option').first().val()); // Establecer al primer valor por defecto
                    });

                    // Limpiar las filas de la tabla, si existen
                    $('#modalCambiarEstado').find('#tablaSolicitudes tbody').empty();
                    
                    $('#modalCambiarEstado').modal('hide');
                    $('#modalReasignar').show();
                    $('#tablaReasignar').hide();

                    
                }

                $('#cancelarModal').click(function () {
                    limpiarFormulario();
                });

            });
        </script>
        <script>
            $(document).ready(function () {
                // Filtros de búsqueda
                $("#filtroNIT, #filtroNombre, #filtroRol, #filtroActor, #filtroEstado, #filtroCargoTrabajo").on("keyup", function () {
                    // Obtén los valores de los filtros
                    var nitFiltro = $("#filtroNIT").val().toLowerCase();
                    var nombreFiltro = $("#filtroNombre").val().toLowerCase();
                    var rolFiltro = $("#filtroRol").val().toLowerCase();
                    var actorFiltro = $("#filtroActor").val().toLowerCase();
                    var estadoFiltro = $("#filtroEstado").val().toLowerCase();
                    var cargaFiltro = $("#filtroCargoTrabajo").val().toLowerCase();

                    // Iterar sobre cada fila de la tabla
                    $("#tablaUsuarios tbody tr").filter(function () {
                        $(this).toggle(
                                $(this).find("td:eq(0)").text().toLowerCase().indexOf(nitFiltro) > -1 &&
                                $(this).find("td:eq(1)").text().toLowerCase().indexOf(nombreFiltro) > -1 &&
                                $(this).find("td:eq(2)").text().toLowerCase().indexOf(rolFiltro) > -1 &&
                                $(this).find("td:eq(3)").text().toLowerCase().indexOf(actorFiltro) > -1 &&
                                $(this).find("td:eq(4)").text().toLowerCase().indexOf(estadoFiltro) > -1 &&
                                $(this).find("td:eq(5)").text().toLowerCase().indexOf(cargaFiltro) > -1
                                );
                    });
                });
            });
        </script>


    </head>
    <body>

        <div class="container mt-4">

            <!-- Div principal que contiene la tabla y el botón "Agregar Usuario" -->
            <div id="main-content">

                <!-- Tabla de datos -->
                <div id="tabla-muestras">
                    <h3>Muestras Registradas</h3>
                    <table class="table table-bordered" id="tablaUsuarios">
                        <thead>
                            <tr>
                                <th>NIT</th>
                                <th>Nombre</th>
                                <th>Rol</th>
                                <th>Actor</th>
                                <th>Estado</th>
                                <th>Carga de Trabajo</th>
                            </tr>
                            <tr>
                                <!-- Campos para los filtros -->
                                <th><input type="text" id="filtroNIT" placeholder="Buscar por NIT"></th>
                                <th><input type="text" id="filtroNombre" placeholder="Buscar por Nombre"></th>
                                <th><input type="text" id="filtroRol" placeholder="Buscar por Rol"></th>
                                <th><input type="text" id="filtroActor" placeholder="Buscar por Actor"></th>
                                <th><input type="text" id="filtroEstado" placeholder="Buscar por Estado"></th>
                                <th><input type="text" id="filtroCargoTrabajo" placeholder="Buscar por Carga"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Aquí se cargarán dinámicamente los usuarios -->
                        </tbody>
                    </table>
                </div>

                <!-- Botón para agregar un nuevo usuario -->
                <div class="text-right">
                    <button id="agregarUsuario" class="btn btn-success">Agregar Usuario</button>
                </div>
            </div>

            <!-- Formulario de agregar usuario (oculto inicialmente) -->
            <div id="formulario-usuario" class="mt-4" style="display: none;">
                <h3>Agregar Usuario</h3>
                <div class="form-group">
                    <label for="loginu">Login Usuario:</label>
                    <input type="text" id="loginu" class="form-control" placeholder="Ingrese login de usuario">
                </div>
                <div class="form-group">
                    <label for="nitu">Nit Usuario:</label>
                    <input type="text" id="nitubuscar" class="form-control" placeholder="Ingrese nit de usuario">
                </div>
                <div class="form-group">
                    <label for="nombreg">Nombre Completo:</label>
                    <input type="text" id="nombreg" class="form-control" readonly>
                </div>
                <div class="form-group">
                    <label for="nitg">Nit:</label>
                    <input type="text" id="nitg" class="form-control" readonly>
                </div>
                <div class="form-group">
                    <label for="loging">Login:</label>
                    <input type="text" id="loging" class="form-control" readonly>
                </div>
                <div class="form-group">
                    <label for="rolg">Rol:</label>
                    <input type="text" id="rolg" class="form-control" readonly>
                </div>
                <!-- Botón para cancelar -->
                <button id="volver" class="btn btn-danger">Cancelar</button>
                <!-- Botón para buscar usuario -->
                <button id="buscaru" class="btn btn-primary">Buscar</button>
                <!-- Botón para guardar usuario -->
                <button id="guardaru" class="btn btn-primary">Guardar</button>
            </div>



            <!-- Modal para cambiar estado -->
            <div class="modal fade" id="modalCambiarEstado" tabindex="-1" role="dialog" aria-labelledby="modalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div id="modalReasignar">
                            <div class="modal-header">
                                <h5 class="modal-title" id="modalLabel">Cambiar Estado de la Muestra</h5>
                            </div>
                            <div class="modal-body">
                                <form id="form-cambiar-estado">
                                    <div class="form-group">
                                        <label for="nit">Nit</label>
                                        <input type="text" id="nitEstado" class="form-control" readonly>
                                    </div>
                                    <div class="form-group">
                                        <label for="nombre">Nombre</label>
                                        <input type="text" id="nombreEstado" class="form-control" readonly>
                                    </div>
                                    <div class="form-group">
                                        <label for="nuevoEstado">Nuevo Estado</label>
                                        <select id="nuevoEstado" class="form-control">
                                            <option value="true">Activo</option>
                                            <option value="false">Inactivo</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="comentario">Comentario:</label>
                                        <textarea id="comentario" class="form-control" rows="4" style="resize: none;" placeholder="Escribe tu comentario aquí" required=""></textarea>
                                    </div>
                                    <div class="form-group">
                                        <label for="solicutedesr">Reasignar Solicitudes</label>
                                        <input type="checkbox" id="reasignar" name="reasignar" > 
                                    </div>
                                    <button type="submit" class="btn btn-primary">Guardar Cambios</button>
                                </form>
                            </div>
                        </div>
                        <div id="tablaReasignar" style="display:none;">
                            <table class="table table-bordered" id="tablaSolicitudes">
                                <thead>
                                    <tr>
                                        <th>Número Muestra</th>
                                        <th>Estado Solicitud</th>
                                        <th>Estado Muestra</th>
                                        <th>reasignar</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Las filas de la tabla se llenarán con JavaScript -->
                                </tbody>
                            </table>
                            <button class="btn btn-primary" id="btnCambiarEstadoRe">Guardar</button>

                        </div>
                        <button class="btn btn-primary" id="cancelarModal">Cancelar</button>

                    </div>
                </div>
            </div>


            <script>
                // Usar EL para asignar el valor de la sesión a una variable de JavaScript
                const loginUsuario = "${sessionScope.usuario}";  // Debería tener el valor del login del usuario

                // Asegúrate de que el valor se haya asignado correctamente
                console.log("Login del usuario desde la sesión: " + loginUsuario);
            </script>

            <!-- Bootstrap JS y Popper.js para el modal -->
            <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    </body>
</html>