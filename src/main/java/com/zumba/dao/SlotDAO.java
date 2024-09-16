package com.zumba.dao;

import com.zumba.dbUtil.dbUtil;
import com.zumba.pojo.Slot;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class SlotDAO {

    // Method to fetch all slots from the database and return them as a list of Slot objects
    public List<Slot> getAllSlots() {
        List<Slot> slots = new ArrayList<>();
        String query = "SELECT * FROM zumba_slots";

        try (Connection conn = dbUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            // Iterate through the result set and populate Slot objects
            while (rs.next()) {
                Slot slot = new Slot();
                slot.setId(rs.getInt("id"));
                slot.setSlotDate(rs.getDate("slot_date"));
                slot.setSlotTime(rs.getTime("slot_time"));
                slot.setMaxCapacity(rs.getInt("max_capacity"));
                slot.setAvailableSlots(rs.getInt("available_slots"));
                slots.add(slot);
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace(); 
        }

        return slots;
    }
}
