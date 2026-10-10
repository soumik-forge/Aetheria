package com.aetheria.dao;

import com.aetheria.model.CompletedSession;
import com.aetheria.model.Session;
import com.aetheria.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SessionDAO {

    public List<Session> getByMood(String moodTag) {
        List<Session> list = new ArrayList<>();
        String sql = "SELECT * FROM meditation_sessions WHERE mood_tag = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, moodTag);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Session> getAll() {
        List<Session> list = new ArrayList<>();
        String sql = "SELECT * FROM meditation_sessions ORDER BY mood_tag";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Logs a completed session -> powers streak tracker + weekly report
    public boolean logCompletion(int userId, Integer sessionId, int durationMinutes) {
        String sql = "INSERT INTO completed_sessions (user_id, session_id, duration_minutes) VALUES (?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (sessionId != null) ps.setInt(2, sessionId); else ps.setNull(2, Types.INTEGER);
            ps.setInt(3, durationMinutes);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Current consecutive-day streak for the user (used by the growing-garden tracker)
    public int getCurrentStreak(int userId) {
        String sql = "SELECT DISTINCT DATE(completed_at) AS d FROM completed_sessions WHERE user_id = ? ORDER BY d DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                int streak = 0;
                java.time.LocalDate expected = java.time.LocalDate.now();
                while (rs.next()) {
                    java.time.LocalDate d = rs.getDate("d").toLocalDate();
                    if (d.equals(expected)) {
                        streak++;
                        expected = expected.minusDays(1);
                    } else if (d.isBefore(expected)) {
                        break;
                    }
                }
                return streak;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<CompletedSession> getLast7Days(int userId) {
        List<CompletedSession> list = new ArrayList<>();
        String sql = "SELECT * FROM completed_sessions WHERE user_id = ? AND completed_at >= (NOW() - INTERVAL 7 DAY) ORDER BY completed_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CompletedSession c = new CompletedSession();
                    c.setId(rs.getInt("id"));
                    c.setUserId(rs.getInt("user_id"));
                    Object sidObj = rs.getObject("session_id");
                    c.setSessionId(sidObj instanceof Number ? ((Number) sidObj).intValue() : null);
                    c.setDurationMinutes(rs.getInt("duration_minutes"));
                    c.setCompletedAt(rs.getTimestamp("completed_at"));
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Session mapRow(ResultSet rs) throws SQLException {
        Session s = new Session();
        s.setId(rs.getInt("id"));
        s.setTitle(rs.getString("title"));
        s.setMoodTag(rs.getString("mood_tag"));
        s.setDurationMinutes(rs.getInt("duration_minutes"));
        s.setAudioUrl(rs.getString("audio_url"));
        s.setImageUrl(rs.getString("image_url"));
        s.setDescription(rs.getString("description"));
        return s;
    }
}
