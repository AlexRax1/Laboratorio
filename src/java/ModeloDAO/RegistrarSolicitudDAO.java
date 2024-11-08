/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ModeloDAO;

import Config.Conexion;
import Modelo.Solicitud;
import Modelo.UsuarioG;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfDocument;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import java.awt.Desktop;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 *
 * @author alex1
 */
public class RegistrarSolicitudDAO {

    private final Conexion cn = new Conexion();

    public boolean guardarSolicitud(Solicitud solicitud) throws MessagingException {
        Connection connection = null;
        try {
            // Generar el ID de solicitud
            String idSolicitud = generarIdSolicitud(solicitud.getTipoSolicitud());
            solicitud.setIdSolicitud(idSolicitud);
            solicitud.setRolUsuario("AnalistadeLaboratorio");
            solicitud.setEstadoMuestra("RE-Registrada");
            solicitud.setEstadoSolicitud("Asignada Analista Laboratorio");

            // Guardar la solicitud en la base de datos
            String insertQuery = "INSERT INTO SolicitudMuestraAnalisis (id_solicitud, tipo_solicitud, tipo_entidad, "
                    + "tipo_doc, numero_doc, nit_proveedor, nombre_proveedor, "
                    + "correo_proveedor, direccion_proveedor, telefono_proveedor, nit_solicitante, "
                    + "nombreSolicitante, correo_solicitante, numero_muestra, descripcion, "
                    + "estado_solicitud, estado_muestra, usuario_asignado, rol_usuario) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            connection = cn.getConnection();
            connection.setAutoCommit(false); // Desactivar autocommit

            try (PreparedStatement pstmt = connection.prepareStatement(insertQuery)) {
                pstmt.setString(1, solicitud.getIdSolicitud());
                pstmt.setString(2, solicitud.getTipoSolicitud());
                pstmt.setString(3, solicitud.getTipoEntidad());
                pstmt.setString(4, solicitud.getTipoDoc());
                pstmt.setString(5, solicitud.getNumeroDoc());
                pstmt.setString(6, solicitud.getNitProveedor());
                pstmt.setString(7, solicitud.getNombreProveedor());
                pstmt.setString(8, solicitud.getCorreoProveedor());
                pstmt.setString(9, solicitud.getDireccionProveedor());
                pstmt.setString(10, solicitud.getTelefonoProveedor());
                pstmt.setString(11, solicitud.getNitSolicitante());
                pstmt.setString(12, solicitud.getNombreSolicitante());
                pstmt.setString(13, solicitud.getCorreoSolicitante());
                pstmt.setString(14, solicitud.getNumeroMuestra());
                pstmt.setString(15, solicitud.getDescripcion());
                pstmt.setString(16, solicitud.getEstadoSolicitud());
                pstmt.setString(17, solicitud.getEstadoMuestra());
                pstmt.setString(18, solicitud.getUsuarioAsignado());
                pstmt.setString(19, solicitud.getRolUsuario());

                // Ejecutar la inserción
                pstmt.executeUpdate();
                connection.commit(); // Confirmar la transacción

                //crea la etiqueta, la guarda y la museta
                String ruta = crearEtiqueta(idSolicitud, solicitud.getNombreProveedor(), solicitud.getNitProveedor(), solicitud.getNumeroDoc(), solicitud.getUsuarioAsignado());
                guardarDoc(idSolicitud, ruta);
                abrirPDF(ruta);

                //enviar correos
                enviarCorreoSolicitante(solicitud.getCorreoProveedor(), solicitud.getCorreoSolicitante(), solicitud.getTipoSolicitud(), idSolicitud, solicitud.getTipoDoc(), solicitud.getNumeroDoc());
                enviarCorreoAnalista(solicitud.getUsuarioAsignado(), solicitud.getTipoSolicitud(), idSolicitud, solicitud.getTipoDoc(), solicitud.getNumeroDoc());
                return true; // Indicar que la inserción fue exitosa
            }
        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback(); // Revertir cambios en caso de error
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            e.printStackTrace(); // Manejo simple de excepciones
            return false; // Indicar que hubo un error
        } finally {
            if (connection != null) {
                try {
                    connection.close(); // Cerrar conexión
                } catch (SQLException closeEx) {
                    closeEx.printStackTrace();
                }
            }
        }
    }

