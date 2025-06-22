<?php

include "../config/koneksi.php";

$id = $_POST['id_mahasiswa'];

$query = "DELETE FROM mahasiswa WHERE id_mahasiswa='$id'";
if (mysqli_query($conn, $query)) {
    echo json_encode(array('status' => 'hapus'));
} else {
    echo "Error: " . $query . "<br>" . mysqli_error($conn);
}