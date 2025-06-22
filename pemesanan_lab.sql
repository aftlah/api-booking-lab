-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 22, 2025 at 04:29 PM
-- Server version: 8.0.30
-- PHP Version: 8.3.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pemesanan_lab`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id_asisten` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `nama_asisten` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `username` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `booking`
--

CREATE TABLE `booking` (
  `id_booking` int NOT NULL,
  `id_jadwal` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `waktu_booking` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `booking`
--

INSERT INTO `booking` (`id_booking`, `id_jadwal`, `user_id`, `waktu_booking`) VALUES
(1, 3, 1, '2025-06-22 16:21:49'),
(2, 2, 1, '2025-06-22 16:22:20');

-- --------------------------------------------------------

--
-- Table structure for table `dosen`
--

CREATE TABLE `dosen` (
  `nip` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `nama` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `no_telp` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jadwal_lab`
--

CREATE TABLE `jadwal_lab` (
  `id_jadwal` int NOT NULL,
  `id_lab` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tanggal` date DEFAULT NULL,
  `jam` time DEFAULT NULL,
  `status` enum('tersedia','booked') DEFAULT 'tersedia'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `jadwal_lab`
--

INSERT INTO `jadwal_lab` (`id_jadwal`, `id_lab`, `tanggal`, `jam`, `status`) VALUES
(1, 'LAB02', '2025-05-02', '08:00:00', 'tersedia'),
(2, 'LAB02', '2025-05-02', '10:40:00', 'booked'),
(3, 'LAB02', '2025-05-02', '13:25:00', 'booked'),
(4, 'LAB02', '2025-05-02', '16:10:00', 'tersedia'),
(5, 'LAB04', '2025-05-02', '08:00:00', 'tersedia'),
(6, 'LAB04', '2025-05-02', '10:40:00', 'booked'),
(7, 'LAB04', '2025-05-02', '13:25:00', 'tersedia'),
(8, 'LAB04', '2025-05-02', '16:10:00', 'tersedia'),
(9, 'LAB05', '2025-05-02', '08:00:00', 'tersedia'),
(10, 'LAB05', '2025-05-02', '10:40:00', 'tersedia'),
(11, 'LAB05', '2025-05-02', '13:25:00', 'tersedia'),
(12, 'LAB05', '2025-05-02', '16:10:00', 'booked');

-- --------------------------------------------------------

--
-- Table structure for table `lab`
--

CREATE TABLE `lab` (
  `id_lab` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `nama_lab` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `kapasitas` int DEFAULT NULL,
  `deskripsi` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lab`
--

INSERT INTO `lab` (`id_lab`, `nama_lab`, `kapasitas`, `deskripsi`) VALUES
('LAB02', 'Lab Programming', 30, 'Lab untuk pemrograman'),
('LAB04', 'Lab Artificial Intelligence', 25, 'Lab AI dan machine learning'),
('LAB05', 'Lab Network', 20, 'Lab jaringan komputer');

-- --------------------------------------------------------

--
-- Table structure for table `pemesanan`
--

CREATE TABLE `pemesanan` (
  `id_pemesanan` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `id_dosen` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_lab` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_admin` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tanggal_pesan` date DEFAULT NULL,
  `jam_mulai` time DEFAULT NULL,
  `jam_selesai` time DEFAULT NULL,
  `kegiatan` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `kelompok` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `deskripsi` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id_asisten`);

--
-- Indexes for table `booking`
--
ALTER TABLE `booking`
  ADD PRIMARY KEY (`id_booking`),
  ADD KEY `id_jadwal` (`id_jadwal`);

--
-- Indexes for table `dosen`
--
ALTER TABLE `dosen`
  ADD PRIMARY KEY (`nip`);

--
-- Indexes for table `jadwal_lab`
--
ALTER TABLE `jadwal_lab`
  ADD PRIMARY KEY (`id_jadwal`),
  ADD KEY `id_lab` (`id_lab`);

--
-- Indexes for table `lab`
--
ALTER TABLE `lab`
  ADD PRIMARY KEY (`id_lab`);

--
-- Indexes for table `pemesanan`
--
ALTER TABLE `pemesanan`
  ADD PRIMARY KEY (`id_pemesanan`),
  ADD KEY `id_dosen` (`id_dosen`),
  ADD KEY `id_lab` (`id_lab`),
  ADD KEY `id_admin` (`id_admin`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `booking`
--
ALTER TABLE `booking`
  MODIFY `id_booking` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `jadwal_lab`
--
ALTER TABLE `jadwal_lab`
  MODIFY `id_jadwal` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `booking`
--
ALTER TABLE `booking`
  ADD CONSTRAINT `booking_ibfk_1` FOREIGN KEY (`id_jadwal`) REFERENCES `jadwal_lab` (`id_jadwal`);

--
-- Constraints for table `jadwal_lab`
--
ALTER TABLE `jadwal_lab`
  ADD CONSTRAINT `jadwal_lab_ibfk_1` FOREIGN KEY (`id_lab`) REFERENCES `lab` (`id_lab`);

--
-- Constraints for table `pemesanan`
--
ALTER TABLE `pemesanan`
  ADD CONSTRAINT `pemesanan_ibfk_1` FOREIGN KEY (`id_dosen`) REFERENCES `dosen` (`nip`),
  ADD CONSTRAINT `pemesanan_ibfk_2` FOREIGN KEY (`id_lab`) REFERENCES `lab` (`id_lab`),
  ADD CONSTRAINT `pemesanan_ibfk_3` FOREIGN KEY (`id_admin`) REFERENCES `admin` (`id_asisten`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
