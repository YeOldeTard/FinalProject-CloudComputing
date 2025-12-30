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

// Configure Menu Items Storage
const menuStorage = multer.diskStorage({
    destination: function (req, file, cb) {
        // Direct to public/assets/images as requested
        const dir = path.join(__dirname, 'public', 'assets', 'images');
        fs.mkdirSync(dir, { recursive: true });
        cb(null, dir);
    },
    filename: function (req, file, cb) {
        cb(null, file.originalname);
    }
});

const uploadMenu = multer({ storage: menuStorage });

// Add Product Endpoint (Modified for menu_items)
app.post('/api/product/add', isAuthenticated, uploadMenu.single('product_image'), (req, res) => {
    const { product_name, product_price } = req.body;
    // const email = req.session.user.email; // Ignored for global menu add

    if (!product_name || !product_price) {
        return res.status(400).json({ success: false, message: 'Required fields missing' });
    }

    let imagePath = null;
    if (req.file) {
        imagePath = `assets/images/${req.file.originalname}`;
    } else if (req.body.product_image_url) {
        imagePath = req.body.product_image_url.trim();
    }

    // Custom Logic: Get Max ID and Max StoreID
    const getMaxIdQuery = 'SELECT MAX(id) as max_id FROM menu_items';
    const getMaxStoreIdQuery = 'SELECT MAX(store_id) as max_store_id FROM menu_items';

    db.query(getMaxIdQuery, (err, idResult) => {
        if (err) return res.status(500).json({ success: false, message: 'DB Error (Max ID)' });

        const newId = (idResult[0].max_id || 0) + 1;

        db.query(getMaxStoreIdQuery, (err, storeResult) => {
            if (err) return res.status(500).json({ success: false, message: 'DB Error (Max StoreID)' });

            const newStoreId = (storeResult[0].max_store_id || 0) + 1;

            const insertQuery = 'INSERT INTO menu_items (id, store_id, name, price, image) VALUES (?, ?, ?, ?, ?)';

            db.query(insertQuery, [newId, newStoreId, product_name, product_price, imagePath], (err, result) => {
                if (err) {
                    console.error('Add menu item error:', err);
                    return res.status(500).json({ success: false, message: 'Database error' });
                }
                res.json({ success: true, message: 'Product added successfully' });
            });
        });
    });
});



// Get User Products (List for Dropdown) - Now fetching menu_items
app.get('/api/user/products', isAuthenticated, (req, res) => {
    // const email = req.session.user.email; // Ignored for global menu access
    const query = 'SELECT * FROM menu_items ORDER BY id ASC';

    db.query(query, (err, results) => {
        if (err) {
            console.error('Get products error:', err);
            return res.status(500).json({ success: false, message: 'Database error' });
        }
        res.json({ success: true, products: results });
    });
});

// Delete Product Endpoint (Skipping full migration for now as focus is Update. Keeping generic error if used on menu_items without logic change)
app.delete('/api/product/:id', isAuthenticated, (req, res) => {
    // Legacy logic... or should we disable? 
    // Allowing delete might be dangerous if logic mismatches. 
    // Returning error for safety until requested.
    // Delete from menu_items
    const deleteQuery = 'DELETE FROM menu_items WHERE id = ?';
    db.query(deleteQuery, [req.params.id], (err, result) => {
        if (err) {
            console.error('Delete menu item error:', err);
            return res.status(500).json({ success: false, message: 'Database error' });
        }
        res.json({ success: true, message: 'Product deleted successfully' });
    });
});

