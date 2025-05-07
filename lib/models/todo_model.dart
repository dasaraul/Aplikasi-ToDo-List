// lib/models/todo_model.dart
class TodoItem {
  String id;
  String judul;
  bool selesai;
  DateTime? tanggalDibuat;
  DateTime? tanggalSelesai;

  TodoItem({
    required this.id,
    required this.judul,
    this.selesai = false,
    DateTime? tanggalDibuat,
    this.tanggalSelesai,
  }) : this.tanggalDibuat = tanggalDibuat ?? DateTime.now();

  // Untuk konversi dari JSON (untuk membaca dari penyimpanan)
  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'],
      judul: json['judul'],
      selesai: json['selesai'] ?? false,
      tanggalDibuat: json['tanggalDibuat'] != null
          ? DateTime.parse(json['tanggalDibuat'])
          : null,
      tanggalSelesai: json['tanggalSelesai'] != null
          ? DateTime.parse(json['tanggalSelesai'])
          : null,
    );
  }

  // Untuk konversi ke JSON (untuk menyimpan ke penyimpanan)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'selesai': selesai,
      'tanggalDibuat': tanggalDibuat?.toIso8601String(),
      'tanggalSelesai': tanggalSelesai?.toIso8601String(),
    };
  }

  // Membuat salinan objek dengan perubahan yang diberikan
  TodoItem copyWith({
    String? id,
    String? judul,
    bool? selesai,
    DateTime? tanggalDibuat,
    DateTime? tanggalSelesai,
  }) {
    return TodoItem(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      selesai: selesai ?? this.selesai,
      tanggalDibuat: tanggalDibuat ?? this.tanggalDibuat,
      tanggalSelesai: tanggalSelesai ?? this.tanggalSelesai,
    );
  }

  @override
  String toString() {
    return 'TodoItem{id: $id, judul: $judul, selesai: $selesai}';
  }
}