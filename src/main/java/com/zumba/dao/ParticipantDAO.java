package com.zumba.dao;

import com.zumba.dbUtil.dbUtil;
import com.zumba.pojo.Participant;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ParticipantDAO {

    // Method to insert a participant into the database
    public boolean addParticipant(Participant participant) {
        // Insert query with 'false' for isAdmin field
        String query = "INSERT INTO users (name, phone, email, password, weight, height, isAdmin) VALUES (?, ?, ?, ?, ?, ?, false)";
        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, participant.getName());
            ps.setString(2, participant.getPhone());
            ps.setString(3, participant.getEmail());
            ps.setString(4, participant.getEmail()); 
            ps.setDouble(5, participant.getWeight());
            ps.setDouble(6, participant.getHeight());

            int result = ps.executeUpdate();
            return result > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace(); 
            return false;
        }
    }

    // Method to get a list of all participants
    public List<Participant> getAllParticipants() {
        List<Participant> participants = new ArrayList<>();
        String query = "SELECT * FROM users";

        try (Connection conn = dbUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                Participant participant = new Participant(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getDouble("weight"),
                        rs.getDouble("height"),
                        rs.getBoolean("isAdmin") 
                );
                participants.add(participant);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace(); 
        }

        return participants;
    }

    // Method to check if a participant is registered for a given slot
    public boolean isRegistered(int userId, int slotId) {
        String query = "SELECT COUNT(*) FROM zumba_registrations WHERE user_id = ? AND slot_id = ?";

        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, userId);
            ps.setInt(2, slotId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return true; // User is registered for the slot
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace(); 
        }

        return false; // User is not registered for the slot
    }
    
    public List<Participant> getParticipantsBySlotId(int slotId) {
        List<Participant> participants = new ArrayList<>();
        String query = "SELECT u.id, u.name, u.email, u.phone, u.weight, u.height, u.isAdmin " +
                       "FROM zumba_registrations r " +
                       "JOIN users u ON r.user_id = u.id " +
                       "WHERE r.slot_id = ?";

        try (Connection conn = dbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, slotId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Participant participant = new Participant(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getDouble("weight"),
                            rs.getDouble("height"),
                            rs.getBoolean("isAdmin")
                    );
                    participants.add(participant);
                }
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return participants;
    }
}
