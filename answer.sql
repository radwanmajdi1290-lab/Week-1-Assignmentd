-- ====================================================================
-- Week 1 Assignment: Library Management System Database
-- Description: Creates a database for managing books, members, and loans.
-- ====================================================================

-- 1. Create and Use the Database
DROP DATABASE IF EXISTS library_db;
CREATE DATABASE library_db;
USE library_db;

-- 2. Create Tables

-- Authors Table
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    country VARCHAR(50)
);

-- Books Table
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    author_id INT,
    published_year INT,
    genre VARCHAR(50),
    available_copies INT DEFAULT 1,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);

-- Members Table
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    join_date DATE DEFAULT (CURRENT_DATE)
);

-- Loans Table (Tracking borrowed books)
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    member_id INT,
    borrow_date DATE DEFAULT (CURRENT_DATE),
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- 3. Insert Sample Data

-- Insert Authors
INSERT INTO authors (first_name, last_name, country) VALUES
('J.K.', 'Rowling', 'United Kingdom'),
('George', 'Orwell', 'United Kingdom'),
('J.R.R.', 'Tolkien', 'United Kingdom'),
('Agatha', 'Christie', 'United Kingdom');

-- Insert Books
INSERT INTO books (title, author_id, published_year, genre, available_copies) VALUES
('Harry Potter and the Sorcerer''s Stone', 1, 1997, 'Fantasy', 3),
('1984', 2, 1949, 'Dystopian', 2),
('The Hobbit', 3, 1937, 'Fantasy', 4),
('And Then There Were None', 4, 1939, 'Mystery', 2);

-- Insert Members
INSERT INTO members (first_name, last_name, email, join_date) VALUES
('Alice', 'Smith', 'alice.smith@example.com', '2026-01-15'),
('Bob', 'Johnson', 'bob.johnson@example.com', '2026-02-10'),
('Charlie', 'Brown', 'charlie.brown@example.com', '2026-03-01');

-- Insert Loans
INSERT INTO loans (book_id, member_id, borrow_date, return_date) VALUES
(1, 1, '2026-10-01', '2026-10-15'),
(2, 2, '2026-10-05', NULL),
(3, 3, '2026-10-10', NULL);

-- 4. Sample Queries

-- View all available books with their authors
SELECT 
    b.book_id,
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author,
    b.genre,
    b.available_copies
FROM books b
JOIN authors a ON b.author_id = a.author_id;

-- View currently active loans (books not yet returned)
SELECT 
    l.loan_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    b.title AS book_title,
    l.borrow_date
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN books b ON l.book_id = b.book_id
WHERE l.return_date IS NULL;
