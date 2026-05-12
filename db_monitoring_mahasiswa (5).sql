-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 12 Bulan Mei 2026 pada 18.26
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_monitoring_mahasiswa`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `absensi_qr`
--

CREATE TABLE `absensi_qr` (
  `id` int(11) NOT NULL,
  `mahasiswa_id` int(11) DEFAULT NULL,
  `jadwal_id` int(11) DEFAULT NULL,
  `tanggal` date DEFAULT NULL,
  `jam_hadir` time DEFAULT NULL,
  `status` enum('hadir','izin','alfa') DEFAULT 'hadir'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `aktivitas_organisasi`
--

CREATE TABLE `aktivitas_organisasi` (
  `id` int(11) NOT NULL,
  `mahasiswa_id` int(11) DEFAULT NULL,
  `organisasi_id` int(11) DEFAULT NULL,
  `jabatan` varchar(50) DEFAULT NULL,
  `status` enum('aktif','tidak aktif') DEFAULT NULL,
  `periode_mulai` date DEFAULT NULL,
  `periode_selesai` date DEFAULT NULL,
  `deskripsi_tugas` text DEFAULT NULL,
  `bukti` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `aktivitas_organisasi`
--

INSERT INTO `aktivitas_organisasi` (`id`, `mahasiswa_id`, `organisasi_id`, `jabatan`, `status`, `periode_mulai`, `periode_selesai`, `deskripsi_tugas`, `bukti`) VALUES
(2, 43, 1, 'Ketua', 'aktif', '2025-01-01', NULL, NULL, NULL),
(3, 23, 1, '', 'aktif', '0000-00-00', '0000-00-00', '', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `dosen`
--

CREATE TABLE `dosen` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `dosen`
--

INSERT INTO `dosen` (`id`, `nama`, `email`, `user_id`) VALUES
(1, 'Dosen TI', 'dosen@gmail.com', 2);

-- --------------------------------------------------------

--
-- Struktur dari tabel `jadwal`
--

CREATE TABLE `jadwal` (
  `id` int(11) NOT NULL,
  `hari` varchar(20) DEFAULT NULL,
  `jam` varchar(20) DEFAULT NULL,
  `ruangan` varchar(50) DEFAULT NULL,
  `kelas_id` int(11) DEFAULT NULL,
  `dosen` varchar(100) DEFAULT NULL,
  `mata_kuliah_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `jadwal`
--

