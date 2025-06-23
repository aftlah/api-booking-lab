<?php
header("Content-Type: application/json");
require_once "../../config/koneksi.php";

$requestMethod = $_SERVER['REQUEST_METHOD'];

switch ($requestMethod) {
    case 'GET':
        $tanggal = $_GET['tanggal'] ?? date('Y-m-d');
        getJadwal($tanggal);
        break;

    case 'POST':
        bookJadwal();
        break;

    default:
        http_response_code(405);
        echo json_encode(["message" => "Method not allowed", "status" => "error"]);
}

function getJadwal($tanggal)
{
    global $conn;
    $sql = "SELECT jl.id_jadwal, jl.id_lab, l.nama_lab, jl.jam, jl.status
        FROM jadwal jl
        JOIN lab l ON jl.id_lab = l.id_lab
        WHERE jl.tanggal = ?
        ORDER BY jl.id_lab, jl.jam
    ";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $tanggal);
    $stmt->execute();
    $result = $stmt->get_result();
    $jadwal = $result->fetch_all(MYSQLI_ASSOC);
    echo json_encode($jadwal);
}

function bookJadwal()
{
    global $conn;
    $data = json_decode(file_get_contents("php://input"), true);

    $requiredFields = [
        'id_jadwal',
        'user_id',
        'id_dosen',
        'id_lab',
        'id_admin',
        'tanggal_pesan',
        'jam_mulai',
        'jam_selesai',
        'kegiatan',
        'kelompok',
        'deskripsi'
    ];

    foreach ($requiredFields as $field) {
        if (empty($data[$field])) {
            http_response_code(400);
            echo json_encode(["message" => "Missing parameter: $field", "status" => "error"]);
            return;
        }
    }

    // Ambil data
    $id_jadwal = $data['id_jadwal'];
    $user_id = $data['user_id'];
    $id_dosen = $data['id_dosen'];
    $id_lab = $data['id_lab']; 
    $id_admin = $data['id_admin'];
    $tanggal_pesan = $data['tanggal_pesan'];
    $jam_mulai = $data['jam_mulai'];
    $jam_selesai = $data['jam_selesai'];
    $kegiatan = $data['kegiatan'];
    $kelompok = $data['kelompok'];
    $deskripsi = $data['deskripsi'];

    // Cek status jadwal
    $cek = $conn->prepare("SELECT status FROM jadwal WHERE id_lab = ? AND tanggal = ? AND jam = ?");
    $cek->bind_param("sss", $id_lab, $tanggal_pesan, $jam_mulai);
    $cek->execute();
    $status = null;
    $cek->bind_result($status);
    $cek->fetch();
    $cek->close();

    if ($status !== 'tersedia') {
        http_response_code(409);
        echo json_encode(["message" => "Slot sudah dibooking", "status" => "booked"]);
        return;
    }

    $conn->begin_transaction();

    try {
        $insert = $conn->prepare("
            INSERT INTO pemesanan (
                id_jadwal, user_id, id_dosen, id_lab, id_admin,
                tanggal_pesan, jam_mulai, jam_selesai,
                kegiatan, kelompok, deskripsi, waktu_booking
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
        ");
        $insert->bind_param(
            "iiissssssss",
            $id_jadwal,
            $user_id,
            $id_dosen,
            $id_lab,        
            $id_admin,
            $tanggal_pesan,
            $jam_mulai,
            $jam_selesai,
            $kegiatan,
            $kelompok,
            $deskripsi
        );
        $insert->execute();

        $update = $conn->prepare("UPDATE jadwal SET status = 'booked' WHERE id_lab = ? AND tanggal = ? AND jam = ?");
        $update->bind_param("sss", $id_lab, $tanggal_pesan, $jam_mulai);
        $update->execute();

        $conn->commit();
        echo json_encode(["message" => "Booking berhasil", "status" => "success"]);
    } catch (Exception $e) {
        $conn->rollback();
        http_response_code(500);
        echo json_encode(["message" => "Terjadi kesalahan", "error" => $e->getMessage()]);
    }
}
