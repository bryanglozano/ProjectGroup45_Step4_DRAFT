const express = require('express');
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 6875;

const db = require('./database/db-connector');

const { engine } = require('express-handlebars');
app.engine('.hbs', engine({ extname: '.hbs' }));
app.set('view engine', '.hbs');

app.get('/', (req, res) => {
    res.render('home');
});

app.get('/locations', async (req, res) => {
    try {
        const query = `
            SELECT locationID, locationName, address, city, phone
            FROM Locations;
        `;
        const [rows] = await db.query(query);

        res.render('locations', {
            locations: rows
        });
    } catch (error) {
        console.error('Error loading locations:', error);
        res.status(500).send('Error loading locations.');
    }
});


app.get('/clients', async (req, res) => {
    try {
        const query = `
            SELECT clientID, firstName, lastName, email, phone, membershipTier, joinDate
            FROM Clients;
        `;
        const [rows] = await db.query(query);

        res.render('clients', {
            clients: rows
        });
    } catch (error) {
        console.error('Error loading clients:', error);
        res.status(500).send('Error loading clients.');
    }
});

app.get('/vehicles', async (req, res) => {
    try {
        const query = `
            SELECT 
                Vehicles.vehicleID,
                Locations.locationName,
                Vehicles.make,
                Vehicles.model,
                Vehicles.year,
                Vehicles.licensePlate,
                Vehicles.dailyRate,
                Vehicles.status,
                Vehicles.mileage
            FROM Vehicles
            INNER JOIN Locations ON Vehicles.locationID = Locations.locationID;
        `;
        const [rows] = await db.query(query);

        res.render('vehicles', {
            vehicles: rows
        });
    } catch (error) {
        console.error('Error loading vehicles:', error);
        res.status(500).send('Error loading vehicles.');
    }
});

app.get('/employees', async (req, res) => {
    try {
        const query = `
            SELECT
                Employees.employeeID,
                Locations.locationName,
                Employees.firstName,
                Employees.lastName,
                Employees.email,
                Employees.phone,
                Employees.hireDate,
                Employees.role
            FROM Employees
            INNER JOIN Locations
                ON Employees.locationID = Locations.locationID;
        `;

        const [rows] = await db.query(query);

        res.render('employees', {
            employees: rows
        });
    } catch (error) {
        console.error('Error loading employees:', error);
        res.status(500).send('Error loading employees.');
    }
});

app.get('/rentals', async (req, res) => {
    try {
        const query = `
            SELECT
                Rentals.rentalID,
                CONCAT(Clients.firstName, ' ', Clients.lastName) AS client,
                CONCAT(Vehicles.make, ' ', Vehicles.model) AS vehicle,
                Locations.locationName,
                Rentals.pickupDate,
                Rentals.returnDate,
                Rentals.actualReturnDate,
                Rentals.totalCost,
                Rentals.status
            FROM Rentals
            INNER JOIN Clients
                ON Rentals.clientID = Clients.clientID
            INNER JOIN Vehicles
                ON Rentals.vehicleID = Vehicles.vehicleID
            INNER JOIN Locations
                ON Rentals.locationID = Locations.locationID;
        `;

        const [rows] = await db.query(query);

        res.render('rentals', {
            rentals: rows
        });
    } catch (error) {
        console.error('Error loading rentals:', error);
        res.status(500).send('Error loading rentals.');
    }
});

app.get('/employeeClients', async (req, res) => {
    try {
        const query = `
            SELECT
                EmployeeClients.employeeClientID,
                CONCAT(Employees.firstName, ' ', Employees.lastName) AS employee,
                CONCAT(Clients.firstName, ' ', Clients.lastName) AS client
            FROM EmployeeClients
            INNER JOIN Employees
                ON EmployeeClients.employeeID = Employees.employeeID
            INNER JOIN Clients
                ON EmployeeClients.clientID = Clients.clientID;
        `;

        const [rows] = await db.query(query);

        res.render('employeeClients', {
            employeeClients: rows
        });
    } catch (error) {
        console.error('Error loading employeeClients:', error);
        res.status(500).send('Error loading employee-client relationships.');
    }
});

app.get('/reset', async (req, res) => {
    try {
        await db.query('CALL sp_reset_database();');
        res.redirect('/');
    } catch (error) {
        console.error(error);
        res.status(500).send('Reset failed.');
    }
});

app.get('/delete-demo', async (req, res) => {
    try {
        await db.query("DELETE FROM EmployeeClients WHERE employeeClientID = 7;");
        res.redirect('/employeeClients');
    } catch (error) {
        console.error('Error deleting demo relationship:', error);
        res.status(500).send('Delete failed.');
    }
});

app.listen(PORT, () => {
    console.log('Server running on http://localhost:' + PORT);
});
