CREATE TABLE IF NOT EXISTS recipes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    recipe TEXT NOT NULL
);

INSERT INTO recipes (title, recipe)
VALUES ('Test', '<h3>Test</h3><p>This is a test.</p>');
