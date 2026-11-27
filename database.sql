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

CREATE TABLE IF NOT EXISTS addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    label VARCHAR(80) NOT NULL,
    line1 VARCHAR(255) NOT NULL,
    city VARCHAR(60) NOT NULL,
    state VARCHAR(60) NOT NULL,
    pin_code VARCHAR(10) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sku VARCHAR(40) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(40) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    color_name VARCHAR(50) NOT NULL,
    color_hex VARCHAR(16) DEFAULT '#111111',
    sizes VARCHAR(100) DEFAULT 'XS,S,M,L,XL',
    image_url VARCHAR(255) NOT NULL,
    description TEXT,
    composition TEXT
);

CREATE TABLE IF NOT EXISTS cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    session_key VARCHAR(120) NOT NULL,
    product_id INT NOT NULL,
    size VARCHAR(20) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS wishlist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    session_key VARCHAR(120) NOT NULL,
    product_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_code VARCHAR(40) NOT NULL UNIQUE,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(120) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(60) NOT NULL,
    state VARCHAR(60) NOT NULL,
    pin_code VARCHAR(10) NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    promo_code VARCHAR(30) DEFAULT '',
    subtotal DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(10, 2) DEFAULT 0.00,
    gst_amount DECIMAL(10, 2) DEFAULT 0.00,
    shipping_fee DECIMAL(10, 2) DEFAULT 0.00,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(30) DEFAULT 'Processing',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT,
    product_name VARCHAR(150) NOT NULL,
    size VARCHAR(20) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

INSERT IGNORE INTO users (id, name, email, password, phone, city) VALUES
(1, 'Ananya Sharma', 'ananya.sharma@example.in', 'vera2026', '+91 98201 44510', 'Mumbai'),
(2, 'Aarav Mehta', 'aarav.mehta@example.in', 'vera2026', '+91 98112 78230', 'New Delhi'),
(3, 'Diya Nair', 'diya.nair@example.in', 'vera2026', '+91 99001 56321', 'Bengaluru'),
(4, 'Kabir Kapoor', 'kabir.kapoor@example.in', 'vera2026', '+91 98490 21887', 'Hyderabad');

INSERT IGNORE INTO addresses (id, user_id, label, line1, city, state, pin_code, phone) VALUES
(1, 1, 'Home - South Mumbai', '14B Altamount Road, Kemps Corner', 'Mumbai', 'Maharashtra', '400026', '+91 98201 44510'),
(2, 2, 'Residence - Jor Bagh', '42 Jor Bagh Market Road', 'New Delhi', 'Delhi', '110003', '+91 98112 78230'),
(3, 3, 'Studio - Indiranagar', '100 Feet Road, HAL 2nd Stage', 'Bengaluru', 'Karnataka', '560038', '+91 99001 56321');

