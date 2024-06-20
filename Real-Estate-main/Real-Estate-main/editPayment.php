<?php
include('indexDB.php'); // Include database connection

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Validate and sanitize input data (example of basic validation)
    $uid = isset($_POST['UID']) ? intval($_POST['UID']) : 0;
    $bankname = isset($_POST['Bankname']) ? htmlspecialchars($_POST['Bankname']) : '';
    $amount = isset($_POST['Amount']) ? floatval($_POST['Amount']) : 0.0;
    $loandetails = isset($_POST['Loandetails']) ? htmlspecialchars($_POST['Loandetails']) : '';
    $chequenumber = isset($_POST['Chequenumber']) ? htmlspecialchars($_POST['Chequenumber']) : '';
    $paymentoption = isset($_POST['Paymentoption']) ? intval($_POST['Paymentoption']) : 0;

    // Prepare and execute the update query
    $query = "UPDATE payment SET Bank_name = ?, amount = ?, Loan_details = ?, cheque_number = ?, payment_opt = ? WHERE UID = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("sissii", $bankname, $amount, $loandetails, $chequenumber, $paymentoption, $uid);

    if ($stmt->execute()) {
        // Successful update
        echo '<script>alert("Data berhasil diubah."); window.location.reload();</script>';
    } else {
        // Error in execution
        echo '<script>alert("Gagal mengubah data: ' . $stmt->error . '"); window.location.reload();</script>';
    }

    // Close statement and connection
    $stmt->close();
    $conn->close(); 
}
?>
