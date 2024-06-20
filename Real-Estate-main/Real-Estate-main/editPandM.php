<?php
include('indexDB.php');

$message = ""; // Variable to store message
$redirect = false; // Variable to check if redirect is needed

if(isset($_GET['id'])) {
    $id = $_GET['id'];
    
    // Siapkan dan ikat query SELECT dengan nama kolom yang benar
    $query = "SELECT * FROM packers_movers WHERE pid = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $result = $stmt->get_result();

    if($result->num_rows == 1) {
        $row = $result->fetch_assoc();
        $name_org = $row['name_org'];
        $contact_no = $row['contact_no'];
        $email_id = $row['email_id'];
    } else {
        echo "Data tidak ditemukan!";
        exit();
    }
} else {
    echo "ID tidak diberikan!";
    exit();
}

// Jika form dikirimkan
if($_SERVER["REQUEST_METHOD"] == "POST") {
    $name_org_new = $_POST['name_org'];
    $contact_no_new = $_POST['contact_no'];
    $email_id_new = $_POST['email_id'];

    // Siapkan dan ikat query UPDATE dengan nama kolom yang benar
    $query = "UPDATE packers_movers SET name_org = ?, contact_no = ?, email_id = ? WHERE pid = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("sssi", $name_org_new, $contact_no_new, $email_id_new, $id);
    
    if($stmt->execute()) {
        $message = "Data berhasil diperbarui";
        $redirect = true; // Set redirect to true when update is successful
    } else {
        $message = "Kesalahan saat memperbarui data: " . $conn->error;
    }
}
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Data Pindahan dan Pengangkut</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
        }
        h2 {
            margin-top: 0;
            text-align: center;
        }
        label {
            display: block;
            margin: 15px 0 5px;
        }
        input[type="text"] {
            width: calc(100% - 22px);
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"] {
            width: 100%;
            background-color: #4CAF50;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
    </style>
    <script>
        window.onload = function() {
            var message = "<?php echo $message; ?>";
            var redirect = <?php echo $redirect ? 'true' : 'false'; ?>;
            if (message) {
                alert(message);
                if (redirect) {
                    window.location.href = 'PackersAndMovers.php';
                }
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>Edit Data Pindahan dan Pengangkut</h2>
        <form method="post">
            <label for="name_org">Nama Organisasi:</label>
            <input type="text" id="name_org" name="name_org" value="<?php echo htmlspecialchars($name_org); ?>" required>
            
            <label for="contact_no">Nomor Kontak:</label>
            <input type="text" id="contact_no" name="contact_no" value="<?php echo htmlspecialchars($contact_no); ?>" required>
            
            <label for="email_id">Email:</label>
            <input type="text" id="email_id" name="email_id" value="<?php echo htmlspecialchars($email_id); ?>" required>
            
            <input type="submit" value="Perbarui Data">
        </form>
    </div>
</body>
</html>
