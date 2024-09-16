package com.zumba.pojo;

public class Participant {
    private int id;
    private String name;
    private String email;
    private String phone;
    private double weight;
    private double height;
    private boolean isAdmin; 

    // Constructors
    public Participant() {}

    public Participant(int id, String name, String email, String phone, double weight, double height, boolean isAdmin) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.weight = weight;
        this.height = height;
        this.isAdmin = isAdmin;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    public double getHeight() {
        return height;
    }

    public void setHeight(double height) {
        this.height = height;
    }

    public boolean isAdmin() {
        return isAdmin;
    }

    public void setAdmin(boolean isAdmin) {
        this.isAdmin = isAdmin;
    }
}
