CREATE DATABASE laberinto;

USE laberinto;

CREATE TABLE record (
    id INT PRIMARY KEY,
    tiempo_ms BIGINT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO record (id, tiempo_ms)
VALUES (1, 0);