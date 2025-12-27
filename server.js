const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const session = require('express-session');
const path = require('path');
const db = require('./db');
const nodemailer = require('nodemailer');
const multer = require('multer');
const fs = require('fs');

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
app.use('/resources', express.static(path.join(__dirname, 'resources')));

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

// Configure Multer Storage
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        if (!req.session.user) return cb(new Error('Unauthorized'));

        const email = req.session.user.email;
        const username = email.split('@')[0];
        const userFolder = path.join(__dirname, 'resources', username, 'profile');

        // Create folder if not exists
        fs.mkdirSync(userFolder, { recursive: true });

        cb(null, userFolder);
    },
    filename: function (req, file, cb) {
        const ext = path.extname(file.originalname);
        cb(null, 'profile' + ext);
    }
});

const upload = multer({ storage: storage });

// Configure Product Storage
const productStorage = multer.diskStorage({
    destination: function (req, file, cb) {
        if (!req.session.user) return cb(new Error('Unauthorized'));

        const email = req.session.user.email;
        const username = email.split('@')[0];
        const productFolder = path.join(__dirname, 'resources', username, 'product');

        // Create folder if not exists
        fs.mkdirSync(productFolder, { recursive: true });

        cb(null, productFolder);
    },
    filename: function (req, file, cb) {
        // Use original filename as requested
        cb(null, file.originalname);
    }
});

const uploadProduct = multer({ storage: productStorage });

// Add Product Endpoint
// Add Product Endpoint
app.post('/api/product/add', isAuthenticated, uploadProduct.single('product_image'), (req, res) => {
    const { product_name, product_stock, product_price, product_notes, product_image_url } = req.body;
    const email = req.session.user.email;

    if (!product_name || !product_stock || !product_price) {
        return res.status(400).json({ success: false, message: 'Required fields missing' });
    }

    let imagePath = null;

    if (req.file) {
        const username = email.split('@')[0];
        // Use uploaded file
        imagePath = `/resources/${username}/product/${req.file.originalname}`;
    } else if (product_image_url && product_image_url.trim() !== '') {
        // Use provided URL
        imagePath = product_image_url.trim();
    }

    const query = 'INSERT INTO product (email, product_name, product_stock, product_price, product_notes, product_image) VALUES (?, ?, ?, ?, ?, ?)';

    db.query(query, [email, product_name, product_stock, product_price, product_notes, imagePath], (err, result) => {
        if (err) {
            console.error('Add product error:', err);
            return res.status(500).json({ success: false, message: 'Database error' });
        }

        res.json({ success: true, message: 'Product added successfully' });
    });
});



// Get User Products (List for Dropdown)
app.get('/api/user/products', isAuthenticated, (req, res) => {
    const email = req.session.user.email;
    const query = 'SELECT * FROM product WHERE email = ? ORDER BY id DESC';

    db.query(query, [email], (err, results) => {
        if (err) {
            console.error('Get products error:', err);
            return res.status(500).json({ success: false, message: 'Database error' });
        }
        res.json({ success: true, products: results });
    });
});

// Delete Product Endpoint
app.delete('/api/product/:id', isAuthenticated, (req, res) => {
    const productId = req.params.id;
    const email = req.session.user.email;

    // First get the image path to delete the file
    const getQuery = 'SELECT product_image FROM product WHERE id = ? AND email = ?';
    db.query(getQuery, [productId, email], (err, results) => {
        if (err) {
            return res.status(500).json({ success: false, message: 'Database error' });
        }
        if (results.length === 0) {
            return res.status(404).json({ success: false, message: 'Product not found' });
        }

        const imagePath = results[0].product_image;

        // Delete from DB
        const deleteQuery = 'DELETE FROM product WHERE id = ?';
        db.query(deleteQuery, [productId], (err, result) => {
            if (err) {
                return res.status(500).json({ success: false, message: 'Database error' });
            }

            // Delete file if exists and it's a local file
            if (imagePath && imagePath.startsWith('/resources/')) {
                // Convert web path (/resources/...) to system path
                // webPath: /resources/username/product/file.jpg
                // sysPath: __dirname/resources/username/product/file.jpg
                // Removing the leading slash from webPath ensures path.join works correctly relative to __dirname
                const validPath = imagePath.startsWith('/') ? imagePath.slice(1) : imagePath;
                const absolutePath = path.join(__dirname, validPath);

                fs.unlink(absolutePath, (err) => {
                    if (err) console.error('Error deleting image file:', err);
                });
            }



            res.json({ success: true, message: 'Product deleted successfully' });
        });
    });
});

