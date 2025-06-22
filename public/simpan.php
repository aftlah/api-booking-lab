<?php
include "../config/koneksi.php";

// Ambil input
$nama   = htmlentities($_POST['nama']);
$alamat = htmlentities($_POST['alamat']);
$no_hp  = htmlentities($_POST['no_hp']);

$id = rand(0, 9999); // Sebaiknya diganti auto increment di DB

if (isset($_POST['id_mahasiswa'])) {
    // Proses UPDATE
    $query = "UPDATE mahasiswa SET 
        nama ='$nama',
        alamat='$alamat', 
        no_hp='$no_hp' 
        WHERE id_mahasiswa='" . $_POST['id_mahasiswa'] . "'";

    if (mysqli_query($conn, $query)) {
        echo json_encode(array('status' => 'diubah'));
    } else {
        echo json_encode(array('status' => 'gagal'));
    }
} else {
    // Proses INSERT
    $query = "INSERT INTO mahasiswa (id_mahasiswa, nama, alamat, no_hp) VALUES ('$id', '$nama', '$alamat', '$no_hp')";

    if (mysqli_query($conn, $query)) {
        echo json_encode(array('status' => 'tersimpan'));
    } else {
        echo json_encode(array('status' => 'gagal'));
    }
}
