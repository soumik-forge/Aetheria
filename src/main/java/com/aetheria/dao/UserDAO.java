package com.aetheria.dao;

import com.aetheria.model.User;
import com.aetheria.util.DBConnection;

import java.sql.*;

/**
 * Handles user registration and the custom name@birthyear auth scheme.
 * NOTE: For a real production app, passwords must be hashed (e.g. BCrypt).
 * Here password_hash simply stores the birth year, per the project's
 * intentionally simple ID/password scheme (documented in README).
 */
public class UserDAO {

    public boolean register(String username, int birthYear, Integer age, Double heightCm, Double weightKg) {
        String userIdStr = username + "@" + birthYear;
        String sql = "INSERT INTO users (username, user_id_str, birth_year, password_hash, age, height_cm, weight_kg) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, userIdStr);
            ps.setInt(3, birthYear);
            ps.setString(4, String.valueOf(birthYear)); // password = birth year
            if (age != null) ps.setInt(5, age); else ps.setNull(5, Types.INTEGER);
            if (heightCm != null) ps.setDouble(6, heightCm); else ps.setNull(6, Types.DECIMAL);
            if (weightKg != null) ps.setDouble(7, weightKg); else ps.setNull(7, Types.DECIMAL);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public User login(String userIdStr, String password) {
        String sql = "SELECT * FROM users WHERE user_id_str = ? AND password_hash = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, userIdStr);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateProfile(int userId, Integer age, Double heightCm, Double weightKg) {
        String sql = "UPDATE users SET age = ?, height_cm = ?, weight_kg = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (age != null) ps.setInt(1, age); else ps.setNull(1, Types.INTEGER);
            if (heightCm != null) ps.setDouble(2, heightCm); else ps.setNull(2, Types.DECIMAL);
            if (weightKg != null) ps.setDouble(3, weightKg); else ps.setNull(3, Types.DECIMAL);
            ps.setInt(4, userId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setUserIdStr(rs.getString("user_id_str"));
        u.setBirthYear(rs.getInt("birth_year"));
        u.setPasswordHash(rs.getString("password_hash"));
        Object ageObj = rs.getObject("age");
        u.setAge(ageObj instanceof Number ? ((Number) ageObj).intValue() : null);
        Object heightObj = rs.getObject("height_cm");
        u.setHeightCm(heightObj instanceof Number ? ((Number) heightObj).doubleValue() : null);
        Object weightObj = rs.getObject("weight_kg");
        u.setWeightKg(weightObj instanceof Number ? ((Number) weightObj).doubleValue() : null);
        try {
            u.setAvatarEmoji(rs.getString("avatar_emoji"));
        } catch (SQLException ignored) {}
        return u;
    }
}
