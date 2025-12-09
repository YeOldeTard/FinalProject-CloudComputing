const get_username = document.getElementById('input_email')
const get_password = document.getElementById('input_password')
const stats_login_btn = document.getElementById('login_btn')
const get_alert = document.getElementById('alert_login')
const get_alert_msg = document.getElementById('alert_msg')
const get_alert_icon = document.getElementById('icon_alert')

stats_login_btn.addEventListener('click', async function() {
  const username = get_username.value.trim()
  const password = get_password.value.trim()
  
  try {
    const response = await fetch('/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password })
    });
    const data = await response.json();
    
    if (data.success) {
      get_alert.classList.remove('d-none', 'alert-danger')
      get_alert.classList.add('alert-success')
      get_alert_icon.setAttribute('xlink:href', '#check-circle-fill')
      get_alert_msg.textContent = data.message
      
      setTimeout(() => {
        get_username.value = ''; get_password.value = ''; get_alert.classList.add('d-none')
      }, 4000);
    } else {
      get_alert.classList.remove('d-none', 'alert-success')
      get_alert.classList.add('alert-danger')
      get_alert_icon.setAttribute('xlink:href', '#exclamation-triangle-fill')
      get_alert_msg.textContent = data.message
      
      setTimeout(() => {
        get_username.value = ''; get_password.value = ''; get_alert.classList.add('d-none')
      }, 4000);
    }
  } catch (error) {
    get_alert.classList.remove('d-none', 'alert-success')
    get_alert.classList.add('alert-danger')
    get_alert_msg.textContent = 'Koneksi error!'
  }
});
