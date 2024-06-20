<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>HOUSING-CO</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
    <!-- Font Awesome CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <!-- Custom Stylesheet -->
    <link rel="stylesheet" href="css/style.css">
    <!-- jQuery -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <!-- Bootstrap JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>
    <style>
        body {
            background-repeat: no-repeat;
            background-image: url("img/service-bg.jpg");
            background-size: cover;
            background-attachment: fixed;
            color: white;
        }

        input[type=text],
        input[type=date],
        input[type=password] {
            width: 100%;
            padding: 12px 20px;
            margin: 8px 0;
            box-sizing: border-box;
            background-color: #e0e0d1;
            color: black;
            border: none;
        }

        input[type=submit],
        input[type=reset] {
            background-color: #e0e0d1;
            border: none;
            color: black;
            padding: 16px 32px;
            text-decoration: none;
            margin: 4px 2px;
            cursor: pointer;
            font-weight: bold;
        }

        select,
        textarea {
            width: 100%;
            padding: 12px 20px;
            margin: 8px 0;
            box-sizing: border-box;
            background-color: #e0e0d1;
            color: black;
            border: none;
        }

        table {
            background-color: black;
            border-collapse: collapse;
            width: 70%;
            /* Lebar tabel */
            margin: auto;
            color: white;
        }

        table th,
        table td {
            border: 2px solid navy;
            padding: 10px;
            text-align: left;
            max-width: 200px;
            /* Lebar maksimum kolom */
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        table th {
            background-color: #333;
            color: white;
        }

        form {
            opacity: 0.7;
        }

        td {
            font-weight: bold;
        }

        span {
            color: red;
        }
    </style>
</head>

<body>
    <header class="header-section">
        <div class="header-top">
            <div class="container">
                <div class="row">
                    <div class="col-10">
                        <h1>DashBoard</h1>
                    </div>
                    <div class="col-2">
                        <?php
                        session_start(); // Mulai sesi
                        if (isset($_SESSION['username'])) {
                            echo htmlspecialchars($_SESSION['username']); // Tampilkan username dari sesi
                        ?>
                            <a href="logout.php"><i class="fa fa-sign-in"></i> Logout</a>
                        <?php
                        } else {
                            // Alihkan ke halaman login atau tampilkan pesan kesalahan
                            header("Location: login.php");
                            exit();
                        }
                        ?>
                    </div>
                </div>
            </div>
        </div>
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <div class="site-navbar">
                        <a href="index.html" class="site-logo"><img src="img/logo1.png" alt=""></a>
                        <div class="nav-switch">
                            <i class="fa fa-bars"></i>
                        </div>
                        <ul class="main-menu">
                            <li><a href="about.html">TENTANG KAMI</a></li>
                            <li><a href="PackersAndMovers.php">Packer dan Movers</a></li>
                            <li><a href="contact.html">Kontak</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </header>
    <section class="hero-section set-bg" data-setbg="img/bg.jpg">
        <div class="container hero-text text-white">
            <table>
                <tr>
                    <th style="min-width: 200px;">Nama Bank</th>
                    <th style="min-width: 100px;">Jumlah</th>
                    <th style="min-width: 150px;">Detail Pinjaman</th>
                    <th style="min-width: 150px;">Opsi Pembayaran</th>
                    <th style="min-width: 120px;">Nomor Cek</th>
                    <th style="min-width: 150px;">Aksi</th>
                </tr>
                <?php
                include('indexDB.php');

                // Ambil flat_id dari session
                $fid = $_SESSION["flat_id"];

                // Query untuk mengambil data dari database
                $query = "SELECT UID, Bank_name, amount, Loan_details, cheque_number, payment_opt FROM payment";
                $stmt = $conn->prepare($query);
                // $stmt->bind_param("i", $fid);
                $stmt->execute();
                $result = $stmt->get_result();

                // Loop untuk menampilkan setiap baris data
                while ($row = $result->fetch_assoc()) {
                    echo "<tr>";
                    echo "<td>" . htmlspecialchars($row['Bank_name']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['amount']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['Loan_details']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['payment_opt']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['cheque_number']) . "</td>";
                    echo "<td>";
                    echo "<button class='btn btn-sm btn-danger delete-btn' data-uid='" . $row['UID'] . "'><i class='fa fa-trash'></i> Hapus</button>";
                    echo "<button class='btn btn-sm btn-primary edit-btn' data-uid='" . $row['UID'] . "' data-bankname='" . htmlspecialchars($row['Bank_name']) . "' data-amount='" . htmlspecialchars($row['amount']) . "' data-loandetails='" . htmlspecialchars($row['Loan_details']) . "' data-chequenumber='" . htmlspecialchars($row['cheque_number']) . "' data-paymentopt='" . htmlspecialchars($row['payment_opt']) . "'><i class='fa fa-edit'></i> Edit</button>";
                    echo "</td>";
                    echo "</tr>";
                }

                // Jika tidak ada data, bisa ditampilkan pesan atau aksi lainnya
                if ($result->num_rows === 0) {
                    echo "<tr><td colspan='6'>Tidak ada data yang tersedia</td></tr>";
                }

                // Menutup statement dan koneksi database
                $stmt->close();
                $conn->close();
                ?>
            </table>
        </div>
    </section>
    <form id="paymentForm" method="post" action="pay.php" onsubmit="return validateForm();">
        <table cellpadding="7" border="0" align="center" cellspacing="2">
            <tr>
                <td colspan="2">
                    <center><img src="img/logo1.png" alt="Logo"></center>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <center>
                        <font size="5"><b>Detail Pembayaran</b></font>
                    </center>
                </td>
            </tr>
            <tr>
                <td><b>Nama Bank:</b></td>
                <td><input type="text" name="Bankname" size="30"></td>
            </tr>
            <tr>
                <td><b>Jumlah:</b></td>
                <td><input type="text" name="Amount" size="30"></td>
            </tr>
            <tr>
                <td><b>Detail Pinjaman:</b></td>
                <td><input type="text" name="Loandetails" size="30"></td>
            </tr>
            <tr>
                <td><b>Nomor Cek:</b></td>
                <td><input type="text" name="Chequenumber" size="30"></td>
            </tr>
            <tr>
                <td><b>Opsi Pembayaran:</b></td>
                <td><input type="text" name="Paymentoption" size="30"></td>
            </tr>
            <tr>
                <td><input type="reset" value="Reset"></td>
                <td><input type="submit" value="Submit"></td>
            </tr>
        </table>
        <input type="hidden" name="UID" id="paymentUID">
    </form>

    <script>
        function validateForm() {
            var bankName = document.forms["paymentForm"]["Bankname"].value;
            var amount = document.forms["paymentForm"]["Amount"].value;
            var loanDetails = document.forms["paymentForm"]["Loandetails"].value;
            var chequeNumber = document.forms["paymentForm"]["Chequenumber"].value;
            var paymentOption = document.forms["paymentForm"]["Paymentoption"].value;
            var uid = document.forms["paymentForm"]["UID"].value;

            if (bankName == "" || amount == "" || loanDetails == "" || chequeNumber == "" || paymentOption == "") {
                alert("Harap isi semua kolom.");
                return false;
            }

            // AJAX untuk mengirim data formulir
            $.ajax({
                type: "POST",
                url: uid ? "editPayment.php" : "pay.php",
                data: $("#paymentForm").serialize(),
                success: function(response) {
                    // Update tabel dengan menampilkan data terbaru
                    $(".hero-text").html(response); // Mengganti isi hero-text dengan response
                    document.getElementById("paymentForm").reset(); // Mengatur formulir kembali ke keadaan awal
                }
            });

            return false; // Mencegah pengiriman formulir normal
        }

        // Handler untuk tombol hapus
        $(document).on('click', '.delete-btn', function() {
            var uid = $(this).data('uid');

            if (confirm("Apakah Anda yakin ingin menghapus data ini?")) {
                $.ajax({
                    type: "POST",
                    url: "deletePayment.php",
                    data: { delete_uid: uid },
                    success: function(response) {
                        if (response.trim() == "success") {
                            location.reload();
                        } else {
                            alert("Terjadi kesalahan: " + response);
                        }
                    }
                });
            }
        });

        // Handler untuk tombol edit
        $(document).on('click', '.edit-btn', function() {
            var uid = $(this).data('uid');
            var bankname = $(this).data('bankname');
            var amount = $(this).data('amount');
            var loandetails = $(this).data('loandetails');
            var chequenumber = $(this).data('chequenumber');
            var paymentopt = $(this).data('paymentopt');

            document.forms["paymentForm"]["Bankname"].value = bankname;
            document.forms["paymentForm"]["Amount"].value = amount;
            document.forms["paymentForm"]["Loandetails"].value = loandetails;
            document.forms["paymentForm"]["Chequenumber"].value = chequenumber;
            document.forms["paymentForm"]["Paymentoption"].value = paymentopt;
            document.getElementById("paymentUID").value = uid;

            $('html, body').animate({
                scrollTop: $("#paymentForm").offset().top
            }, 500);
        });
    </script>
</body>

</html>
