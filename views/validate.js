function validateForm() {
    var taskNum = document.forms["newTask"]["num"].value;
    var taskDate = document.forms["newTask"]["date"].value;
    var newTask = document.forms["newTask"]["task"].value;

    if (taskNum == "" || taskDate == "" || newTask == "") {
        alert("All fields are compulsory. Please fill up missing fields.")
    }
}