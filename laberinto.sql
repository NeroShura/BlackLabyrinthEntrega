CREATE DATABASE laberinto;

USE laberinto;

CREATE TABLE IF NOT EXISTS ranking (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        nombre TEXT NOT NULL UNIQUE, 
        tiempo_ms INTEGER NOT NULL, 
        fecha TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP)

INSERT INTO ranking (nombre, tiempo_ms, fecha) 
        VALUES ("Ian", 00:29:50, datetime('now', 'localtime'))
