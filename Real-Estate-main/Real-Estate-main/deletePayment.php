<?php
if (isset($_POST['delete_uid'])) {
    $uidToDelete = $_POST['delete_uid'];

    include('indexDB.php'); // Koneksi ke database

    $sql = "CALL DeletePayment(?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $uidToDelete);

    if ($stmt->execute()) {
        echo "success";
    } else {
        echo "error: " . $stmt->error;
    }

    $stmt->close();
    $conn->close();
}
?>