    public int obtenerCorrelativo(String tipo, int ano) throws SQLException {
        String query = "SELECT COALESCE(MAX(correlativo), 0) FROM id_solicitudes WHERE tipo = ? AND ano = ?";

        try (Connection connection = cn.getConnection();
                PreparedStatement pstmt = connection.prepareStatement(query)) {

            pstmt.setString(1, tipo);
            pstmt.setInt(2, ano);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) + 1; // Se obtiene el máximo correlativo y se suma 1
            } else {
                return 1; // Si no hay registros, el correlativo comienza en 1
            }
        }
    }

    public String generarIdSolicitud(String tipo) throws SQLException {
        int ano = obtenerAnoActual();
        int correlativo = obtenerCorrelativo(tipo, ano);

        String insertQuery = "INSERT INTO id_solicitudes (tipo, correlativo, ano) VALUES (?, ?, ?)";

        try (Connection connection = cn.getConnection();
                PreparedStatement pstmt = connection.prepareStatement(insertQuery)) {

            pstmt.setString(1, tipo);
            pstmt.setInt(2, correlativo);
            pstmt.setInt(3, ano);
            pstmt.executeUpdate();
        }

        // Generar el ID de solicitud con el formato especificado
        return tipo + "-" + correlativo + "-" + ano;
    }

    public int obtenerAnoActual() {
        return LocalDate.now().getYear();
    }

    public String crearEtiqueta(String idSolicitud, String nombreProveedor, String nitProveedor, String numExpediente, String nitAnalista) {
        String nombreArchivo = "Etiqueta_" + idSolicitud + ".pdf";
        String rutaCarpeta = "pdfsEtiqueta/"; // Cambia esta ruta según tus necesidades
        String rutaArchivo = rutaCarpeta + nombreArchivo;

        // Crear la carpeta si no existe
        File carpeta = new File(rutaCarpeta);
        if (!carpeta.exists()) {
            carpeta.mkdirs(); // Crear la carpeta
        }

        // Crea el documento PDF
        Document document = new Document();
        try {
            UsuarioDAO usu = new UsuarioDAO();
            String nombreAnalista = usu.obtenerPorNit(nitAnalista, " ").getNombre();

            // Usa FileOutputStream para especificar la ruta donde se guardará el PDF
            PdfWriter.getInstance(document, new FileOutputStream(rutaArchivo));

            // Abre el documento para escribir
            document.open();

            // Crea una tabla con 2 columnas
            PdfPTable table = new PdfPTable(2); // Define 2 columnas

            // Agrega el título en la primera celda
            table.addCell("LABORATORIO DE INSPECCIÓN DE CALIDAD ALIMENTOS 'QUE RIQUITO ESTÁ'");

            // Concatenar los datos
            String datos = "ID Solicitud: " + idSolicitud + "\n"
                    + "Nombre Proveedor: " + nombreProveedor + "\n"
                    + "NIT Proveedor: " + nitProveedor + "\n"
                    + "Número de Expediente: " + numExpediente + "\n"
                    + "Nombre del Analista: " + nombreAnalista;

            // Agrega los datos en la segunda celda
            table.addCell(datos);

            // Añade la tabla al documento
            document.add(table);

            // Retorna la ruta donde se guardó el documento
            return new File(rutaArchivo).getAbsolutePath();

        } catch (DocumentException | IOException e) {
            e.printStackTrace(); // Manejo de errores
        } finally {
            document.close(); // Asegúrate de cerrar el documento
            // Imprime la ruta donde se guardó el documento
            System.out.println("PDF creado en: " + new File(rutaArchivo).getAbsolutePath());
        }

        return null;
    }

    public void guardarDoc(String idSolicitud, String ruta) throws SQLException {
        String insertQuery = "INSERT INTO documentos (id_solicitud, etiqueta_muestra) VALUES (?, ?)";

        try (Connection connection = cn.getConnection();
                PreparedStatement pstmt = connection.prepareStatement(insertQuery)) {
            if (idSolicitud == null || idSolicitud.isEmpty() || ruta == null || ruta.isEmpty()) {
                throw new IllegalArgumentException("idSolicitud y ruta no pueden ser nulos o vacíos");
            }
            pstmt.setString(1, idSolicitud);
            pstmt.setString(2, ruta);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            // Manejo de la excepción SQL
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            // Manejo de la excepción de argumentos inválidos
            e.printStackTrace();
        }
    }

    private void enviarCorreoSolicitante(String destinatario, String destinatario2, String tipoSolicitud, String idSolicitud, String tipoDoc, String numeroDoc) throws MessagingException {
        // Configuración de las propiedades del correo
        Properties propiedades = new Properties();
        propiedades.put("mail.smtp.auth", "true");
        propiedades.put("mail.smtp.starttls.enable", "true");
        propiedades.put("mail.smtp.host", "smtp.gmail.com"); // Cambia según tu proveedor
        propiedades.put("mail.smtp.port", "587"); // Puerto SMTP de Gmail

        final String usuario = "alex1234raxon@gmail.com";
        final String contraseña = "krwz zskr fpcm cuwy";

        // Crear una sesión con autenticación
        Session session = Session.getInstance(propiedades, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(usuario, contraseña);
            }
        });

        // Crear el mensaje
        String mensaje = "Se le informa que la solicitud de Muestras para la gestión de "
                + tipoSolicitud + "  , Número de Muestra “" + idSolicitud + "” fue registrada, "
                + "Tipo Documento: “" + tipoDoc + "”, Numero Documento: “  " + numeroDoc + ", se envía este aviso para seguimiento."
                + "\n\n** Esta es una correspondencia autogenerada por el Sistema Muestras. Por favor NO RESPONDA a este correo.";

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(usuario));

        // Manejo de destinatarios
        List<String> destinatarios = new ArrayList<>();
        if (destinatario != null && !destinatario.trim().isEmpty()) {
            destinatarios.add(destinatario);
        }
        if (destinatario2 != null && !destinatario2.trim().isEmpty()) {
            destinatarios.add(destinatario2);
        }

        // Solo agregar destinatarios si hay al menos uno válido
        if (!destinatarios.isEmpty()) {
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(String.join(",", destinatarios)));
        } else {
            throw new MessagingException("No hay destinatarios válidos para enviar el correo.");
        }

        message.setSubject("Muestra Generada");
        message.setText(mensaje);

        // Enviar el correo
        try {
            Transport.send(message);
            System.out.println("Correo enviado exitosamente.");
        } catch (MessagingException e) {
            e.printStackTrace();
            throw new MessagingException("Error al enviar el correo: " + e.getMessage());
        }
    }

    private void enviarCorreoAnalista(String usuarioAsignado, String tipoSolicitud, String idSolicitud,
            String tipoDoc, String numeroDoc) throws MessagingException {

        UsuarioDAO usuariodao = new UsuarioDAO();
        String destinatario = usuariodao.correoUsuario(usuarioAsignado);

        // Configuración de las propiedades del correo
        Properties propiedades = new Properties();
        propiedades.put("mail.smtp.auth", "true");
        propiedades.put("mail.smtp.starttls.enable", "true");
        propiedades.put("mail.smtp.host", "smtp.gmail.com"); // Cambia según tu proveedor
        propiedades.put("mail.smtp.port", "587"); // Puerto SMTP de Gmail

        final String usuario = "alex1234raxon@gmail.com";
        final String contraseña = "krwz zskr fpcm cuwy";

        // Crear una sesión con autenticación
        Session session = Session.getInstance(propiedades, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(usuario, contraseña);
            }
        });

        // Crear el mensaje
        String mensaje = "Se le informa que la solicitud de Muestras o porción de muestra para la gestión  "
                + tipoSolicitud + "  , Número de Muestra “" + idSolicitud + "” le fue asignada con éxito, "
                + "Tipo Documento: “" + tipoDoc + "”, Numero Documento: “  " + numeroDoc + ", se envía este aviso para seguimiento desde su bandeja."
                + ""
                + ""
                + "** Esta es una correspondencia autogenerada por el Sistema Muestras. Por favor NO RESPONDA a este correo.";

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(usuario));

        // Manejo de destinatarios
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));

        message.setSubject("Muestra para Analisis");
        message.setText(mensaje);

        // Enviar el correo
        Transport.send(message);
    }

    public void emailReasignacion(String idSolicitud) {
        // SQL query para obtener los datos necesarios para el correo
        String selectQuery = "SELECT usuario_asignado, tipo_solicitud, id_solicitud, tipo_doc, numero_doc "
                + "FROM SolicitudMuestraAnalisis WHERE id_solicitud = ?";

        try (Connection connection = cn.getConnection();
                PreparedStatement pstmt = connection.prepareStatement(selectQuery)) {

            // Establecer el parámetro de id_solicitud
            pstmt.setString(1, idSolicitud);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    // Extraer los datos necesarios de la consulta
                    String usuarioAsignado = rs.getString("usuario_asignado");
                    String tipoSolicitud = rs.getString("tipo_solicitud");
                    String tipoDoc = rs.getString("tipo_doc");
                    String numeroDoc = rs.getString("numero_doc");

                    // Llamar a la función enviarCorreoAnalista
                    enviarCorreoAnalista(usuarioAsignado, tipoSolicitud, idSolicitud, tipoDoc, numeroDoc);
                } else {
                    System.out.println("No se encontró la solicitud con id: " + idSolicitud);
                }
            }

        } catch (SQLException | MessagingException e) {
            e.printStackTrace();
            // Aquí puedes agregar manejo de errores o logs adicionales si es necesario
        }
    }

    public static void abrirPDF(String ruta) {
        try {
            File archivo = new File(ruta);
            if (archivo.exists()) {
                if (Desktop.isDesktopSupported()) {
                    Desktop.getDesktop().open(archivo);
                    System.out.println("PDF abierto correctamente.");
                } else {
                    System.out.println("No se soporta el acceso al escritorio en este sistema.");
                }
            } else {
                System.out.println("El archivo no existe en la ruta especificada.");
            }
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("Ocurrió un error al intentar abrir el PDF.");
        }
    }
}