// Update Product Endpoint - Now updating menu_items
app.post('/api/product/update/:id', isAuthenticated, uploadMenu.single('product_image'), (req, res) => {
    const productId = req.params.id;
    // const email = req.session.user.email; // menu_items doesn't have email owner check here
    const { product_name, product_price, product_image_url } = req.body;

    // Validation
    if (!product_name || !product_price) {
        return res.status(400).json({ success: false, message: 'Please fill in all required fields' });
    }

    // 1. Get current image
    const getQuery = 'SELECT image FROM menu_items WHERE id = ?';
    db.query(getQuery, [productId], (err, results) => {
        if (err) {
            console.error('Get product for update error:', err);
            return res.status(500).json({ success: false, message: 'Database error' });
        }
        if (results.length === 0) {
            return res.status(404).json({ success: false, message: 'Product not found' });
        }

        const currentImage = results[0].image;
        let newImagePath = currentImage;
        const email = req.session.user.email;
        const username = email.split('@')[0];

        // Determine new image
        if (req.file) {
            newImagePath = `assets/images/${req.file.originalname}`; // Using simple path as per DB schema
        } else if (product_image_url && product_image_url.trim() !== '') {
            newImagePath = product_image_url.trim();
        }

        // Note: Not deleting old images for menu_items to avoid breaking other references or assets

        const updateQuery = `
            UPDATE menu_items 
            SET name = ?, price = ?, image = ?
            WHERE id = ?
        `;

        db.query(updateQuery, [product_name, product_price, newImagePath, productId], (err, result) => {
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
// Get All Orders (Filtered & Paginated & Aggregated)
app.get('/api/orders', isAuthenticated, (req, res) => {
    const isArchived = req.query.archived === 'true';
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10; // Default 10 items per page
    const offset = (page - 1) * limit;

    // Logic Change: 
    // archived=false (Active View) -> Showing Non-Delivered Orders (Wait, Process, etc.)
    // archived=true (History View) -> Showing Delivered or Archived Orders

    let whereClause = '';
    let params = [];

    if (isArchived) {
        // History: Delivered OR Archived
        whereClause = "(status_order = 'Delivered' OR is_archived = 1)";
    } else {
        // Active: Not Delivered AND Not Archived
        whereClause = "(status_order != 'Delivered' AND is_archived = 0)";
    }

    const query = `
        SELECT 
            MIN(id) as id, -- Keep one ID for key purposes
            order_id,
            customer,
            date_order,
            product_ordered,
            SUM(quantity) as quantity,
            SUM(total_price) as total_price,
            status_order,
            is_archived
        FROM customer_order 
        WHERE ${whereClause}
        GROUP BY order_id, product_ordered, date_order, customer, status_order, is_archived
        ORDER BY date_order DESC, MAX(id) DESC
        LIMIT ? OFFSET ?
    `;

    // Params for LIMIT and OFFSET
    params.push(limit, offset);

    db.query(query, params, (err, results) => {
        if (err) {
            console.error('Error fetching orders:', err);
            return res.status(500).json({ success: false, message: 'Database error' });
        }
        res.json({ success: true, orders: results, page, limit });
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
    // const email = req.session.user.email; // No longer needed for global menu_items count
    const productQuery = 'SELECT COUNT(*) as total_products FROM menu_items';
    const orderQuery = `
        SELECT 
            SUM(CASE WHEN status_order = 'Delivered' THEN 1 ELSE 0 END) as total_completed,
            SUM(CASE WHEN status_order != 'Delivered' THEN 1 ELSE 0 END) as total_pending,
            SUM(CASE WHEN status_order = 'WAITING_SPLIT_PAYMENT' THEN 1 ELSE 0 END) as total_waiting_split,
            SUM(CASE WHEN status_order = 'Order_Confirmed' THEN 1 ELSE 0 END) as total_confirmed
        FROM customer_order
    `;

    db.query(productQuery, (err, productResults) => {
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
            const oStats = orderResults[0] || { total_completed: 0, total_pending: 0, total_waiting_split: 0, total_confirmed: 0 };

            res.json({
                success: true,
                total_products: pStats.total_products || 0,
                total_completed: oStats.total_completed || 0,
                total_pending: oStats.total_pending || 0,
                total_waiting_split: oStats.total_waiting_split || 0,
                total_confirmed: oStats.total_confirmed || 0
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
