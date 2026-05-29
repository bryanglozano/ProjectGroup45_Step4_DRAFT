-- =============================================
-- Group 45 - Elite Luxury Rental Management System
-- Project Step 4 DRAFT PL
-- Members: Alejandro Leon, Bryan Lozano Gutierrez, Jeremy Lammon
-- RESET stored procedure
-- =============================================

DROP PROCEDURE IF EXISTS sp_reset_database;

DELIMITER //

CREATE PROCEDURE sp_reset_database()
BEGIN
    SET FOREIGN_KEY_CHECKS=0;

    DROP TABLE IF EXISTS `EmployeeClients`;
    DROP TABLE IF EXISTS `Rentals`;
    DROP TABLE IF EXISTS `Employees`;
    DROP TABLE IF EXISTS `Vehicles`;
    DROP TABLE IF EXISTS `Clients`;
    DROP TABLE IF EXISTS `Locations`;

    CREATE TABLE `Locations` (
        `locationID` int NOT NULL AUTO_INCREMENT,
        `locationName` varchar(100) NOT NULL,
        `address` varchar(200) NOT NULL,
        `city` varchar(50) NOT NULL,
        `phone` varchar(20) DEFAULT NULL,
        PRIMARY KEY (`locationID`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

    CREATE TABLE `Clients` (
        `clientID` int NOT NULL AUTO_INCREMENT,
        `firstName` varchar(50) NOT NULL,
        `lastName` varchar(50) NOT NULL,
        `email` varchar(100) NOT NULL UNIQUE,
        `phone` varchar(20) NOT NULL,
        `membershipTier` varchar(20) DEFAULT 'Standard',
        `joinDate` date NOT NULL,
        PRIMARY KEY (`clientID`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

    CREATE TABLE `Vehicles` (
        `vehicleID` int NOT NULL AUTO_INCREMENT,
        `locationID` int NOT NULL,
        `make` varchar(50) NOT NULL,
        `model` varchar(50) NOT NULL,
        `year` int NOT NULL,
        `licensePlate` varchar(20) NOT NULL UNIQUE,
        `dailyRate` decimal(10,2) NOT NULL,
        `status` varchar(20) NOT NULL,
        `mileage` int DEFAULT 0,
        PRIMARY KEY (`vehicleID`),
        FOREIGN KEY (`locationID`) REFERENCES `Locations`(`locationID`)
            ON DELETE RESTRICT ON UPDATE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

    CREATE TABLE `Employees` (
        `employeeID` int NOT NULL AUTO_INCREMENT,
        `firstName` varchar(50) NOT NULL,
        `lastName` varchar(50) NOT NULL,
        `email` varchar(100) NOT NULL UNIQUE,
        `phone` varchar(20) DEFAULT NULL,
        `hireDate` date NOT NULL,
        `role` varchar(30) NOT NULL,
        `locationID` int NOT NULL,
        PRIMARY KEY (`employeeID`),
        FOREIGN KEY (`locationID`) REFERENCES `Locations`(`locationID`)
            ON DELETE RESTRICT ON UPDATE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

    CREATE TABLE `Rentals` (
        `rentalID` int NOT NULL AUTO_INCREMENT,
        `clientID` int NOT NULL,
        `vehicleID` int NOT NULL,
        `locationID` int NOT NULL,
        `pickupDate` date NOT NULL,
        `returnDate` date NOT NULL,
        `actualReturnDate` date DEFAULT NULL,
        `totalCost` decimal(10,2) NOT NULL,
        `status` varchar(20) NOT NULL,
        PRIMARY KEY (`rentalID`),
        FOREIGN KEY (`clientID`) REFERENCES `Clients`(`clientID`)
            ON DELETE RESTRICT ON UPDATE CASCADE,
        FOREIGN KEY (`vehicleID`) REFERENCES `Vehicles`(`vehicleID`)
            ON DELETE RESTRICT ON UPDATE CASCADE,
        FOREIGN KEY (`locationID`) REFERENCES `Locations`(`locationID`)
            ON DELETE RESTRICT ON UPDATE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

    CREATE TABLE `EmployeeClients` (
        `employeeClientID` int NOT NULL AUTO_INCREMENT,
        `employeeID` int NOT NULL,
        `clientID` int NOT NULL,
        PRIMARY KEY (`employeeClientID`),
        UNIQUE KEY `unique_employee_client` (`employeeID`, `clientID`),
        FOREIGN KEY (`employeeID`) REFERENCES `Employees`(`employeeID`)
            ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (`clientID`) REFERENCES `Clients`(`clientID`)
            ON DELETE CASCADE ON UPDATE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

    INSERT INTO `Locations` (`locationName`, `address`, `city`, `phone`) VALUES
    ('Beverly Hills', '123 Rodeo Drive', 'Beverly Hills', '(310) 555-0101'),
    ('Newport Beach', '456 Pacific Coast Hwy', 'Newport Beach', '(949) 555-0202'),
    ('Irvine', '789 Jamboree Road', 'Irvine', '(949) 555-0303');

    INSERT INTO `Clients` (`firstName`, `lastName`, `email`, `phone`, `membershipTier`, `joinDate`) VALUES
    ('Emma', 'Thompson', 'emma.t@email.com', '(310) 555-1001', 'VIP', '2024-01-15'),
    ('Michael', 'Rodriguez', 'michael.r@email.com', '(949) 555-1002', 'Premium', '2024-03-20'),
    ('Sophia', 'Chen', 'sophia.c@email.com', '(714) 555-1003', 'Standard', '2025-02-10'),
    ('James', 'Patel', 'james.p@email.com', '(310) 555-1004', 'VIP', '2023-11-05');

    INSERT INTO `Vehicles` (`locationID`, `make`, `model`, `year`, `licensePlate`, `dailyRate`, `status`, `mileage`) VALUES
    (1, 'Ferrari', '488 Spider', 2023, 'FERR488', 1499.99, 'Available', 2450),
    (1, 'Lamborghini', 'Urus', 2024, 'LAMBU24', 1299.99, 'Rented', 1800),
    (2, 'Rolls Royce', 'Ghost', 2023, 'RRGHOST', 1799.99, 'Available', 3200),
    (3, 'Porsche', '911 Turbo S', 2024, 'P911TS', 899.99, 'Maintenance', 890),
    (2, 'Bentley', 'Continental GT', 2023, 'BENT23', 1599.99, 'Available', 1450);

    INSERT INTO `Employees` (`firstName`, `lastName`, `email`, `phone`, `hireDate`, `role`, `locationID`) VALUES
    ('David', 'Kim', 'david.k@elitrentals.com', '(310) 555-2001', '2023-06-01', 'Manager', 1),
    ('Olivia', 'Martinez', 'olivia.m@elitrentals.com', '(949) 555-2002', '2024-01-15', 'Rental Specialist', 2),
    ('Liam', 'Nguyen', 'liam.n@elitrentals.com', '(949) 555-2003', '2024-09-01', 'Service Advisor', 3),
    ('Isabella', 'Garcia', 'isabella.g@elitrentals.com', '(310) 555-2004', '2023-11-10', 'Rental Specialist', 1);

    INSERT INTO `Rentals` (`clientID`, `vehicleID`, `locationID`, `pickupDate`, `returnDate`, `actualReturnDate`, `totalCost`, `status`) VALUES
    (1, 2, 1, '2025-04-01', '2025-04-05', NULL, 5199.96, 'Active'),
    (2, 1, 1, '2025-03-15', '2025-03-18', '2025-03-18', 4499.97, 'Completed'),
    (3, 5, 2, '2025-04-10', '2025-04-12', NULL, 3199.98, 'Active'),
    (4, 3, 2, '2025-02-20', '2025-02-25', '2025-02-25', 8999.95, 'Completed'),
    (1, 4, 3, '2025-01-05', '2025-01-07', '2025-01-07', 1799.98, 'Completed');

    INSERT INTO `EmployeeClients` (`employeeID`, `clientID`) VALUES
    (1, 1), (1, 2),
    (2, 3), (2, 4),
    (4, 1), (4, 3),
    (3, 2);

    SET FOREIGN_KEY_CHECKS=1;
END //

DELIMITER ;