INSERT IGNORE INTO products (id, sku, name, category, price, stock, color_name, color_hex, sizes, image_url, description, composition) VALUES
(1, 'VERA-WM-8810', 'STRUCTURED DOUBLE-BREASTED WOOL BLAZER', 'WOMAN', 12990.00, 18, 'Ivory', '#F3EFE6', 'XS,S,M,L,XL', 'images/woman_blazer.jpg', 'Tailored in heavyweight Italian virgin wool with architectural peak lapels and horn button closure.', '100% Virgin Wool. Lining: 100% Cupro. Dry clean only.'),
(2, 'VERA-WM-8814', 'BIAS-CUT MULBERRY SILK SLIP DRESS', 'WOMAN', 8990.00, 14, 'Champagne', '#DDD0BC', 'XS,S,M,L', 'images/woman_dress.jpg', 'Fluid midi slip dress cut on the bias in luminous heavyweight silk charmeuse.', '100% Mulberry Silk. Delicate hand wash cold or dry clean.'),
(3, 'VERA-WM-8821', 'OVERSIZED GABARDINE ARCHITECTURAL TRENCH', 'WOMAN', 15990.00, 9, 'Stone Taupe', '#9E9689', 'XS,S,M,L,XL', 'images/woman_trench.jpg', 'Relaxed full-length trench coat crafted from water-repellent combed cotton gabardine.', '100% Organic Cotton Gabardine. Dry clean recommended.'),
(4, 'VERA-WM-8840', 'BOX-CALF ARCHITECTURAL TOTE BAG', 'WOMAN', 18490.00, 4, 'Obsidian Black', '#111111', 'ONE SIZE', 'images/woman_tote.jpg', 'Geometric structured tote crafted from smooth full-grain box-calf leather with suede interior.', '100% Full-Grain Calf Leather. Dimensions: 38 x 30 x 14 cm.'),
(5, 'VERA-MN-4402', 'CASHMERE BLEND SINGLE-BREASTED OVERCOAT', 'MAN', 19990.00, 11, 'Charcoal', '#3A3B3C', 'S,M,L,XL', 'images/man_overcoat.jpg', 'Sharp knee-length overcoat woven in a brushed wool-cashmere blend with concealed placket.', '85% Virgin Wool, 15% Cashmere. Dry clean only.'),
(6, 'VERA-MN-4411', 'UNLINED ECRU LINEN TAILORED SUIT JACKET', 'MAN', 11490.00, 16, 'Ecru', '#EAE5D9', 'S,M,L,XL', 'images/man_suit.jpg', 'Breathable summer tailoring in washed Belgian linen-cotton with soft unpadded shoulders.', '68% European Flax Linen, 32% Cotton. Dry clean or gentle steam.'),
(7, 'VERA-MN-4425', 'HEAVY-GAUGE RIBBED MERINO CREWNECK', 'MAN', 6490.00, 3, 'Espresso', '#3B2F2A', 'XS,S,M,L,XL', 'images/man_knit.jpg', 'Dense 5-gauge fisherman rib sweater spun from extra-fine Australian merino wool.', '100% Extra-Fine Merino Wool. Hand wash cold, dry flat.'),
(8, 'VERA-KD-2104', 'ORGANIC COTTON BELTED TRENCH COAT', 'KIDS', 4990.00, 22, 'Sand', '#CBBFA9', '4-5Y,6-7Y,8-9Y,10-11Y', 'images/kids_trench.jpg', 'Timeless double-breasted trench jacket tailored for movement in organic cotton twill.', '100% Organic Cotton. Machine wash gentle 30C.'),
(9, 'VERA-KD-2110', 'RIBBED CREAM MERINO KNIT PULLOVER', 'KIDS', 3490.00, 5, 'Cream', '#F5F2EB', '4-5Y,6-7Y,8-9Y,10-11Y', 'images/kids_trench.jpg', 'Soft breathable ribbed knit pullover designed for transitional layering.', '100% Combed Organic Cotton and Merino Blend.'),
(10, 'VERA-PF-0401', 'VERA SANTAL 04 EAU DE PARFUM - 100 ML', 'PERFUMES', 7990.00, 27, 'Smoked Amber', '#8A4F1D', 'ONE SIZE', 'images/perfume_santal.jpg', 'Architectural woody extrait opening with Mysore sandalwood, cardamom, white cedar, and vetiver.', '100 ml / 3.4 fl. oz. Eau de Parfum.');

INSERT IGNORE INTO orders (id, order_code, customer_name, customer_email, phone, address, city, state, pin_code, payment_method, promo_code, subtotal, discount, gst_amount, shipping_fee, total_amount, status) VALUES
(1, 'VR-2026-1048', 'Ananya Sharma', 'ananya.sharma@example.in', '+91 98201 44510', '14B Altamount Road, Kemps Corner', 'Mumbai', 'Maharashtra', '400026', 'UPI', '', 20980.00, 0.00, 2248.00, 0.00, 20980.00, 'Delivered'),
(2, 'VR-2026-1049', 'Aarav Mehta', 'aarav.mehta@example.in', '+91 98112 78230', '42 Jor Bagh Market Road', 'New Delhi', 'Delhi', '110003', 'Card', '', 19990.00, 0.00, 2142.00, 0.00, 19990.00, 'Shipped'),
(3, 'VR-2026-1050', 'Diya Nair', 'diya.nair@example.in', '+91 99001 56321', '100 Feet Road, HAL 2nd Stage', 'Bengaluru', 'Karnataka', '560038', 'UPI', 'VERA10', 27480.00, 2748.00, 2650.00, 0.00, 24732.00, 'Processing'),
(4, 'VR-2026-1051', 'Kabir Kapoor', 'kabir.kapoor@example.in', '+91 98490 21887', 'Plot 88, Road No. 45, Jubilee Hills', 'Hyderabad', 'Telangana', '500033', 'COD', '', 6490.00, 0.00, 695.00, 0.00, 6490.00, 'Processing');

INSERT IGNORE INTO order_items (id, order_id, product_id, product_name, size, price, quantity) VALUES
(1, 1, 1, 'STRUCTURED DOUBLE-BREASTED WOOL BLAZER', 'S', 12990.00, 1),
(2, 1, 10, 'VERA SANTAL 04 EAU DE PARFUM - 100 ML', 'ONE SIZE', 7990.00, 1),
(3, 2, 5, 'CASHMERE BLEND SINGLE-BREASTED OVERCOAT', 'L', 19990.00, 1),
(4, 3, 2, 'BIAS-CUT MULBERRY SILK SLIP DRESS', 'M', 8990.00, 1),
(5, 3, 4, 'BOX-CALF ARCHITECTURAL TOTE BAG', 'ONE SIZE', 18490.00, 1),
(6, 4, 7, 'HEAVY-GAUGE RIBBED MERINO CREWNECK', 'M', 6490.00, 1);
