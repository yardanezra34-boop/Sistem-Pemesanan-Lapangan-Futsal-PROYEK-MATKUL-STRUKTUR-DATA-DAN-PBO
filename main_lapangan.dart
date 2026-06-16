import 'class_lapangan.dart';
import 'dart:io';

void main() {
  SistemFutsal sistem = SistemFutsal();

  bool lanjutInput = true;
  while (lanjutInput) {
    print("\n--- MASUKKAN DATA PEMESANAN BARU ---");
    
    stdout.write("Nama Pemesan: ");
    String namaInput = stdin.readLineSync() ?? "Tanpa Nama";
    if (namaInput.trim().isEmpty) namaInput = "Tanpa Nama";
    
    int lapanganInput = 0;
    while (true) {
      stdout.write("Nomor Lapangan (1 atau 2): ");
      lapanganInput = int.tryParse(stdin.readLineSync() ?? "0") ?? 0;
      
      if (lapanganInput == 1 || lapanganInput == 2) {
        break;
      } else {
        print("Hanya tersedia Lapangan 1 dan 2. Silahkan masukkan kembali");
      }
    }

    // Input tanggal hanya hari, bulan & tahun otomatis dari sistem
    int hariInput = 0;
    while (true) {
      stdout.write("Tanggal Pemesanan (contoh: 20): ");
      hariInput = int.tryParse(stdin.readLineSync() ?? "0") ?? 0;
      if (hariInput >= 1 && hariInput <= 31) {
        break;
      }
      print("Tanggal tidak valid. Masukkan angka 1-31.");
    }
    
    stdout.write("Jam Mulai Sewa (Contoh: 19): ");
    int jamInput = int.tryParse(stdin.readLineSync() ?? "0") ?? 0;
    
    stdout.write("Durasi Sewa (Jam): ");
    int durasiInput = int.tryParse(stdin.readLineSync() ?? "1") ?? 1;

    // Memasukkan hasil input pengguna ke dalam sistem antrean sesuai permintaan pemesan
    sistem.tambahKeAntrean(namaInput, lapanganInput, jamInput, durasiInput, hariInput);

    // Konfirmasi untuk menambah data lagi
    stdout.write("\nApakah ingin menambah pemesan lagi? (y/t): ");
    String konfirmasi = stdin.readLineSync()?.toLowerCase() ?? "t";
    if (konfirmasi == "t" || konfirmasi == "tidak") {
      lanjutInput = false;
    }
  }

  // Tampilkan kondisi antrean setelah semua proses input selesai
  sistem.tampilkanSemuaData();

  // Memproses semua antrean yang masuk satu per satu secara dinamis (FIFO)
  int jumlahAntrean = sistem.antreanPemesanan.length;
  for (int i = 0; i < jumlahAntrean; i++) {
    sistem.prosesAntrean();
  }

  // Tampilkan kondisi setelah semua antrean dipindahkan ke riwayat (List)
  sistem.tampilkanSemuaData();

  // Uji coba fitur Sorting (Mengurutkan riwayat dari jam terkecil)
  sistem.urutkanRiwayatBerdasarkanLapanganDanJam();
  sistem.tampilkanSemuaData();

  // Fitur Pencarian Data Pemesan Secara Berulang
  bool lanjutCari = true;
  while (lanjutCari) {
    print("\n--- FITUR PENCARIAN DATA ---");
    stdout.write("Apakah Anda ingin mencari data pemesan di riwayat? (y/t): ");
    String pilihanCari = stdin.readLineSync()?.toLowerCase() ?? "t";

    if (pilihanCari == "y" || pilihanCari == "ya") {
      stdout.write("Masukkan Nama Pemesan yang ingin dicari di riwayat: ");
      String namaCariInput = stdin.readLineSync() ?? "";
      sistem.cariPemesanan(namaCariInput);
    } else if (pilihanCari == "t" || pilihanCari == "tidak") {
      lanjutCari = false;
    } else {
      print("Pilihan tidak valid, silakan masukkan 'y' atau 't'.");
    }
  }
}