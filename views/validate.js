function validateForm() {
    var taskNum = document.forms["newTask"]["num"].value;
    var newTask = document.forms["newTask"]["task"].value;

    if (taskNum == "" || newTask == "") {
        alert("All fields are compulsory. Please fill up missing fields.")
    }
}