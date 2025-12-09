require('dotenv').config();
const express = require('express');
const path = require('path');
const mysql = require('mysql2/promise');
const cors = require('cors');

const app = express();

// ✅ MIDDLEWARE DULU
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ✅ SERVE FRONTEND & BOOTSTRAP
app.use(express.static(path.join(__dirname, '../frontend')));
app.use('/bootstrap', express.static(path.join(__dirname, '../node_modules/bootstrap/dist')));

// ✅ POOL MYSQL (case-sensitive .env)
const pool = mysql.createPool({
  host: 'server.yudhonet.id',
  user: 'yudhopatrianto',
  password: '123',
  database: 'db_easyfood'
});

// ENDPOINTS SETELAH STATIC
app.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    const [rows] = await pool.execute(
      'SELECT * FROM tb_seller_account WHERE email = ? AND password = ?',
      [email, password]
    );
    console.log('Login attempt:', email);
    if (rows.length > 0) {
      res.json({ success: true, message: 'Successfully login' });
    } else {
      res.json({ success: false, message: 'Username or password is wrong!' });
    }
  } catch (error) {
    console.error('DB Error:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

app.get('/config', (req, res) => {
  res.json({ 
    db_username: 'yudhopatrianto',
    db_name: 'db_easyfood'
  });
});

app.listen(3000, () => console.log('🚀 Server: http://localhost:3000'));
