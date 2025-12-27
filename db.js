const mysql = require('mysql2');

const db = mysql.createConnection({
    host: 'server.yudhonet.id',
    user: 'yudhopatrianto',
    password: '123',
    database: 'db_easyfood',
    port: 3306  
});

db.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL:', err);
        return;
    }
    console.log('Connected to MySQL database');
});

// Handle connection errors (e.g., lost connection)
db.on('error', function (err) {
    console.error('MySQL Error:', err);
    if (err.code === 'PROTOCOL_CONNECTION_LOST') {
        console.log('Connection lost. Reconnecting...');
        // Ideally, you'd have a function to recreate the connection here
        // For simple apps, restarting the server via nodemon is often enough
    } else {
        throw err;
    }
});

module.exports = db;
