let mysql = require('mysql2');

const pool = mysql.createPool({
    waitForConnections: true,
    connectionLimit: 10,
    host: 'classmysql.engr.oregonstate.edu',
    user: 'cs340_lozanogb',
    password: '6874',
    database: 'cs340_lozanogb'
}).promise();

module.exports = pool;
