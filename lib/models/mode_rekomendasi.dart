class Recommendation {
  final String name;
  final int category; // 0 = Penginapan, 1 = Kuliner, 2 = Wisata
  final double rating;
  final int reviewCount; // Jumlah ulasan
  final double distance;
  final String price;
  final String imagePath;
  final String description;
  final String shortDescription; // Deskripsi singkat
  final List<String> labels; // Label seperti "Baru", "Populer", "Murah"
  final String? mapsUrl; // URL Google Maps
  final String? reservationUrl; // URL WA/Form reservasi
  final String? websiteUrl; // URL website
  bool isFavorite; // Status favorit

  Recommendation({
    required this.name,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.price,
    required this.imagePath,
    required this.description,
    required this.shortDescription,
    required this.labels,
    this.mapsUrl,
    this.reservationUrl,
    this.websiteUrl,
    this.isFavorite = false,
  });
}

// Enum untuk tipe filter
enum SortType {
  rating,
  price,
  distance,
}

// Enum untuk tipe label
enum LabelType {
  baru,
  populer,
  murah,
}

// Enum untuk kategori
enum CategoryType {
  semua,
  penginapan,
  kuliner,
  wisata,
}
