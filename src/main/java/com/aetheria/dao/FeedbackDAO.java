package com.aetheria.dao;

import com.aetheria.model.Feedback;
import com.aetheria.util.DBConnection;

import java.sql.*;

public class FeedbackDAO {

    public boolean submit(Feedback fb) {
        String sql = "INSERT INTO feedback (user_id, rating_stars, ease_of_use, calmness_level, ui_quality, review_text) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, fb.getUserId());
            ps.setInt(2, fb.getRatingStars());
            ps.setInt(3, fb.getEaseOfUse());
            ps.setInt(4, fb.getCalmnessLevel());
            ps.setInt(5, fb.getUiQuality());
            ps.setString(6, fb.getReviewText());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
