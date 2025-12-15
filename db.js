const mysql = require('mysql2');

const connection = mysql.createConnection({
    host: 'server.yudhonet.id',
    user: 'yudhopatrianto',      // Update with your MySQL username
    password: '123',      // Update with your MySQL password
    database: 'db_easyfood',
    port: 3306
});

connection.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL:', err);
        return;
    }
    console.log('Connected to MySQL database');
});

module.exports = connection;
