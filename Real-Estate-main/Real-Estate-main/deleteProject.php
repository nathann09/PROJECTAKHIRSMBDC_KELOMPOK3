<?php
// Pastikan session dimulai sebelum menggunakan $_SESSION
session_start();

// Periksa apakah pengguna sudah masuk atau belum, jika tidak, alihkan ke halaman login
if (!isset($_SESSION['username'])) {
    header("Location: login.php");
    exit;
}

// Periksa apakah ID proyek diberikan melalui parameter URL
if (isset($_GET['id'])) {
    // Menggunakan koneksi ke database yang sudah ada, sesuaikan dengan kebutuhan Anda
    include('indexDB.php');

    // Hindari SQL Injection dengan menggunakan parameterized query
    $projectId = $_GET['id'];
    $stmt = $conn->prepare("DELETE FROM upcoming_projects WHERE upid = ?");
    $stmt->bind_param("i", $projectId);
    $stmt->execute();
    $stmt->close();

    // Redirect kembali ke halaman sebelumnya setelah menghapus proyek
    header("Location: upcomingprojects.php"); // Ganti 'previousPage.php' dengan halaman yang sesuai
    exit;
} else {
    // Jika tidak ada ID proyek yang diberikan, kembalikan pengguna ke halaman sebelumnya
    header("Location: upcomingprojects.php"); // Ganti 'previousPage.php' dengan halaman yang sesuai
    exit;
}
?>
