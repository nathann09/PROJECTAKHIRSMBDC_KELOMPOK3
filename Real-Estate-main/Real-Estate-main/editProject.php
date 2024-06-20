<?php
    // Include database connection
    include('indexDB.php');

    // Initialize variables
    $projectId = null;
    $project = [];

    // Check if project ID is provided in URL
    if(isset($_GET['id'])) {
        $projectId = $_GET['id'];

        // Prepare SQL statement to fetch project details
        $query = "SELECT * FROM upcoming_projects WHERE upid = ?";
        
        // Prepare and bind parameters to avoid SQL injection
        $stmt = $conn->prepare($query);
        $stmt->bind_param('i', $projectId);
        
        // Execute query
        $stmt->execute();
        
        // Get result
        $result = $stmt->get_result();

        // Check if project exists
        if($result->num_rows > 0) {
            $project = $result->fetch_assoc();
        } else {
            // Display popup if project not found
            echo '<script>alert("Project not found.");
            window.location.href = "editProject.php";
            </script>';
            exit; // Stop further execution if project not found
        }

        // Close prepared statement
        $stmt->close();
    } else {
        // Display popup if project ID not provided
        echo '<script>alert("Project ID not provided.");</script>';
        exit; // Stop further execution if project ID not provided
    }
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Project</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h2>Edit Project</h2>
        <form action="updateProject.php" method="post">
            <div class="form-group">
                <label for="name">Name of Builder:</label>
                <input type="text" class="form-control" id="name" name="name" value="<?php echo isset($project['name']) ? htmlspecialchars($project['name']) : ''; ?>" >
            </div>
            <div class="form-group">
                <label for="location">Location:</label>
                <input type="text" class="form-control" id="location" name="location" value="<?php echo htmlspecialchars($project['location']); ?>">
            </div>
            <div class="form-group">
                <label for="city">City:</label>
                <input type="text" class="form-control" id="city" name="city" value="<?php echo htmlspecialchars($project['city']); ?>">
            </div>
            <div class="form-group">
                <label for="comp_time">Estimated Completion Time (Months):</label>
                <input type="text" class="form-control" id="comp_time" name="comp_time" value="<?php echo htmlspecialchars($project['comp_time']); ?>">
            </div>
            <input type="hidden" name="project_id" value="<?php echo htmlspecialchars($projectId); ?>">
            <button type="submit" class="btn btn-primary">Update Project</button>
        </form>
    </div>

    <!-- JavaScript untuk menampilkan popup -->
    <script>
    // Cek jika ada pesan dari query string (contoh: error atau success)
    window.onload = function() {
        var urlParams = new URLSearchParams(window.location.search);
        var msg = urlParams.get('msg');
        if (msg) {
            alert(msg);
            // Kembali ke halaman editProject.php setelah alert ditutup
            window.location.href = 'editProject.php?id=<?php echo $projectId; ?>';
        }
    };
</script>

</body>
</html>
