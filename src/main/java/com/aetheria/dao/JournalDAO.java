package com.aetheria.dao;

import com.aetheria.model.Journal;
import com.aetheria.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JournalDAO {

    public boolean addEntry(int userId, String entryText) {
        String sql = "INSERT INTO journal_entries (user_id, entry_text) VALUES (?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, entryText);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Journal> getLast7Days(int userId) {
        List<Journal> list = new ArrayList<>();
        String sql = "SELECT * FROM journal_entries WHERE user_id = ? AND created_at >= (NOW() - INTERVAL 7 DAY) ORDER BY created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Journal j = new Journal();
                    j.setId(rs.getInt("id"));
                    j.setUserId(rs.getInt("user_id"));
                    j.setEntryText(rs.getString("entry_text"));
                    j.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(j);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
