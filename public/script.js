document.getElementById('loginForm').addEventListener('submit', async function (e) {
    e.preventDefault();

    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const alertMessage = document.getElementById('alertMessage');

    alertMessage.innerHTML = ''; // Clear previous messages

    try {
        const response = await fetch('/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ email, password })
        });

        const data = await response.json();

        if (response.ok) {
            const welcomeMessage = data.shop_name
                ? `Selamat datang ${data.shop_name}!`
                : data.message;

            alertMessage.innerHTML = `<div class="alert alert-success d-flex align-items-center" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <div>${welcomeMessage}</div>
            </div>`;
            setTimeout(() => {
                window.location.href = '/dashboard';
            }, 3000); // 3s delay to show success message
        } else {
            alertMessage.innerHTML = `<div class="alert alert-danger d-flex align-items-center" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <div>${data.message}</div>
            </div>`;
        }

    } catch (error) {
        console.error('Error:', error);
        alertMessage.innerHTML = `<div class="alert alert-danger" role="alert">An error occurred. Please try again.</div>`;
    }
});

// Theme Toggle Logic
const themeToggle = document.getElementById('themeToggle');
const themeIcon = document.getElementById('themeIcon');
const body = document.body;

// Check local storage for saved theme
const savedTheme = localStorage.getItem('theme');
if (savedTheme === 'dark') {
    body.classList.add('dark-mode');
    themeIcon.classList.replace('bi-moon-fill', 'bi-sun-fill');
}

themeToggle.addEventListener('click', () => {
    body.classList.toggle('dark-mode');

    // Toggle Icon
    if (body.classList.contains('dark-mode')) {
        themeIcon.classList.replace('bi-moon-fill', 'bi-sun-fill');
        localStorage.setItem('theme', 'dark');
    } else {
        themeIcon.classList.replace('bi-sun-fill', 'bi-moon-fill');
        localStorage.setItem('theme', 'light');
    }
});

// Support Form Logic
document.getElementById('supportForm').addEventListener('submit', async function (e) {
    e.preventDefault();

    const sellerName = document.getElementById('sellerName').value;
    const email = document.getElementById('supportEmail').value;
    const issue = document.getElementById('issue').value;
    const supportAlert = document.getElementById('supportAlert');

    try {
        supportAlert.innerHTML = '<div class="text-primary">Sending...</div>';

        const response = await fetch('/support', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ sellerName, email, issue })
        });

        const data = await response.json();

        if (response.ok) {
            supportAlert.innerHTML = `<div class="text-success">Sent! Ticket ID: <strong>${data.ticketId}</strong></div>`;
            document.getElementById('supportForm').reset();
            setTimeout(() => {
                document.getElementById('supportCard').style.display = 'none';
                supportAlert.innerHTML = '';
            }, 5000); // Longer timeout so they can read the ID
        } else {
            supportAlert.innerHTML = `<div class="text-danger">${data.message}</div>`;
        }
    } catch (error) {
        console.error('Error:', error);
        supportAlert.innerHTML = `<div class="text-danger">Failed to send.</div>`;
    }
});

// Toggle Support Widget
const supportToggle = document.getElementById('supportToggle');
const supportCard = document.getElementById('supportCard');
const closeSupport = document.getElementById('closeSupport');

supportToggle.addEventListener('click', () => {
    if (supportCard.style.display === 'none') {
        supportCard.style.display = 'block';
    } else {
        supportCard.style.display = 'none';
    }
});

closeSupport.addEventListener('click', () => {
    supportCard.style.display = 'none';
});

