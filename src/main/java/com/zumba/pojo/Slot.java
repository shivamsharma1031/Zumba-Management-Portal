package com.zumba.pojo;

import java.sql.Date;
import java.sql.Time;

public class Slot {
    private int id;
    private Date slotDate;
    private Time slotTime;
    private int maxCapacity;
    private int availableSlots;

    // Constructor
    public Slot() {
    }

    public Slot(int id, Date slotDate, Time slotTime, int maxCapacity, int availableSlots) {
        this.id = id;
        this.slotDate = slotDate;
        this.slotTime = slotTime;
        this.maxCapacity = maxCapacity;
        this.availableSlots = availableSlots;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getSlotDate() {
        return slotDate;
    }

    public void setSlotDate(Date slotDate) {
        this.slotDate = slotDate;
    }

    public Time getSlotTime() {
        return slotTime;
    }

    public void setSlotTime(Time slotTime) {
        this.slotTime = slotTime;
    }

    public int getMaxCapacity() {
        return maxCapacity;
    }

    public void setMaxCapacity(int maxCapacity) {
        this.maxCapacity = maxCapacity;
    }

    public int getAvailableSlots() {
        return availableSlots;
    }

    public void setAvailableSlots(int availableSlots) {
        this.availableSlots = availableSlots;
    }

    // Optional: Override toString method for debugging purposes
    @Override
    public String toString() {
        return "Slot{" +
                "id=" + id +
                ", slotDate=" + slotDate +
                ", slotTime=" + slotTime +
                ", maxCapacity=" + maxCapacity +
                ", availableSlots=" + availableSlots +
                '}';
    }
}
