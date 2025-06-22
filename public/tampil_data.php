<?php

include "../config/koneksi.php";
$sql = "SELECT * FROM mahasiswa order by no desc";
$query = mysqli_query($conn, $sql);
$list_data = array();
while ($data = mysqli_fetch_assoc($query)) {
    $list_data[] = array(
        'id_mahasiswa'=>$data['id_mahasiswa'],
        'nama'=>$data['nama'],
        'alamat'=>$data['alamat'],
        'no_hp'=>$data['no_hp']
    );
    
}
echo json_encode(array(
    'data' => $list_data
));
