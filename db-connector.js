let mysql = require('mysql2');

const pool = mysql.createPool({
    waitForConnections: true,
    connectionLimit: 10,
    host: 'classmysql.engr.oregonstate.edu',
    user: 'USERNAME',
    password: 'PASSWORD',
    database: 'DATABASE'
}).promise();

module.exports = pool;
