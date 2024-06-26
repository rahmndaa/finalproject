import 'dart:io';

void main() {
  var aplikasi = AplikasiSewaMobil();
  aplikasi.jalankan();
}

class AplikasiSewaMobil {
  List<Mobil> mobils = [];
  List<Pelanggan> pelanggans = [];
  List<Sewa> sewas = [];
  Map<int, double> daftarHarga = {};
  int nextMobilId = 1;

  void jalankan() {
    print('Selamat Datang di Rental Mobil');
    tambahkanMobil(); // Meminta pengguna untuk menambahkan mobil
    pelanggans.add(buatPelanggan());

    while (true) {
      buatDaftarHarga();
      sewas.add(buatSewa(pelanggans.last));
      var sewa = sewas.last;
      print('\nDetail Sewa:');
      print('Pelanggan: ${sewa.pelanggan.nama}');
      print('Mobil: ${sewa.mobil.merek} ${sewa.mobil.model}');
      print('Periode Sewa: ${sewa.tanggalMulai} hingga ${sewa.tanggalSelesai}');
      print('Harga Total: ${sewa.hargaTotal}');
      stdout.write('\nTambahkan pelanggan lain? (ya/tidak): ');
      if (stdin.readLineSync()!.toLowerCase() != 'ya') break;
      pelanggans.add(buatPelanggan());
    }
  }

  void tambahkanMobil() {
    stdout.write('Masukkan jumlah mobil yang ingin ditambahkan: ');
    int jumlahMobil = int.parse(stdin.readLineSync()!);

    for (var i = 0; i < jumlahMobil; i++) {
      stdout.write('\nMasukkan detail mobil ke-${i + 1}\n');
      stdout.write('Merek: ');
      String merek = stdin.readLineSync()!;
      stdout.write('Model: ');
      String model = stdin.readLineSync()!;
      stdout.write('Tahun: ');
      int tahun = int.parse(stdin.readLineSync()!);
      stdout.write('Tersedia (ya/tidak): ');
      bool tersedia = stdin.readLineSync()!.toLowerCase() == 'ya';
      mobils.add(Mobil(
          id: nextMobilId++, merek: merek, model: model, tahun: tahun, tersedia: tersedia));
    }
  }

  Pelanggan buatPelanggan() {
    stdout.write('Masukkan detail pelanggan\nNama: ');
    String nama = stdin.readLineSync()!;
    stdout.write('KTP: ');
    String ktp = stdin.readLineSync()!;
    stdout.write('Alamat: ');
    String alamat = stdin.readLineSync()!;
    return Pelanggan(nama: nama, ktp: ktp, alamat: alamat);
  }

  void buatDaftarHarga() {
    for (var mobil in mobils) {
      stdout.write('Harga sewa per hari untuk mobil ${mobil.merek} ${mobil.model}: ');
      daftarHarga[mobil.id] = double.parse(stdin.readLineSync()!);
    }
  }

  Sewa buatSewa(Pelanggan pelanggan) {
    stdout.write('ID Sewa: ');
    int id = int.parse(stdin.readLineSync()!);

    // Pilih mobil yang akan disewa
    print('\nPilih mobil yang akan disewa:');
    for (var i = 0; i < mobils.length; i++) {
      var mobil = mobils[i];
      print('${i + 1}. ${mobil.merek} ${mobil.model}');
    }
    stdout.write('Pilih nomor mobil: ');
    int pilihanMobil = int.parse(stdin.readLineSync()!) - 1;
    Mobil mobil = mobils[pilihanMobil];

    stdout.write('Tanggal Mulai (YYYY-MM-DD): ');
    DateTime tanggalMulai = DateTime.parse(stdin.readLineSync()!);
    stdout.write('Durasi (hari): ');
    int durasi = int.parse(stdin.readLineSync()!);
    DateTime tanggalSelesai = tanggalMulai.add(Duration(days: durasi));
    double hargaTotal = daftarHarga[mobil.id]! * durasi;
    return Sewa(
        id: id,
        mobil: mobil,
        pelanggan: pelanggan,
        tanggalMulai: tanggalMulai,
        tanggalSelesai: tanggalSelesai,
        hargaTotal: hargaTotal);
  }
}

class Mobil {
  int id;
  String merek;
  String model;
  int tahun;
  bool tersedia;
  Mobil(
      {required this.id,
      required this.merek,
      required this.model,
      required this.tahun,
      required this.tersedia});
}

class Pelanggan {
  String nama;
  String ktp;
  String alamat;
  Pelanggan(
      {required this.nama, required this.ktp, required this.alamat});
}

class Sewa {
  int id;
  Mobil mobil;
  Pelanggan pelanggan;
  DateTime tanggalMulai;
  DateTime tanggalSelesai;
  double hargaTotal;
  Sewa(
      {required this.id,
      required this.mobil,
      required this.pelanggan,
      required this.tanggalMulai,
      required this.tanggalSelesai,
      required this.hargaTotal});
}
