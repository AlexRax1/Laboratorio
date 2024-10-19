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
                    var nit = $(this).data('id'); // Obtener el NIT
                    var nombre = $(this).closest('tr').find('td:eq(1)').text(); // Obtener el nombre de la segunda celda
                    $('#nitEstado').val(nit);
                    $('#nombreEstado').val(nombre);

                    $('#modalCambiarEstado').modal('show');
                });
                // guardar nuevo estado
                $('#form-cambiar-estado').on('submit', function (e) {
                    e.preventDefault();

                    var nit = $('#nitEstado').val();
                    var nuevoEstado = $('#nuevoEstado').val();
                    $.ajax({
                        url: '${pageContext.request.contextPath}/cambiarEstado',
                        type: 'POST',
                        data: {
                            nit: nit,
                            nuevoEstado: nuevoEstado
                        },
                        success: function () {
                            alert("cambio realizado con exito");
                            $('#modalCambiarEstado').modal('hide');
                            location.reload();
                        },
                        error: function () {
                            alert('Error al cambiar el estado');
                        }
                    });
                });

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
                        },
                        error: function () {
                            alert('no se pudo agregar');
                        }
                    });
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
                </div>
            </div>

            <!-- Bootstrap JS y Popper.js para el modal -->
            <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    </body>
</html>