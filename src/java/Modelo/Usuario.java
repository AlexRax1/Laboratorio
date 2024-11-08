/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo;

/**
 *
 * @author alex1
 */
public class Usuario {
    String login;
    String nit;
    String nombre;
    boolean estado;
    int rol;
    String rolNombre;
    String actor;
    int cargoTrabajo;
    String password;
    String correo;

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public Usuario() {
    }

    public Usuario(String login, String nit, String nombre, boolean estado, int rol, String rolNombre, String actor, int cargoTrabajo, String password) {
        this.login = login;
        this.nit = nit;
        this.nombre = nombre;
        this.estado = estado;
        this.rol = rol;
        this.rolNombre = rolNombre;
        this.actor = actor;
        this.cargoTrabajo = cargoTrabajo;
        this.password = password;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public String getNit() {
        return nit;
    }

    public void setNit(String nit) {
        this.nit = nit;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public boolean isEstado() {
        return estado;
    }

    public void setEstado(boolean estado) {
        this.estado = estado;
    }

    public int getRol() {
        return rol;
    }

    public void setRol(int rol) {
        this.rol = rol;
    }

    public String getRolNombre() {
        return rolNombre;
    }

    public void setRolNombre(String rolNombre) {
        this.rolNombre = rolNombre;
    }

    public String getActor() {
        return actor;
    }

    public void setActor(String actor) {
        this.actor = actor;
    }

    public int getCargoTrabajo() {
        return cargoTrabajo;
    }

    public void setCargoTrabajo(int cargoTrabajo) {
        this.cargoTrabajo = cargoTrabajo;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    
    
}
