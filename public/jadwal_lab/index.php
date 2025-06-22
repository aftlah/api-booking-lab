<?php
header("Content-Type: application/json");
require_once "../../config/koneksi.php";

$req = $_SERVER['REQUEST_METHOD'];

switch ($req) {
    case 'GET':
        $tanggal = $_GET['tanggal'] ?? date('Y-m-d');
        getJadwal($tanggal);
        break;

    case 'POST':
        bookJadwal();
        break;

    default:
        http_response_code(405);
        echo json_encode(["message" => "Method not allowed","status" => "error"]);
}


function getJadwal($tanggal)
{
    global $conn;
    $sql = "
        SELECT jl.id_jadwal, jl.id_lab, l.nama_lab, jl.jam, jl.status
        FROM jadwal_lab jl
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

    $id_jadwal = $data['id_jadwal'] ?? null;
    $user_id = $data['user_id'] ?? null;

    if (!$id_jadwal || !$user_id) {
        http_response_code(400);
        echo json_encode(["message" => "Missing parameters", "status" => "error"]);
        return;
    }

    $cek = $conn->prepare("SELECT status FROM jadwal_lab WHERE id_jadwal = ?");
    $cek->bind_param("i", $id_jadwal);
    $cek->execute();
    $status = null;
    $cek->bind_result($status);
    $cek->fetch();
    $cek->close();

    if ($status !== 'tersedia') {
        http_response_code(409);
        echo json_encode(["message" => "Slot sudah dibooking", "status" => $status]);
        return;
    }

    $conn->begin_transaction();

    try {
        $insert = $conn->prepare("INSERT INTO booking (id_jadwal, user_id) VALUES (?, ?)");
        $insert->bind_param("ii", $id_jadwal, $user_id);
        $insert->execute();

        $update = $conn->prepare("UPDATE jadwal_lab SET status = 'booked' WHERE id_jadwal = ?");
        $update->bind_param("i", $id_jadwal);
        $update->execute();

        $conn->commit();
        echo json_encode(["message" => "Booking berhasil", "status" => "success"]);
    } catch (Exception $e) {
        $conn->rollback();
        http_response_code(500);
        echo json_encode(["message" => "Terjadi kesalahan", "status" => "error"]);
    }
}