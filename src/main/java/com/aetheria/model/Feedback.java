package com.aetheria.model;

public class Feedback {
    private int id;
    private int userId;
    private int ratingStars;
    private int easeOfUse;
    private int calmnessLevel;
    private int uiQuality;
    private String reviewText;

    public Feedback() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getRatingStars() { return ratingStars; }
    public void setRatingStars(int ratingStars) { this.ratingStars = ratingStars; }

    public int getEaseOfUse() { return easeOfUse; }
    public void setEaseOfUse(int easeOfUse) { this.easeOfUse = easeOfUse; }

    public int getCalmnessLevel() { return calmnessLevel; }
    public void setCalmnessLevel(int calmnessLevel) { this.calmnessLevel = calmnessLevel; }

    public int getUiQuality() { return uiQuality; }
    public void setUiQuality(int uiQuality) { this.uiQuality = uiQuality; }

    public String getReviewText() { return reviewText; }
    public void setReviewText(String reviewText) { this.reviewText = reviewText; }
}
