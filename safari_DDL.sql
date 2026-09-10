create schema safari;

DROP TABLE IF EXISTS safari.trips;
DROP TABLE IF EXISTS safari.riders;
DROP TABLE IF EXISTS safari.drivers;

-- ---------------------------------------------------------
-- drivers 
-- ---------------------------------------------------------
CREATE TABLE safari.drivers (
    driver_id     INTEGER PRIMARY KEY,
    driver_name   VARCHAR(100) NOT NULL,
    car_model     VARCHAR(100),
    joined_date   DATE,
    status        VARCHAR(20) NOT NULL CHECK (status IN ('Active', 'Inactive'))
);

INSERT INTO safari.drivers (driver_id, driver_name, car_model, joined_date, status) VALUES
    (1, 'James Mwangi', 'Toyota Voxy', '2022-01-10', 'Active'),
    (2, 'Peter Otieno', 'Toyota Premio', '2021-11-05', 'Active'),
    (3, 'Susan Wambui', 'Nissan Note', '2023-02-20', 'Active'),
    (4, 'David Kiptoo', 'Mazda Demio', '2022-07-15', 'Active'),
    (5, 'Grace Achieng', 'Toyota Fielder', '2020-05-01', 'Active'),
    (6, 'Hassan Ali', 'Subaru Forester', '2023-09-10', 'Active'),
    (7, 'Mercy Njeri', 'Toyota Vitz', '2021-03-25', 'Inactive'),
    (8, 'Brian Kamau', 'Toyota Axio', '2022-12-01', 'Active'),
    (9, 'Faith Wanjiru', 'Honda Fit', '2023-06-18', 'Active'),
    (10, 'Kevin Mutua', 'Toyota Noah', '2020-10-30', 'Active');

-- ---------------------------------------------------------
-- riders 
-- ---------------------------------------------------------
CREATE TABLE safari.riders (
    rider_id          INTEGER PRIMARY KEY,
    rider_name        VARCHAR(100) NOT NULL,
    city              VARCHAR(50),
    membership_tier   VARCHAR(20) CHECK (membership_tier IN ('Basic', 'Plus', 'Premium'))
);

INSERT INTO safari.riders (rider_id, rider_name, city, membership_tier) VALUES
    (1, 'Amina Hassan', 'Nairobi', 'Premium'),
    (2, 'Brian Otieno', 'Nairobi', 'Basic'),
    (3, 'Cynthia Wanjiru', 'Mombasa', 'Plus'),
    (4, 'Daniel Kiplagat', 'Nairobi', 'Basic'),
    (5, 'Esther Mwikali', 'Kisumu', 'Plus'),
    (6, 'Felix Ouma', 'Nairobi', 'Premium'),
    (7, 'Grace Wambui', 'Nakuru', 'Basic'),
    (8, 'Hassan Juma', 'Nairobi', 'Plus'),
    (9, 'Ivy Chepkoech', 'Eldoret', 'Basic'),
    (10, 'James Njoroge', 'Nairobi', 'Premium'),
    (11, 'Karen Atieno', 'Nairobi', 'Basic'),
    (12, 'Liam Kariuki', 'Thika', 'Plus');

-- ---------------------------------------------------------
-- trips 
-- ---------------------------------------------------------
CREATE TABLE safari.trips (
    trip_id          INTEGER PRIMARY KEY,
    rider_id         INTEGER NOT NULL REFERENCES safari.riders(rider_id),
    driver_id        INTEGER NOT NULL REFERENCES safari.drivers(driver_id),
    trip_date        DATE NOT NULL,
    pickup_area      VARCHAR(50),
    dropoff_area     VARCHAR(50),
    distance_km      NUMERIC(4,1) NOT NULL,
    fare             NUMERIC(8,2) NOT NULL,
    rider_rating     INTEGER CHECK (rider_rating BETWEEN 1 AND 5),
    payment_method   VARCHAR(20) CHECK (payment_method IN ('M-Pesa', 'Cash', 'Card'))
);