INSERT INTO `jadwal` (`id`, `hari`, `jam`, `ruangan`, `kelas_id`, `dosen`, `mata_kuliah_id`) VALUES
(1, 'Senin', '08:00 - 10:00', 'Lab 1', 1, 'Dosen TI', 1),
(2, 'Selasa', '10:00 - 12:00', 'Lab 2', 1, 'Dosen TI', 1),
(3, 'Rabu', '13:00 - 15:00', 'Lab 3', 1, 'Dosen TI', 1),
(4, 'Kamis', '09:00 - 11:00', 'Lab 1', 1, 'Dosen TI', 1),
(5, 'Jumat', '14:00 - 16:00', 'Lab 2', 1, 'Dosen TI', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `jurusan`
--

CREATE TABLE `jurusan` (
  `id` int(11) NOT NULL,
  `nama_jurusan` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `jurusan`
--

INSERT INTO `jurusan` (`id`, `nama_jurusan`) VALUES
(1, 'Teknik Informatika');

-- --------------------------------------------------------

--
-- Struktur dari tabel `kehadiran`
--

CREATE TABLE `kehadiran` (
  `id` int(11) NOT NULL,
  `mahasiswa_id` int(11) DEFAULT NULL,
  `mata_kuliah_id` int(11) DEFAULT NULL,
  `tanggal` date DEFAULT NULL,
  `status` enum('hadir','izin','alpha') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kehadiran`
--

INSERT INTO `kehadiran` (`id`, `mahasiswa_id`, `mata_kuliah_id`, `tanggal`, `status`) VALUES
(2, 23, 1, '2026-01-01', 'hadir'),
(3, 23, 1, '2026-01-02', 'hadir'),
(4, 23, 1, '2026-01-03', 'hadir'),
(5, 23, 1, '2026-01-04', 'hadir'),
(6, 23, 1, '2026-01-05', 'hadir'),
(7, 24, 1, '2026-01-01', 'hadir'),
(8, 24, 1, '2026-01-02', 'hadir'),
(9, 24, 1, '2026-01-03', 'hadir'),
(10, 24, 1, '2026-01-04', 'alpha'),
(11, 24, 1, '2026-01-05', 'hadir'),
(12, 25, 1, '2026-01-01', 'hadir'),
(13, 25, 1, '2026-01-02', 'hadir'),
(14, 25, 1, '2026-01-03', 'alpha'),
(15, 25, 1, '2026-01-04', 'hadir'),
(16, 25, 1, '2026-01-05', 'alpha'),
(17, 26, 1, '2026-01-01', 'alpha'),
(18, 26, 1, '2026-01-02', 'hadir'),
(19, 26, 1, '2026-01-03', 'alpha'),
(20, 26, 1, '2026-01-04', 'hadir'),
(21, 26, 1, '2026-01-05', 'hadir'),
(22, 27, 1, '2026-01-01', 'alpha'),
(23, 27, 1, '2026-01-02', 'hadir'),
(24, 27, 1, '2026-01-03', 'hadir'),
(25, 27, 1, '2026-01-04', 'hadir'),
(26, 27, 1, '2026-01-05', 'hadir'),
(27, 28, 1, '2026-01-01', 'hadir'),
(28, 28, 1, '2026-01-02', 'hadir'),
(29, 28, 1, '2026-01-03', 'hadir'),
(30, 28, 1, '2026-01-04', 'alpha'),
(31, 28, 1, '2026-01-05', 'alpha'),
(32, 29, 1, '2026-01-01', 'hadir'),
(33, 29, 1, '2026-01-02', 'alpha'),
(34, 29, 1, '2026-01-03', 'hadir'),
(35, 29, 1, '2026-01-04', 'hadir'),
(36, 29, 1, '2026-01-05', 'alpha'),
(37, 30, 1, '2026-01-01', 'alpha'),
(38, 30, 1, '2026-01-02', 'hadir'),
(39, 30, 1, '2026-01-03', 'hadir'),
(40, 30, 1, '2026-01-04', 'alpha'),
(41, 30, 1, '2026-01-05', 'hadir'),
(42, 31, 1, '2026-01-01', 'alpha'),
(43, 31, 1, '2026-01-02', 'hadir'),
(44, 31, 1, '2026-01-03', 'hadir'),
(45, 31, 1, '2026-01-04', 'hadir'),
(46, 31, 1, '2026-01-05', 'hadir'),
(47, 32, 1, '2026-01-01', 'alpha'),
(48, 32, 1, '2026-01-02', 'hadir'),
(49, 32, 1, '2026-01-03', 'hadir'),
(50, 32, 1, '2026-01-04', 'hadir'),
(51, 32, 1, '2026-01-05', 'hadir'),
(52, 33, 1, '2026-01-01', 'hadir'),
(53, 33, 1, '2026-01-02', 'hadir'),
(54, 33, 1, '2026-01-03', 'hadir'),
(55, 33, 1, '2026-01-04', 'alpha'),
(56, 33, 1, '2026-01-05', 'alpha'),
(57, 34, 1, '2026-01-01', 'hadir'),
(58, 34, 1, '2026-01-02', 'alpha'),
(59, 34, 1, '2026-01-03', 'hadir'),
(60, 34, 1, '2026-01-04', 'hadir'),
(61, 34, 1, '2026-01-05', 'alpha'),
(62, 35, 1, '2026-01-01', 'hadir'),
(63, 35, 1, '2026-01-02', 'hadir'),
(64, 35, 1, '2026-01-03', 'hadir'),
(65, 35, 1, '2026-01-04', 'alpha'),
(66, 35, 1, '2026-01-05', 'hadir'),
(67, 36, 1, '2026-01-01', 'hadir'),
(68, 36, 1, '2026-01-02', 'hadir'),
(69, 36, 1, '2026-01-03', 'hadir'),
(70, 36, 1, '2026-01-04', 'hadir'),
(71, 36, 1, '2026-01-05', 'hadir'),
(72, 37, 1, '2026-01-01', 'alpha'),
(73, 37, 1, '2026-01-02', 'hadir'),
(74, 37, 1, '2026-01-03', 'alpha'),
(75, 37, 1, '2026-01-04', 'alpha'),
(76, 37, 1, '2026-01-05', 'hadir'),
(77, 38, 1, '2026-01-01', 'alpha'),
(78, 38, 1, '2026-01-02', 'alpha'),
(79, 38, 1, '2026-01-03', 'alpha'),
(80, 38, 1, '2026-01-04', 'hadir'),
(81, 38, 1, '2026-01-05', 'alpha'),
(82, 39, 1, '2026-01-01', 'hadir'),
(83, 39, 1, '2026-01-02', 'hadir'),
(84, 39, 1, '2026-01-03', 'hadir'),
(85, 39, 1, '2026-01-04', 'hadir'),
(86, 39, 1, '2026-01-05', 'alpha'),
(87, 40, 1, '2026-01-01', 'hadir'),
(88, 40, 1, '2026-01-02', 'alpha'),
(89, 40, 1, '2026-01-03', 'hadir'),
(90, 40, 1, '2026-01-04', 'alpha'),
(91, 40, 1, '2026-01-05', 'hadir'),
(92, 41, 1, '2026-01-01', 'hadir'),
(93, 41, 1, '2026-01-02', 'hadir'),
(94, 41, 1, '2026-01-03', 'hadir'),
(95, 41, 1, '2026-01-04', 'hadir'),
(96, 41, 1, '2026-01-05', 'alpha'),
(97, 42, 1, '2026-01-01', 'hadir'),
(98, 42, 1, '2026-01-02', 'hadir'),
(99, 42, 1, '2026-01-03', 'hadir'),
(100, 42, 1, '2026-01-04', 'hadir'),
(101, 42, 1, '2026-01-05', 'hadir'),
(102, 43, 1, '2026-01-01', 'alpha'),
(103, 43, 1, '2026-01-02', 'hadir'),
(104, 43, 1, '2026-01-03', 'alpha'),
(105, 43, 1, '2026-01-04', 'hadir'),
(106, 43, 1, '2026-01-05', 'hadir'),
(107, 44, 1, '2026-01-01', 'hadir'),
(108, 44, 1, '2026-01-02', 'alpha'),
(109, 44, 1, '2026-01-03', 'alpha'),
(110, 44, 1, '2026-01-04', 'alpha'),
(111, 44, 1, '2026-01-05', 'hadir'),
(129, 43, 1, '2026-05-03', 'hadir'),
(130, 43, 1, '2026-05-03', 'hadir'),
(131, 43, 1, '2026-05-03', 'hadir'),
(132, 43, 1, '2026-05-03', 'hadir'),
(133, 43, 1, '2026-05-03', 'hadir'),
(134, 43, 1, '2026-05-03', 'hadir'),
(135, 43, 1, '2026-05-03', 'hadir'),
(137, 43, 1, '2026-05-04', 'hadir'),
(138, 43, 1, '2026-05-06', 'hadir'),
(151, 43, 1, '2026-05-06', 'hadir'),
(152, 43, 1, '2026-05-06', 'hadir');

-- --------------------------------------------------------

--
-- Struktur dari tabel `kelas`
--

CREATE TABLE `kelas` (
  `id` int(11) NOT NULL,
  `nama_kelas` varchar(50) DEFAULT NULL,
  `jurusan_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kelas`
--

INSERT INTO `kelas` (`id`, `nama_kelas`, `jurusan_id`) VALUES
(1, 'TI-1A', 1),
(2, 'TI-1B', 1),
(3, 'TI-2A', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `mahasiswa`
--

CREATE TABLE `mahasiswa` (
  `id` int(11) NOT NULL,
  `nim` varchar(20) DEFAULT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `kelas_id` int(11) DEFAULT NULL,
  `semester` int(11) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `mahasiswa`
--

INSERT INTO `mahasiswa` (`id`, `nim`, `nama`, `kelas_id`, `semester`, `status`, `user_id`) VALUES
(23, '126', 'Haikal Kaluku', 1, 1, 'aktif', NULL),
(24, '127', 'A Pratama Patangari', 1, 1, 'aktif', NULL),
(25, '128', 'Adinda Ladita Paulintje Makaghana', 1, 1, 'aktif', NULL),
(26, '129', 'Ni Wayan Dewi Stefani', 1, 1, 'aktif', NULL),
(27, '130', 'Mita Marshanda Mandak', 1, 1, 'aktif', NULL),
(28, '131', 'Altiano Gustaf Manuel Lumy', 1, 1, 'aktif', NULL),
(29, '132', 'Zahwa Aulyah Putri Domu', 1, 1, 'aktif', NULL),
(30, '133', 'Jesaya Steye Walangitan', 1, 1, 'aktif', NULL),
(31, '134', 'Aurond Ray J Briel Harbas', 1, 1, 'aktif', NULL),
(32, '135', 'Emilie Patricia Tawaris', 1, 1, 'aktif', NULL),
(33, '136', 'Lintar Pandito', 1, 1, 'aktif', NULL),
(34, '137', 'Muhamad Ghazali Mokoagow', 1, 1, 'aktif', NULL),
(35, '138', 'Aditya Leonard Kambey', 1, 1, 'aktif', NULL),
(36, '139', 'Dimas Pratama Zefanya Bawuna', 1, 1, 'aktif', NULL),
(37, '140', 'Linchia Esther Walangitan', 1, 1, 'aktif', NULL),
(38, '141', 'Fachry Ramadhan Biki Olli', 1, 1, 'aktif', NULL),
(39, '142', 'Juan Christian Siar', 1, 1, 'aktif', NULL),
(40, '143', 'Christian Putri Lomboan', 1, 1, 'aktif', NULL),
(41, '144', 'Clark Aldrich Raphael Walangitan', 1, 1, 'aktif', NULL),
(42, '145', 'Hizkia Piet Hein Rantung', 1, 1, 'aktif', NULL),
(43, '146', 'Daniel Mirontoneng', 1, 1, 'aktif', 3),
(44, '147', 'Joyritske Hendriane Budiman', 1, 1, 'aktif', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `mata_kuliah`
--

CREATE TABLE `mata_kuliah` (
  `id` int(11) NOT NULL,
  `nama_mk` varchar(100) DEFAULT NULL,
  `jurusan_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `mata_kuliah`
--

INSERT INTO `mata_kuliah` (`id`, `nama_mk`, `jurusan_id`) VALUES
(1, 'Pemrograman', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `nilai`
--

CREATE TABLE `nilai` (
  `id` int(11) NOT NULL,
  `mahasiswa_id` int(11) DEFAULT NULL,
  `mata_kuliah_id` int(11) DEFAULT NULL,
  `nilai_angka` float DEFAULT NULL,
  `nilai_huruf` char(2) DEFAULT NULL,
  `semester` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `organisasi`
--

CREATE TABLE `organisasi` (
  `id` int(11) NOT NULL,
  `nama_organisasi` varchar(100) DEFAULT NULL,
  `jenis` enum('BEM','HMJ','UKM') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `organisasi`
--

INSERT INTO `organisasi` (`id`, `nama_organisasi`, `jenis`) VALUES
(1, 'BEM', ''),
(2, 'HIMATIF', ''),
(3, 'UKM Musik', 'UKM'),
(4, 'UKM Olahraga', 'UKM'),
(5, 'PMK', ''),
(6, 'Mapala', '');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` enum('admin','dosen','mahasiswa') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `nama`, `email`, `password`, `role`) VALUES
(1, 'Admin', 'admin@gmail.com', '123', 'admin'),
(2, 'Dosen TI', 'dosen@gmail.com', '123', 'dosen'),
(3, 'Mahasiswa Demo', 'mhs@gmail.com', '123', 'mahasiswa');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `absensi_qr`
--
ALTER TABLE `absensi_qr`
  ADD PRIMARY KEY (`id`),
  ADD KEY `mahasiswa_id` (`mahasiswa_id`),
  ADD KEY `jadwal_id` (`jadwal_id`);

--
-- Indeks untuk tabel `aktivitas_organisasi`
--
ALTER TABLE `aktivitas_organisasi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `mahasiswa_id` (`mahasiswa_id`),
  ADD KEY `organisasi_id` (`organisasi_id`);

--
-- Indeks untuk tabel `dosen`
--
ALTER TABLE `dosen`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `jadwal`
--
ALTER TABLE `jadwal`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `jurusan`
--
ALTER TABLE `jurusan`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `kehadiran`
--
ALTER TABLE `kehadiran`
  ADD PRIMARY KEY (`id`),
  ADD KEY `mahasiswa_id` (`mahasiswa_id`),
  ADD KEY `mata_kuliah_id` (`mata_kuliah_id`);

--
-- Indeks untuk tabel `kelas`
--
ALTER TABLE `kelas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jurusan_id` (`jurusan_id`);

--
-- Indeks untuk tabel `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD PRIMARY KEY (`id`),
  ADD KEY `kelas_id` (`kelas_id`);

--
-- Indeks untuk tabel `mata_kuliah`
--
ALTER TABLE `mata_kuliah`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jurusan_id` (`jurusan_id`);

--
-- Indeks untuk tabel `nilai`
--
ALTER TABLE `nilai`
  ADD PRIMARY KEY (`id`),
  ADD KEY `mahasiswa_id` (`mahasiswa_id`),
  ADD KEY `mata_kuliah_id` (`mata_kuliah_id`);

--
-- Indeks untuk tabel `organisasi`
--
ALTER TABLE `organisasi`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `absensi_qr`
--
ALTER TABLE `absensi_qr`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `aktivitas_organisasi`
--
ALTER TABLE `aktivitas_organisasi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `dosen`
--
ALTER TABLE `dosen`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `jadwal`
--
ALTER TABLE `jadwal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `jurusan`
--
ALTER TABLE `jurusan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `kehadiran`
--
ALTER TABLE `kehadiran`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=153;

--
-- AUTO_INCREMENT untuk tabel `kelas`
--
ALTER TABLE `kelas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `mahasiswa`
--
ALTER TABLE `mahasiswa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT untuk tabel `mata_kuliah`
--
ALTER TABLE `mata_kuliah`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `nilai`
--
ALTER TABLE `nilai`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `organisasi`
--
ALTER TABLE `organisasi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `absensi_qr`
--
ALTER TABLE `absensi_qr`
  ADD CONSTRAINT `absensi_qr_ibfk_1` FOREIGN KEY (`mahasiswa_id`) REFERENCES `mahasiswa` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `absensi_qr_ibfk_2` FOREIGN KEY (`jadwal_id`) REFERENCES `jadwal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `aktivitas_organisasi`
--
ALTER TABLE `aktivitas_organisasi`
  ADD CONSTRAINT `aktivitas_organisasi_ibfk_1` FOREIGN KEY (`mahasiswa_id`) REFERENCES `mahasiswa` (`id`),
  ADD CONSTRAINT `aktivitas_organisasi_ibfk_2` FOREIGN KEY (`organisasi_id`) REFERENCES `organisasi` (`id`);

--
-- Ketidakleluasaan untuk tabel `kehadiran`
--
ALTER TABLE `kehadiran`
  ADD CONSTRAINT `kehadiran_ibfk_1` FOREIGN KEY (`mahasiswa_id`) REFERENCES `mahasiswa` (`id`),
  ADD CONSTRAINT `kehadiran_ibfk_2` FOREIGN KEY (`mata_kuliah_id`) REFERENCES `mata_kuliah` (`id`);

--
-- Ketidakleluasaan untuk tabel `kelas`
--
ALTER TABLE `kelas`
  ADD CONSTRAINT `kelas_ibfk_1` FOREIGN KEY (`jurusan_id`) REFERENCES `jurusan` (`id`);

--
-- Ketidakleluasaan untuk tabel `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD CONSTRAINT `mahasiswa_ibfk_1` FOREIGN KEY (`kelas_id`) REFERENCES `kelas` (`id`);

--
-- Ketidakleluasaan untuk tabel `mata_kuliah`
--
ALTER TABLE `mata_kuliah`
  ADD CONSTRAINT `mata_kuliah_ibfk_1` FOREIGN KEY (`jurusan_id`) REFERENCES `jurusan` (`id`);

--
-- Ketidakleluasaan untuk tabel `nilai`
--
ALTER TABLE `nilai`
  ADD CONSTRAINT `nilai_ibfk_1` FOREIGN KEY (`mahasiswa_id`) REFERENCES `mahasiswa` (`id`),
  ADD CONSTRAINT `nilai_ibfk_2` FOREIGN KEY (`mata_kuliah_id`) REFERENCES `mata_kuliah` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
