<?php

include "../config/koneksi.php";

$id = $_POST['id_mahasiswa'];
$nama   = htmlentities($_POST['nama']);
$alamat = htmlentities($_POST['alamat']);
$no_hp  = htmlentities($_POST['no_hp']);

$query = "UPDATE mahasiswa SET nama='$nama', alamat='$alamat', no_hp='$no_hp' WHERE id_mahasiswa='$id'";
if (mysqli_query($conn, $query)) {
    echo json_encode(array('status' => 'diubah'));
} else {
    echo "Error: " . $query . "<br>" . mysqli_error($conn);
}