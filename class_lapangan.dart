import 'dart:collection';

// 1. KONSEP OOP: ENCAPSULATION & INHERITANCE
// Class Induk (Base Class) untuk Lapangan
class Lapangan {
  final int _nomorLapangan; // Encapsulation (private property)
  final String _jenisLantai;

  Lapangan(this._nomorLapangan, this._jenisLantai); // Konstruktor

  // Getter untuk mengakses properti private
  int get nomorLapangan => _nomorLapangan;
  String get jenisLantai => _jenisLantai;

  // Polymorphism: Method yang akan di-override
  void infoLapangan() {
    print("Lapangan No: $_nomorLapangan | Jenis: $_jenisLantai");
  }
}

// Class Anak (Inheritance) untuk Lapangan Matras
class LapanganMatras extends Lapangan {
  final int hargaPerJam;

  // Memanggil konstruktor superclass
  LapanganMatras(int nomorLapangan, this.hargaPerJam) : super(nomorLapangan, "Matras");

  // Polymorphism (Method Overriding)
  @override
  void infoLapangan() {
    print("Lapangan Futsal $nomorLapangan [$jenisLantai] - Tarif: Rp $hargaPerJam/jam");
  }
}

// Class untuk Data Pemesanan (Data Model)
class Pesanan {
  String namaPemesan;
  int nomorLapangan;
  int jamMulai;
  int durasi;
  DateTime tanggal;

  Pesanan(this.namaPemesan, this.nomorLapangan, this.jamMulai, this.durasi, this.tanggal);

  int hitungTotalBiaya(int hargaPerJam) {
    return durasi * hargaPerJam;
  }
}

// 2. KONSEP STRUKTUR DATA & MANAJEMEN SISTEM
class SistemFutsal {
  // Inisialisasi 2 Lapangan Matras
  List<LapanganMatras> daftarLapangan = [
    LapanganMatras(1, 80000),
    LapanganMatras(2, 95000),
  ];

  // STRUKTUR DATA 1: Queue (Antrean) untuk mengelola pemesanan masuk (FIFO)
  Queue<Pesanan> antreanPemesanan = Queue<Pesanan>();

  // STRUKTUR DATA 2: List untuk menyimpan riwayat pemesanan yang sukses/selelesai
  List<Pesanan> riwayatPemesanan = [];

  // Method 1: Menambah pesanan ke dalam antrean (Enqueue)
  // Input hanya tanggal (hari), bulan & tahun otomatis dari sistem
  void tambahKeAntrean(String nama, int noLapangan, int jam, int durasi, int hari) {
    if (noLapangan < 1 || noLapangan > 2) {
      print("Gagal: Hanya tersedia Lapangan 1 dan Lapangan 2.");
      return;
    }
    DateTime sekarang = DateTime.now();
    DateTime tanggal = DateTime(sekarang.year, sekarang.month, hari);
    Pesanan pesananBaru = Pesanan(nama, noLapangan, jam, durasi, tanggal);
    antreanPemesanan.addLast(pesananBaru);
    print("Berhasil menambahkan pemesan '$nama' ke dalam antrean.");
  }

  // Method 2: Memproses antrean terdepan menjadi riwayat (Dequeue)
  void prosesAntrean() {
    if (antreanPemesanan.isEmpty) {
      print("Peringatan! Antrean kosong, tidak ada pesanan yang perlu diproses.");
      return;
    }

    // Mengambil elemen pertama dari Queue
    Pesanan pesananDiproses = antreanPemesanan.removeFirst();
    riwayatPemesanan.add(pesananDiproses);

    // Ambil info harga dari objek lapangan
    int harga = daftarLapangan[pesananDiproses.nomorLapangan - 1].hargaPerJam;
    int total = pesananDiproses.hitungTotalBiaya(harga);

    // TAMBAHAN: format tanggal untuk ditampilkan
    String tgl = "${pesananDiproses.tanggal.day.toString().padLeft(2,'0')}/"
                 "${pesananDiproses.tanggal.month.toString().padLeft(2,'0')}/"
                 "${pesananDiproses.tanggal.year}";

    print("\nMEMPROSES ANTREAN");
    print("Pemesan '${pesananDiproses.namaPemesan}' berhasil memesan Lapangan ${pesananDiproses.nomorLapangan}.");
    print("Tanggal  : $tgl");
    print("Total Bayar: Rp $total (Durasi: ${pesananDiproses.durasi} jam, Mulai Jam: ${pesananDiproses.jamMulai}.00)");
  }

