<?php
session_start();
include('indexDB.php');

// Check if all POST parameters are set
if (isset($_POST['Bankname'], $_POST['Loandetails'], $_POST['Chequenumber'], $_POST['Paymentoption'])) {
    // Assign POST data to variables
    $Bname = $_POST['Bankname'];
    $loandetails = $_POST['Loandetails'];
    $cnum = $_POST['Chequenumber'];
    $popt = $_POST['Paymentoption'];

    // Retrieve data from session
    $fid = $_SESSION["flat_id"];
    $bname = $_SESSION["buyer"];

    // Retrieve UID and bid from database
    $s1 = "SELECT uid, bid FROM flat WHERE flat_id = ?";
    $stmt1 = $conn->prepare($s1);
    $stmt1->bind_param("i", $fid);
    $stmt1->execute();
    $stmt1->store_result();
    
    // Check if there are results
    if ($stmt1->num_rows > 0) {
        $stmt1->bind_result($uid, $bid);
        $stmt1->fetch();

        // Determine the value of $j based on $bid
        $j = ($bid === null) ? $uid : $bid;

        // Insert data into payment table
        $sql = "INSERT INTO payment (UID, buyer, Bank_name, Loan_details, cheque_number, payment_opt) 
                VALUES (?, ?, ?, ?, ?, ?)";
        
        // Prepare statement
        $stmt = $conn->prepare($sql);
        
        if ($stmt) {
            // Bind parameters
            $stmt->bind_param("isssss", $j, $bname, $Bname, $loandetails, $cnum, $popt);
            
            // Execute statement
            if ($stmt->execute()) {
                // Get last inserted ID
                $last_id = $stmt->insert_id;
                
                // Construct new row for HTML table
                $new_row = "<tr>";
                $new_row .= "<td>" . htmlspecialchars($Bname) . "</td>";
                $new_row .= "<td>" . htmlspecialchars($loandetails) . "</td>";
                $new_row .= "<td>" . htmlspecialchars($cnum) . "</td>";
                $new_row .= "<td>" . htmlspecialchars($popt) . "</td>";
                $new_row .= "<td><button class='btn btn-sm btn-danger'><i class='fa fa-trash'></i> Hapus</button>";
                $new_row .= "<button class='btn btn-sm btn-primary'><i class='fa fa-edit'></i> Edit</button></td>";
                $new_row .= "</tr>";
                
                // Inject new row into HTML table using JavaScript
                echo "<script>";
                echo "$(document).ready(function() {";
                echo "$('.hero-text table').append('" . $new_row . "');"; // Using class .hero-text to select table
                echo "});";
                echo "</script>";
                
                // Success message and redirection
                echo "<script type='text/javascript'>";
                echo "alert('Data berhasil ditambahkan.');";
                echo "window.location.href = 'payment.php';";
                echo "</script>";
            } else {
                // Error executing statement
                echo "ERROR: Tidak dapat menjalankan $sql. " . $stmt->error;
            }
            
            // Close statement
            $stmt->close();
        } else {
            // Error preparing statement
            echo "ERROR: Tidak dapat mempersiapkan statement. " . $conn->error;
        }
        
        // Close statement and connection
        $stmt1->close();
        $conn->close();
    } else {
        // No results found in query for UID and bid
        echo "ERROR: Data tidak ditemukan untuk flat_id = $fid";
    }
} else {
    // Required POST data not found
    echo "ERROR: Harap lengkapi semua kolom.";
}
?>
