function loginCheck() {
  // Login Property
  const username = document.getElementById("inputUsername").value.trim();
  const password = document.getElementById("inputPassword").value.trim();

  // Alert Property
  const alertError = document.getElementById("alertError")
  const alertSuccess = document.getElementById("alertSuccess")

  // Prevent zero value
  if (username == "" && password == ""){
    alert("Please fill username and password!")
  }else if (username == "" ) {
    alert("Please fill username!")
  }else if (password == "") { 
    alert("Please fill password!")
  }

  // Auth Check (temp!)
  if (username == "123" && password == "123") {
    alertSuccess.classList.remove("d-none"); // Show success alert
    alertError.classList.add("d-none"); // Hide error alert
    // After 2 seconds will be hide success alert
    setTimeout(() => {
      alertSuccess.classList.add("d-none");
      window.location.href = "admin.html"
    }, 2000);
  }else{
    alertError.classList.remove("d-none"); // Show error alert
    alertSuccess.classList.add("d-none"); // Hide success alert
    // After 2 seconds will be hide error alert
    setTimeout(() => {
      alertError.classList.add("d-none");
    }, 2000);
  }
}