// Update Product Endpoint
app.post('/api/product/update/:id', isAuthenticated, uploadProduct.single('product_image'), (req, res) => {
    const productId = req.params.id;
    const email = req.session.user.email;
    const { product_name, product_stock, product_price, product_notes, product_image_url } = req.body;

    // Validation
    if (!product_name || !product_stock || !product_price) {
        return res.status(400).json({ success: false, message: 'Please fill in all required fields' });
    }

    // 1. Get current image to delete if replaced
    const getQuery = 'SELECT product_image FROM product WHERE id = ? AND email = ?';
    db.query(getQuery, [productId, email], (err, results) => {
        if (err) {
            console.error('Get product for update error:', err);
            return res.status(500).json({ success: false, message: 'Database error' });
        }
        if (results.length === 0) {
            return res.status(404).json({ success: false, message: 'Product not found' });
        }

        const currentImage = results[0].product_image;
        let newImagePath = currentImage;
        let hasNewImageBeenProvided = false;
        const username = email.split('@')[0];

        // Determine new image
        if (req.file) {
            newImagePath = `/resources/${username}/product/${req.file.originalname}`;
            hasNewImageBeenProvided = true;
        } else if (product_image_url && product_image_url.trim() !== '') {
            newImagePath = product_image_url.trim();
            hasNewImageBeenProvided = true;
        } else if (product_image_url === '') { // If URL is explicitly cleared
            newImagePath = null;
            hasNewImageBeenProvided = true;
        }


        // 2. Delete old file if it was local and is being replaced or cleared
        // 2. Delete old file if it was local and is being replaced or cleared
        if (currentImage && (currentImage.startsWith('/resources/') || currentImage.startsWith('resources/')) && (hasNewImageBeenProvided && newImagePath !== currentImage)) {
            // Normalize path: Remove leading slash if present
            const relativePath = currentImage.startsWith('/') ? currentImage.slice(1) : currentImage;
            const absolutePath = path.join(__dirname, relativePath);

            console.log(`[Update] Attempting to delete old image: ${absolutePath}`);

            fs.unlink(absolutePath, (err) => {
                if (err) console.error('[Update] Error deleting old product image:', err);
                else console.log('[Update] Old image deleted successfully.');
            });
        }

        const updateQuery = `
            UPDATE product 
            SET product_name = ?, product_stock = ?, product_price = ?, product_notes = ?, product_image = ?
            WHERE id = ? AND email = ?
        `;

        db.query(updateQuery, [product_name, product_stock, product_price, product_notes, newImagePath, productId, email], (err, result) => {
            if (err) {
                console.error('Update product error:', err);
                return res.status(500).json({ success: false, message: 'Database error' });
            }
            res.json({ success: true, message: 'Product updated successfully' });
        });
    });
});

// Upload Profile Photo Endpoint
app.post('/api/user/upload-photo', isAuthenticated, upload.single('photo'), (req, res) => {
    if (!req.file) {
        return res.status(400).json({ success: false, message: 'No file uploaded' });
    }

    const email = req.session.user.email;
    const username = email.split('@')[0];
    const userFolder = path.join(__dirname, 'resources', username, 'profile');

    // Cleanup old files (keep only the new one)
    fs.readdir(userFolder, (err, files) => {
        if (err) console.error('Error reading dir:', err);
        else {
            files.forEach(file => {
                if (file !== req.file.filename) {
                    fs.unlink(path.join(userFolder, file), err => {
                        if (err) console.error('Error deleting old file:', err);
                    });
                }
            });
        }
    });

    // Update Database
    // Path stored in DB should be relative/web-accessible
    // resources/username/profile/filename
    const webPath = `/resources/${username}/profile/${req.file.filename}`;
    const userId = req.session.user.id;

    const query = 'UPDATE account SET shop_image = ? WHERE id = ?';
    db.query(query, [webPath, userId], (err, result) => {
        if (err) {
            console.error('Database update error:', err);
            return res.status(500).json({ success: false, message: 'Database error' });
        }

        // Update session
        req.session.user.shop_image = webPath;

        res.json({ success: true, message: 'Photo uploaded successfully', imagePath: webPath });
    });
});

// Get current user data API
app.get('/api/user', isAuthenticated, (req, res) => {
    res.json({
        success: true,
        user: {
            shop_name: req.session.user.shop_name,
            email: req.session.user.email,
            shop_image: req.session.user.shop_image // Include image path
        }
    });
});

// --- Order API ---

