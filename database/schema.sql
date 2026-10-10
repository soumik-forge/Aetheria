-- ============================================================
-- Aetheria - Online Meditation and Mindfulness Platform
-- Database Schema
-- ============================================================

CREATE DATABASE IF NOT EXISTS aetheria_db;
USE aetheria_db;

-- Users: ID format name@birthyear, password = birthyear
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    user_id_str VARCHAR(120) NOT NULL UNIQUE,  -- e.g. Soumik@2007
    birth_year INT NOT NULL,
    password_hash VARCHAR(255) NOT NULL,       -- stored as the birth year (demo-level, see README)
    age INT,
    height_cm DECIMAL(5,2),
    weight_kg DECIMAL(5,2),
    avatar_emoji VARCHAR(32) DEFAULT '🌱',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Meditation session catalog
CREATE TABLE meditation_sessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    mood_tag ENUM('OVERWHELMED','CANT_SLEEP','LOW_ENERGY','UNFOCUSED','GENERAL','RECOVERY') NOT NULL,
    duration_minutes INT NOT NULL,
    audio_url VARCHAR(255),
    image_url VARCHAR(255),
    description TEXT
);

-- Mood / session-start logs (powers the Burnout Detector + streaks)
CREATE TABLE mood_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    mood_tag ENUM('OVERWHELMED','CANT_SLEEP','LOW_ENERGY','UNFOCUSED') NOT NULL,
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Completed sessions (powers the streak tracker + weekly report)
CREATE TABLE completed_sessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    session_id INT,
    duration_minutes INT NOT NULL,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (session_id) REFERENCES meditation_sessions(id) ON DELETE SET NULL
);

-- Micro-journal entries
CREATE TABLE journal_entries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    entry_text VARCHAR(500) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Feedback / ratings
CREATE TABLE feedback (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    rating_stars INT NOT NULL CHECK (rating_stars BETWEEN 1 AND 5),
    ease_of_use INT CHECK (ease_of_use BETWEEN 1 AND 5),
    calmness_level INT CHECK (calmness_level BETWEEN 1 AND 5),
    ui_quality INT CHECK (ui_quality BETWEEN 1 AND 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================================
-- SEED DATA
-- ============================================================

-- Default user: Soumik@2007 / 2007
INSERT INTO users (username, user_id_str, birth_year, password_hash, age, height_cm, weight_kg)
VALUES ('Soumik', 'Soumik@2007', 2007, '2007', 19, 175.0, 68.0);

INSERT INTO meditation_sessions (title, mood_tag, duration_minutes, audio_url, image_url, description) VALUES
('Calm the Storm', 'OVERWHELMED', 10, 'assets/audio/calm-storm.mp3', 'assets/images/overwhelmed.jpg', 'A grounding session to ease an overwhelmed mind.'),
('Deep Recovery', 'RECOVERY', 25, 'assets/audio/deep-recovery.mp3', 'assets/images/recovery.jpg', 'An extended restorative session for heavy weeks.'),
('Drift to Sleep', 'CANT_SLEEP', 15, 'assets/audio/drift-sleep.mp3', 'assets/images/sleep.jpg', 'Gentle guidance into deep, restful sleep.'),
('Energy Rise', 'LOW_ENERGY', 8, 'assets/audio/energy-rise.mp3', 'assets/images/energy.jpg', 'A short practice to restore lightness and energy.'),
('Laser Focus', 'UNFOCUSED', 12, 'assets/audio/laser-focus.mp3', 'assets/images/focus.jpg', 'Sharpen attention and quiet mental noise.'),
('Morning Stillness', 'GENERAL', 10, 'assets/audio/morning-stillness.mp3', 'assets/images/general.jpg', 'A balanced, everyday mindfulness practice.');
