<?php
// Include file to connect to database
include('indexDB.php');

// Check if ID is set
if(isset($_GET['id'])) {
    $id = $_GET['id'];
    
    // Prepare and bind query to delete record
    $query = "DELETE FROM packers_movers WHERE pid = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("i", $id);
    
    // Execute query
    if($stmt->execute()) {
        // Redirect to PackersAndMovers.php after successful deletion
        header("Location: PackersAndMovers.php");
        exit();
    } else {
        echo "Kesalahan saat menghapus data: " . $conn->error;
    }
} else {
    echo "ID tidak diberikan!";
}
?>
