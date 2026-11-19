CREATE DATABASE IF NOT EXISTS vera_store;
USE vera_store;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    city VARCHAR(60)
);

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sku VARCHAR(40) NOT NULL,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(40) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    color_name VARCHAR(50),
    description TEXT
);

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(120) NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    size VARCHAR(20) NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(60) NOT NULL,
    pin_code VARCHAR(10) NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    status VARCHAR(30) DEFAULT 'Processing',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (name, email, password, phone, city) VALUES
('Ananya Sharma', 'ananya.sharma@example.in', 'vera2026', '+91 98201 44510', 'Mumbai'),
('Aarav Mehta', 'aarav.mehta@example.in', 'vera2026', '+91 98112 78230', 'New Delhi');

INSERT INTO products (sku, name, category, price, stock, color_name, description) VALUES
('VERA-WM-8810', 'STRUCTURED DOUBLE-BREASTED WOOL BLAZER', 'WOMAN', 12990.00, 18, 'Ivory', 'Tailored virgin wool blazer with peak lapels.'),
('VERA-WM-8814', 'BIAS-CUT MULBERRY SILK SLIP DRESS', 'WOMAN', 8990.00, 14, 'Champagne', 'Fluid midi slip dress in silk charmeuse.'),
('VERA-MN-4402', 'CASHMERE BLEND SINGLE-BREASTED OVERCOAT', 'MAN', 19990.00, 11, 'Charcoal', 'Knee-length overcoat in brushed wool-cashmere.'),
('VERA-KD-2104', 'ORGANIC COTTON BELTED TRENCH COAT', 'KIDS', 4990.00, 22, 'Sand', 'Double-breasted organic cotton twill trench.'),
('VERA-PF-0401', 'VERA SANTAL 04 EAU DE PARFUM - 100 ML', 'PERFUMES', 7990.00, 27, 'Smoked Amber', 'Mysore sandalwood, cardamom, and vetiver.');

INSERT INTO orders (customer_name, customer_email, product_name, size, quantity, total_amount, address, city, pin_code, payment_method, status) VALUES
('Ananya Sharma', 'ananya.sharma@example.in', 'STRUCTURED DOUBLE-BREASTED WOOL BLAZER', 'S', 1, 12990.00, '14B Altamount Road, Kemps Corner', 'Mumbai', '400026', 'UPI', 'Delivered'),
('Aarav Mehta', 'aarav.mehta@example.in', 'CASHMERE BLEND SINGLE-BREASTED OVERCOAT', 'L', 1, 19990.00, '42 Jor Bagh Market Road', 'New Delhi', '110003', 'Card', 'Shipped');
