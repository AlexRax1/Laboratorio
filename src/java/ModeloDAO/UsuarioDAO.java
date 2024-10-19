/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ModeloDAO;

import Config.Conexion;
import Modelo.EntidadGuardada;
import Modelo.Persona;
import Modelo.Usuario;
import Modelo.UsuarioG;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author alex1
 */
public class UsuarioDAO {

    private final Conexion cn = new Conexion();

    // Método para validar el login
    public boolean validar(Usuario usuario) {
        String sql = "SELECT id_rol, actor FROM Usuario WHERE login = ? AND password = ?";
        try (Connection con = cn.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, usuario.getLogin());
            ps.setString(2, usuario.getPassword());
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                usuario.setRol(rs.getInt("id_rol")); // Asigna el rol al objeto usuario
                usuario.setActor(rs.getString("actor"));
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Imprime cualquier error
        }
        return false; // Usuario o contraseña incorrectos
    }

    // Método para obtener todos los usuarios
    public List<Usuario> obtenerUsuarios() {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT nit,nombre, rol_nombre, actor,estado, carga_trabajo FROM Usuario"; // Ajusta el nombre de la tabla y las columnas según tu base de datos

        try (Connection connection = cn.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()) {

            // Iterar sobre el resultado
            while (resultSet.next()) {
                Usuario usuario = new Usuario();
                usuario.setNit(resultSet.getString("nit"));
                usuario.setNombre(resultSet.getString("nombre"));
                usuario.setRolNombre(resultSet.getString("rol_nombre"));
                usuario.setActor(resultSet.getString("actor"));
                usuario.setEstado(resultSet.getBoolean("estado"));
                usuario.setCargoTrabajo(resultSet.getInt("carga_trabajo")); // Cambia esto según tu clase Usuario

                usuarios.add(usuario);
            }
        } catch (SQLException e) {

            e.printStackTrace(); // Manejo de errores
        }

        return usuarios;
    }

    public boolean cambiarEstado(String nit, boolean nuevoEstado) {
        String sql = "UPDATE Usuario SET estado = ? WHERE nit = ?";
        try (Connection con = cn.getConnection();
                PreparedStatement preparedStatement = con.prepareStatement(sql)) {

            preparedStatement.setBoolean(1, nuevoEstado);
            preparedStatement.setString(2, nit);

            int filasActualizadas = preparedStatement.executeUpdate();
            return filasActualizadas > 0; // Retorna true si se actualizó al menos un registro
        } catch (SQLException e) {
            e.printStackTrace();
            return false; // Retorna false en caso de error
        }
    }

    public UsuarioG obtenerPorNit(String nit, String login) {
        String query = "SELECT * FROM listaUsuarios WHERE nit = ? OR login = ?";
        try (Connection con = cn.getConnection(); // Obtener la conexión a la base de datos
                PreparedStatement preparedStatement = con.prepareStatement(query)) {

            preparedStatement.setString(1, nit);
            preparedStatement.setString(2, login);  // Cambiado el índice a 2
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                UsuarioG usuario = new UsuarioG();  // Mueve la creación del objeto aquí
                usuario.setLogin(resultSet.getString("login"));  // Asigna los valores al objeto Usuario
                usuario.setNit(resultSet.getString("nit"));
                usuario.setNombre(resultSet.getString("nombre"));
                usuario.setActor(resultSet.getString("actor"));
                usuario.setPuesto(resultSet.getString("puesto"));
                usuario.setPassword(resultSet.getString("password"));
                return usuario;  // Devuelve el usuario con sus valores asignados
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Manejo de errores
        }
        return null; // Si no se encuentra el NIT, devuelve null
    }

    public boolean agregarUsuario(String nit, String login, String nombre, boolean estado, int id_rol, String rol_nombre, String actor, String password) {
        String query = "INSERT INTO Usuario (login, nit, nombre, estado, id_rol, rol_nombre, actor, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = cn.getConnection(); // Obtener la conexión a la base de datos
                PreparedStatement preparedStatement = con.prepareStatement(query)) {

            preparedStatement.setString(1, login);
            preparedStatement.setString(2, nit);
            preparedStatement.setString(3, nombre);
            preparedStatement.setBoolean(4, estado);
            preparedStatement.setInt(5, id_rol);
            preparedStatement.setString(6, rol_nombre);
            preparedStatement.setString(7, actor);
            preparedStatement.setString(8, password);

            int rowsAffected = preparedStatement.executeUpdate(); // Ejecuta la inserción
            return rowsAffected > 0; // Retorna true si se insertó correctamente
        } catch (SQLException e) {
            e.printStackTrace(); // Manejo de errores
        }
        return false; // Si hubo un error o no se insertó, retorna false
    }

}
