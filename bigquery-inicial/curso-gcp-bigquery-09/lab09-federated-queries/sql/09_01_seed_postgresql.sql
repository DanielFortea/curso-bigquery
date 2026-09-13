CREATE TABLE customer_profiles (
    customer_id VARCHAR(50) PRIMARY KEY,
    phone_number VARCHAR(20),
    loyalty_tier VARCHAR(20),
    address VARCHAR(100)
);

INSERT INTO customer_profiles (customer_id, phone_number, loyalty_tier, address) VALUES
('C101', '+1-555-0199', 'Gold', '123 Main St, New York'),
('C102', '+1-555-0155', 'Silver', '456 Elm St, San Francisco'),
('C103', '+34-600-111', 'Bronze', 'Gran Via 45, Madrid'),
('C104', '+81-90-2222', 'Platinum', 'Shibuya 1-2, Tokyo');