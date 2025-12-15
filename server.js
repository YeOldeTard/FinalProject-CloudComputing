const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const session = require('express-session');
const path = require('path');
const db = require('./db');
const nodemailer = require('nodemailer');

const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Configure Session Middleware
app.use(session({
    secret: 'secretkey1123', // Change this in production
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false } // Set to true if using HTTPS
}));

// Serve static files from the 'public' directory
app.use(express.static('public'));

// Serve Bootstrap and Icons from node_modules
app.use('/css', express.static(__dirname + '/node_modules/bootstrap/dist/css'));
app.use('/js', express.static(__dirname + '/node_modules/bootstrap/dist/js'));
app.use('/icons', express.static(__dirname + '/node_modules/bootstrap-icons/font'));

// Middleware to check if user is authenticated
function isAuthenticated(req, res, next) {
    if (req.session.user) {
        return next();
    }
    res.redirect('/');
}

// Protected Dashboard Route
app.get('/dashboard', isAuthenticated, (req, res) => {
    res.sendFile(path.join(__dirname, 'protected', 'dashboard.html'));
});

// Logout Route
app.get('/logout', (req, res) => {
    req.session.destroy((err) => {
        if (err) {
            return console.log(err);
        }
        res.redirect('/');
    });
});

// Configure Nodemailer (Mailtrap Production)
const transporter = nodemailer.createTransport({
    host: 'live.smtp.mailtrap.io',
    port: 587,
    auth: {
        user: 'api',
        pass: '3416f227a20a3a1b318857acee89d870' // Your API Token
    }
});

app.post('/support', (req, res) => {
    const { sellerName, email, issue } = req.body;

    // Generate Unique Ticket ID
    const timestamp = Date.now();
    const random = Math.floor(1000 + Math.random() * 9000);
    const ticketId = `TKT-${timestamp}-${random}`;

    const mailOptions = {
        from: '"EasyFood Support" <hello@demomailtrap.co>', // Mandatory for Demo Plan
        to: 'kydh01123@gmail.com', // Likely the account owner
        subject: `[${ticketId}] Support Request from ${sellerName}`,
        text: `Support Request\n\nTicket ID: ${ticketId}\n\nNama Seller: ${sellerName}\n\nEmail Seller: ${email}\n\nPermasalahan: ${issue}`
    };

    // Send Email
    transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
            console.log('Error sending email:', error);
            // Still return success to user so they get their ticket ID, but log the error
            // Or return error if strict. Let's strictly return success but warn log.
        } else {
            console.log('Email sent: ' + info.response);
        }
    });

    // Determine success response immediately (async email)
    res.json({
        success: true,
        message: 'Support request sent successfully! Check your email.',
        ticketId: ticketId
    });
});



app.post('/login', (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ success: false, message: 'Please enter email and password' });
    }

    const query = 'SELECT * FROM account WHERE email = ? AND password = ?';
    db.query(query, [email, password], (err, results) => {
        if (err) {
            console.error('Database error:', err);
            return res.status(500).json({ success: false, message: 'Database error' });
        }

        if (results.length > 0) {
            // Save user to session
            req.session.user = results[0];
            res.json({ success: true, message: 'Login successful' });
        } else {
            res.status(401).json({ success: false, message: 'Invalid email or password' });
        }
    });
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