// Auto-migration for is_archived (safe add)
const migrationQuery = "ALTER TABLE customer_order ADD COLUMN is_archived BOOLEAN DEFAULT FALSE";
db.query(migrationQuery, (err) => {
    // Ignore error if column exists (Error 1060: Duplicate column name)
    if (err && err.code !== 'ER_DUP_FIELDNAME') {
        console.log('Migration note:', err.message);
    } else {
        console.log('Database migrated: is_archived column ensured.');
    }
});

// Get All Orders (Filtered)
app.get('/api/orders', isAuthenticated, (req, res) => {
    const isArchived = req.query.archived === 'true';
    const query = 'SELECT * FROM customer_order WHERE is_archived = ? ORDER BY date_order DESC, id DESC';

    db.query(query, [isArchived], (err, results) => {
        if (err) {
            console.error('Error fetching orders:', err);
            return res.status(500).json({ success: false, message: 'Database error' });
        }
        res.json({ success: true, orders: results });
    });
});

// Update Order Status
app.post('/api/order/update-status', isAuthenticated, (req, res) => {
    const { id, status } = req.body;

    if (!id || !status) {
        return res.status(400).json({ success: false, message: 'Missing fields' });
    }

    const query = 'UPDATE customer_order SET status_order = ? WHERE id = ?';
    db.query(query, [status, id], (err, result) => {
        if (err) {
            console.error('Error updating order status:', err);
            return res.status(500).json({ success: false, message: 'Database error' });
        }
        res.json({ success: true, message: 'Status updated successfully' });
    });
});

// Archive Order (Soft Delete)
app.post('/api/order/archive', isAuthenticated, (req, res) => {
    const { id } = req.body;

    if (!id) return res.status(400).json({ success: false, message: 'Missing ID' });

    const query = 'UPDATE customer_order SET is_archived = TRUE WHERE id = ?';
    db.query(query, [id], (err, result) => {
        if (err) {
            console.error('Error archiving order:', err);
            return res.status(500).json({ success: false, message: 'Database error' });
        }
        res.json({ success: true, message: 'Order archived successfully' });
    });
});

// Update user profile API
app.post('/api/user/update', isAuthenticated, (req, res) => {
    const { shop_name, email } = req.body;
    const userId = req.session.user.id; // Ensure your session has ID
    const query = 'UPDATE account SET shop_name = ?, email = ? WHERE id = ?';
    db.query(query, [shop_name, email, userId], (err, result) => {
        if (err) {
            console.error('Update error:', err);
            return res.status(500).json({ success: false, message: 'Database error' });
        }

        // Update session
        req.session.user.shop_name = shop_name;
        req.session.user.email = email;

        res.json({ success: true, message: 'Profile updated successfully' });
    });
});

// Get dashboard stats API
app.get('/api/stats', isAuthenticated, (req, res) => {
    const email = req.session.user.email;
    const productQuery = 'SELECT COUNT(*) as total_products, SUM(product_stock) as total_stock FROM product WHERE email = ?';
    const orderQuery = `
        SELECT 
            SUM(CASE WHEN is_archived = TRUE THEN 1 ELSE 0 END) as total_completed,
            SUM(CASE WHEN status_order = 'Menunggu Pembayaran' AND is_archived = FALSE THEN 1 ELSE 0 END) as total_pending
        FROM customer_order
    `;

    db.query(productQuery, [email], (err, productResults) => {
        if (err) {
            console.error('Stats query error (Products):', err);
            return res.status(500).json({ success: false, message: 'Database error' });
        }

        db.query(orderQuery, (err, orderResults) => {
            if (err) {
                console.error('Stats query error (Orders):', err);
                return res.status(500).json({ success: false, message: 'Database error' });
            }

            const pStats = productResults[0];
            const oStats = orderResults[0] || { total_completed: 0, total_pending: 0 };

            res.json({
                success: true,
                total_products: pStats.total_products || 0,
                total_stock: pStats.total_stock || 0,
                rating: 'N/A', // Static as requested
                total_completed: oStats.total_completed || 0,
                total_pending: oStats.total_pending || 0
            });
        });
    });
});

// Login Route
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
            res.json({
                success: true,
                message: 'Login successful',
                shop_name: results[0].shop_name
            });
        } else {
            res.status(401).json({ success: false, message: 'Invalid email or password' });
        }
    });
});

// Protected Dashboard Route
app.get('/dashboard', isAuthenticated, (req, res) => {
    res.set('Cache-Control', 'no-store');
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

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
