<?php

include "../config/koneksi.php";

$query = "SELECT * FROM mahasiswa WHERE id_mahasiswa='$_POST[id_mahasiswa]'";
$result = mysqli_query($conn, $query);
$data = mysqli_fetch_assoc($result);
echo json_encode(array(
    'data' => array('id_mahasiswa' => $data['id_mahasiswa'],
    'nama' => $data['nama'],
    'alamat' => $data['alamat'],
    'no_hp' => $data['no_hp'],
    )
));