  // Method 3: Menampilkan status seluruh data
  void tampilkanSemuaData() {
    print("\n--- INFO SEWA LAPANGAN ---");
    for (var lap in daftarLapangan) {
      lap.infoLapangan();
    }

    print("\n--- DAFTAR ANTREAN SAAT INI (QUEUE) ---");
    if (antreanPemesanan.isEmpty) print("(Antrean Kosong)");
    for (var p in antreanPemesanan) {
      // TAMBAHAN: format & tampil tanggal di antrean
      String tgl = "${p.tanggal.day.toString().padLeft(2,'0')}/"
                   "${p.tanggal.month.toString().padLeft(2,'0')}/"
                   "${p.tanggal.year}";
      print("- Nama: ${p.namaPemesan} | Lapangan: ${p.nomorLapangan} | Tanggal: $tgl | Jam: ${p.jamMulai}.00");
    }

    print("\n--- RIWAYAT PEMESANAN (LIST) ---");
    if (riwayatPemesanan.isEmpty) print("(Kosong)");
    for (var r in riwayatPemesanan) {
      int hargaLapangan = daftarLapangan[r.nomorLapangan - 1].hargaPerJam;
      int totalBayar = r.hitungTotalBiaya(hargaLapangan);
      // TAMBAHAN: format & tampil tanggal di riwayat
      String tgl = "${r.tanggal.day.toString().padLeft(2,'0')}/"
                   "${r.tanggal.month.toString().padLeft(2,'0')}/"
                   "${r.tanggal.year}";
      print("Sukses - Nama: ${r.namaPemesan} | Lapangan: ${r.nomorLapangan} | Tanggal: $tgl | Jam: ${r.jamMulai}.00 | Durasi: ${r.durasi} jam | Total Bayar: Rp $totalBayar");
    }
  }

  // STRUKTUR DATA 3: Searching (Linear Search berdasarkan Nama Pemesan)
  void cariPemesanan(String namaDicari) {
    print("\nMENCARI PEMESANAN UNTUK NAMA: '$namaDicari'");
    bool ditemukan = false;

    for (var p in riwayatPemesanan) {
      if (p.namaPemesan.toLowerCase() == namaDicari.toLowerCase()) {
        // TAMBAHAN: format & tampil tanggal di hasil pencarian
        String tgl = "${p.tanggal.day.toString().padLeft(2,'0')}/"
                     "${p.tanggal.month.toString().padLeft(2,'0')}/"
                     "${p.tanggal.year}";
        print("Data pemesanan ditemukan: Lapangan ${p.nomorLapangan}, Tanggal $tgl, Jam ${p.jamMulai}.00, Durasi ${p.durasi} jam.");
        ditemukan = true;
      }
    }

    if (!ditemukan) {
      print("Data pemesanan untuk nama '$namaDicari' tidak ditemukan di riwayat.");
    }
  }


// STRUKTUR DATA 4: Sorting (Bubble Sort)
  void urutkanRiwayatBerdasarkanLapanganDanJam() {
    if (riwayatPemesanan.length < 2) return;

    print("\nMENGURUTKAN RIWAYAT (LAPANGAN 1-2 & JAM AWAL-AKHIR)");
    int n = riwayatPemesanan.length;
    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        bool harusSwap = false;

        // KRITERIA 1: Urutkan berdasarkan nomor lapangan terlebih dahulu (1 ke 2)
        if (riwayatPemesanan[j].nomorLapangan > riwayatPemesanan[j + 1].nomorLapangan) {
          harusSwap = true;
        } 
        // KRITERIA 2: Jika nomor lapangannya sama, baru urutkan berdasarkan jam mulai paling awal
        else if (riwayatPemesanan[j].nomorLapangan == riwayatPemesanan[j + 1].nomorLapangan) {
          if (riwayatPemesanan[j].jamMulai > riwayatPemesanan[j + 1].jamMulai) {
            harusSwap = true;
          }
        }

        if (harusSwap) {
          // Tukar posisi (Swap)
          Pesanan temp = riwayatPemesanan[j];
          riwayatPemesanan[j] = riwayatPemesanan[j + 1];
          riwayatPemesanan[j + 1] = temp;
        }
      }
    }
    print("Selesai: Riwayat berhasil diurutkan.");
  }
}