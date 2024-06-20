<?php
    // Include database connection
    include('indexDB.php');

    // Check if form is submitted using POST method
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        // Initialize variables for error handling and success redirection
        $redirect = "editProject.php";
        $errorRedirect = $redirect . "?error=1";
        $successRedirect = $redirect . "?success=1";

        // Validate project ID
        if (!isset($_POST['project_id']) || empty($_POST['project_id'])) {
            header("Location: " . $errorRedirect . "&msg=" . urlencode("Project ID is required"));
            exit(); // This exit() might cause unreachable code warning
        }

        // Validate and sanitize inputs
        $projectId = $_POST['project_id'];
        $location = isset($_POST['location']) ? mysqli_real_escape_string($conn, $_POST['location']) : '';
        $city = isset($_POST['city']) ? mysqli_real_escape_string($conn, $_POST['city']) : '';
        $comp_time = isset($_POST['comp_time']) ? mysqli_real_escape_string($conn, $_POST['comp_time']) : '';

        // Prepare SQL update statement
        $query = "UPDATE upcoming_projects SET location = ?, city = ?, comp_time = ? WHERE upid = ?";

        // Prepare and bind parameters
        $stmt = $conn->prepare($query);
        $stmt->bind_param('sssi', $location, $city, $comp_time, $projectId);

        // Execute statement
        if ($stmt->execute()) {
            // Redirect with success message
            header("Location: " . $successRedirect);
            exit(); // This exit() might cause unreachable code warning
        } else {
            // Redirect with error message
            header("Location: " . $errorRedirect . "&msg=" . urlencode("Failed to update project"));
            exit(); // This exit() might cause unreachable code warning
        }

        // Close statement
        $stmt->close(); // This close() might cause unreachable code warning
    } else {
        // If not submitted via POST method, redirect to editProject.php
        header("Location: " . $redirect);
        exit(); // This exit() might cause unreachable code warning
    }

    // Close connection
    mysqli_close($conn); // This close() might cause unreachable code warning
?>
