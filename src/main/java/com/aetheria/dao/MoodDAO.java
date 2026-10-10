package com.aetheria.dao;

import com.aetheria.util.DBConnection;

import java.sql.*;

/**
 * Powers the "Burnout Mode" floating conversational widget.
 * Pure rule-based logic: counts how many times a mood was logged
 * in the last 7 days. No AI/API involved.
 */
public class MoodDAO {

    public boolean logMood(int userId, String moodTag) {
        String sql = "INSERT INTO mood_logs (user_id, mood_tag) VALUES (?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, moodTag);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Returns how many times this mood was logged by the user in the last 7 days
    public int countRecentMood(int userId, String moodTag) {
        String sql = "SELECT COUNT(*) AS cnt FROM mood_logs WHERE user_id = ? AND mood_tag = ? " +
                "AND logged_at >= (NOW() - INTERVAL 7 DAY)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, moodTag);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("cnt");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
