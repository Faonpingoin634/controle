--Librairie

--Afficher le nom et le prénom de tous les auteurs :

SELECT firstname, lastname FROM authors;

--Afficher la liste des éditeurs qui ont une virgule dans leur nom :

SELECT name FROM editors WHERE name LIKE '%,%';

--Afficher la liste des emprunts qui sont en retard de retour :

SELECT * FROM loans WHERE is_returned = FALSE AND return_date < CURDATE();

--Afficher le titre des livres dont le titre comporte moins de 50 caractères :

SELECT title FROM books WHERE LENGTH(title) < 50;

--Ecommerce

--afficher toutes les quantités commandées du produit avec l'id 2456

SELECT SUM(quantity) AS order_items
FROM orders_items
WHERE product_id = 2456;

--afficher le nom de tous les produits qui ne sont plus en stock

SELECT name 
FROM products
WHERE stock = 0;

--afficher les commandes qui n'ont pas encore été livrée

SELECT id, customer_id, order_date
FROM orders
WHERE delivery_status = 0;

--afficher tous les clients qui ont une adresse email qui termine par @gmail.com

SELECT id, name, email
FROM customer
WHERE email LIKE '%@gmail.com';


--Exposition d'art

CREATE DATABASE exhibition;
USE exhibition;

CREATE TABLE authors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(255) NOT NULL,
    lastname VARCHAR(255) NOT NULL
);

CREATE TABLE artworks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    acquisition_date DATE NOT NULL,
    catalog_number VARCHAR(255) NOT NULL,
    author_id INT,
    FOREIGN KEY (author_id) REFERENCES authors(id)
);

CREATE TABLE exhibition_rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(255) NOT NULL,
    room_name VARCHAR(255) NOT NULL,
    number_of_artworks INT NOT NULL,
    lighting_type VARCHAR(255) NOT NULL
);

CREATE TABLE exhibitions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    start_date DATE NOT NULL,
    duration INT NOT NULL 
);

CREATE TABLE artwork_exhibitions (
    artwork_id INT NOT NULL,
    exhibition_id INT NOT NULL,
    FOREIGN KEY (artwork_id) REFERENCES artworks(id),
    FOREIGN KEY (exhibition_id) REFERENCES exhibitions(id)
);

CREATE TABLE private_loan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    artwork_id INT NOT NULL,
    owner_firstname VARCHAR(255) NOT NULL,
    owner_lastname VARCHAR(255) NOT NULL,
    owner_address VARCHAR(255) NOT NULL,
    loan_start_date DATE NOT NULL,
    loan_duration INT NOT NULL, 
    FOREIGN KEY (artwork_id) REFERENCES artworks(id)
);

CREATE TABLE artwork_insurance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    artwork_id INT NOT NULL,
    insurance_premium DECIMAL(10, 2) NOT NULL,
    insured_value DECIMAL(10, 2) NOT NULL,
    insurance_company_name VARCHAR(255) NOT NULL,
    insurance_company_address VARCHAR(255) NOT NULL,
    FOREIGN KEY (artwork_id) REFERENCES artworks(id)
);

CREATE TABLE artwork_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(255) NOT NULL
);

CREATE TABLE artwork_type_association (
    artwork_id INT NOT NULL,
    type_id INT NOT NULL,
    FOREIGN KEY (artwork_id) REFERENCES artworks(id),
    FOREIGN KEY (type_id) REFERENCES artwork_types(id)
);

SELECT 
    pl.owner_firstname,
    pl.owner_lastname,
    pl.owner_address,
    aw.title,
    at.type_name
FROM private_loan pl
JOIN artworks aw ON pl.artwork_id = aw.id
JOIN artwork_type_association ata ON aw.id = ata.artwork_id
JOIN artwork_types at ON ata.type_id = at.id;

--Gestion de stock

CREATE DATABASE gcivil_stock;
USE gcivil_stock;

CREATE TABLE products (
    code INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE suppliers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL
);

CREATE TABLE product_suppliers (
    product_code INT NOT NULL,
    supplier_id INT NOT NULL,
    purchase_price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (product_code, supplier_id),
    FOREIGN KEY (product_code) REFERENCES products(code),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

INSERT INTO products (description, unit_price) 
VALUES 
('Produit A', 100.00),
('Produit B', 200.00),
('Produit C', 150.00);

INSERT INTO suppliers (name, address)
VALUES 
('Fournisseur X', 'Adresse du Fournisseur X'),
('Fournisseur Y', 'Adresse du Fournisseur Y');

INSERT INTO product_suppliers (product_code, supplier_id, purchase_price)
VALUES
(1, 1, 90.00),
(1, 2, 95.00),
(2, 1, 180.00),
(3, 2, 140.00);
