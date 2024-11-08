/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo;

import static com.sun.org.apache.xalan.internal.lib.ExsltDatetime.date;
import java.sql.Date;

/**
 *
 * @author alex1
 */
public class Documentos {
    private String idSolicitud;
    private String etiquetaMuestra;
    private String etiquetaPorcion;
    private String certificadoEnsayo;
    private String opinionTecnica;
    private String informe;
    private String providencia;
    private String docAnalisis;
    private Date fechaInicio;
    private Date fechaFin;

    public Documentos() {
    }

    public String getIdSolicitud() {
        return idSolicitud;
    }

    public void setIdSolicitud(String idSolicitud) {
        this.idSolicitud = idSolicitud;
    }

    public String getEtiquetaMuestra() {
        return etiquetaMuestra;
    }

    public void setEtiquetaMuestra(String etiquetaMuestra) {
        this.etiquetaMuestra = etiquetaMuestra;
    }

    public String getEtiquetaPorcion() {
        return etiquetaPorcion;
    }

    public void setEtiquetaPorcion(String etiquetaPorcion) {
        this.etiquetaPorcion = etiquetaPorcion;
    }

    public String getCertificadoEnsayo() {
        return certificadoEnsayo;
    }

    public void setCertificadoEnsayo(String certificadoEnsayo) {
        this.certificadoEnsayo = certificadoEnsayo;
    }

    public String getOpinionTecnica() {
        return opinionTecnica;
    }

    public void setOpinionTecnica(String opinionTecnica) {
        this.opinionTecnica = opinionTecnica;
    }

    public String getInforme() {
        return informe;
    }

    public void setInforme(String informe) {
        this.informe = informe;
    }

    public String getProvidencia() {
        return providencia;
    }

    public void setProvidencia(String providencia) {
        this.providencia = providencia;
    }

    public String getDocAnalisis() {
        return docAnalisis;
    }

    public void setDocAnalisis(String docAnalisis) {
        this.docAnalisis = docAnalisis;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public Date getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(Date fechaFin) {
        this.fechaFin = fechaFin;
    }

    
    
}
