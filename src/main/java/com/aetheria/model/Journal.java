package com.aetheria.model;

import java.sql.Timestamp;

public class Journal {
    private int id;
    private int userId;
    private String entryText;
    private Timestamp createdAt;

    public Journal() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getEntryText() { return entryText; }
    public void setEntryText(String entryText) { this.entryText = entryText; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