INSERT INTO safari.trips (trip_id, rider_id, driver_id, trip_date, pickup_area, dropoff_area, distance_km, fare, rider_rating, payment_method) VALUES
    (1, 11, 9, '2024-02-02', 'Ngong Road', 'Kilimani', 18.3, 1618, 3, 'Card'),
    (2, 9, 10, '2024-02-23', 'CBD', 'Lavington', 18.9, 1691, 1, 'M-Pesa'),
    (3, 4, 5, '2024-01-20', 'CBD', 'Eastleigh', 13.1, 1056, 3, 'Card'),
    (4, 6, 2, '2024-01-01', 'Eastleigh', 'CBD', 16.8, 1381, 2, 'Card'),
    (5, 8, 10, '2024-01-22', 'Parklands', 'Kilimani', 6.5, 650, 1, 'M-Pesa'),
    (6, 6, 2, '2024-02-22', 'Kasarani', 'Ngong Road', 18, 1562, 2, 'Cash'),
    (7, 12, 5, '2024-01-14', 'Westlands', 'Lavington', 12.3, 1046, 4, 'Cash'),
    (8, 5, 3, '2024-02-16', 'CBD', 'Lavington', 18.2, 1469, 2, 'Cash'),
    (9, 10, 3, '2024-02-02', 'CBD', 'Karen', 8.6, 793, 3, 'Card'),
    (10, 6, 8, '2024-01-15', 'Parklands', 'Eastleigh', 3.4, 303, 1, 'Card'),
    (11, 7, 5, '2024-02-15', 'Parklands', 'CBD', 15.8, 1376, 2, 'Cash'),
    (12, 10, 8, '2024-02-13', 'Embakasi', 'Kilimani', 10.2, 895, 4, 'Cash'),
    (13, 2, 2, '2024-01-11', 'Kilimani', 'Karen', 10.3, 858, 4, 'Card'),
    (14, 11, 9, '2024-02-04', 'Karen', 'Ngong Road', 1.4, 204, 4, 'Card'),
    (15, 9, 6, '2024-02-17', 'CBD', 'Karen', 5.7, 618, 2, 'Cash'),
    (16, 2, 3, '2024-01-06', 'Parklands', 'Eastleigh', 9.1, 785, 3, 'Card'),
    (17, 10, 9, '2024-01-16', 'Karen', 'Westlands', 6.7, 673, 2, 'Card'),
    (18, 2, 6, '2024-02-06', 'Karen', 'Ngong Road', 7, 648, 3, 'Cash'),
    (19, 4, 8, '2024-01-19', 'Ngong Road', 'Westlands', 11.7, 970, 2, 'Card'),
    (20, 12, 4, '2024-02-07', 'Embakasi', 'Parklands', 17.2, 1528, 2, 'Cash'),
    (21, 4, 4, '2024-02-20', 'Lavington', 'Karen', 18.1, 1463, 2, 'Cash'),
    (22, 2, 7, '2024-02-27', 'Kilimani', 'Westlands', 9.8, 966, 2, 'M-Pesa'),
    (23, 11, 8, '2024-01-07', 'Kilimani', 'Kasarani', 15.5, 1431, 2, 'Card'),
    (24, 2, 1, '2024-01-27', 'Embakasi', 'CBD', 15.7, 1312, 1, 'Cash'),
    (25, 3, 10, '2024-01-12', 'Karen', 'Kasarani', 14.7, 1190, 4, 'M-Pesa'),
    (26, 6, 10, '2024-01-14', 'Lavington', 'Ngong Road', 2, 217, 5, 'Card'),
    (27, 2, 3, '2024-01-03', 'Westlands', 'Kasarani', 6.9, 606, 4, 'M-Pesa'),
    (28, 12, 2, '2024-02-16', 'Lavington', 'Kilimani', 11.8, 1082, 5, 'Card'),
    (29, 11, 2, '2024-02-03', 'Ngong Road', 'Parklands', 4.4, 362, 2, 'Cash'),
    (30, 3, 5, '2024-02-12', 'Kilimani', 'Eastleigh', 5.9, 657, 5, 'M-Pesa'),
    (31, 8, 8, '2024-02-14', 'Ngong Road', 'Westlands', 2.8, 396, 5, 'Cash'),
    (32, 8, 1, '2024-02-19', 'Eastleigh', 'Kilimani', 16.7, 1519, 5, 'Cash'),
    (33, 11, 2, '2024-01-17', 'Eastleigh', 'Parklands', 6.8, 723, 1, 'M-Pesa'),
    (34, 6, 10, '2024-02-16', 'Karen', 'Kasarani', 5.3, 612, 2, 'M-Pesa'),
    (35, 3, 8, '2024-02-20', 'Eastleigh', 'Westlands', 10.9, 967, 1, 'M-Pesa'),
    (36, 2, 9, '2024-02-10', 'Karen', 'Eastleigh', 8.8, 759, 2, 'Cash'),
    (37, 9, 5, '2024-02-20', 'Karen', 'Kilimani', 7, 708, 3, 'M-Pesa'),
    (38, 7, 7, '2024-02-08', 'Eastleigh', 'Parklands', 14.5, 1236, 5, 'Cash'),
    (39, 5, 5, '2024-01-20', 'Kasarani', 'Parklands', 5, 517, 4, 'Cash'),
    (40, 3, 4, '2024-01-01', 'Kilimani', 'CBD', 15.8, 1362, 5, 'Cash');

-- ---------------------------------------------------------
-- Verification ; run these after loading to confirm row counts
-- ---------------------------------------------------------
 SELECT COUNT(*) FROM safari.drivers;   -- expect 10
 SELECT COUNT(*) FROM safari.riders;    -- expect 12
 SELECT COUNT(*) FROM safari.trips;     -- expect 40
