import 'package:flutter/material.dart';
import '../models/mode_rekomendasi.dart';
import 'package:url_launcher/url_launcher.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  int selectedCategory = 0; // 0 = Penginapan, 1 = Kuliner
  SortType? currentSort;
  List<Recommendation> filteredList = [];
  bool showFavoritesOnly = false;

  @override
  void initState() {
    super.initState();
    filteredList = List.from(dummyData);
  }

  void _applyFilter() {
    setState(() {
      filteredList = dummyData
          .where((item) => item.category == selectedCategory)
          .where((item) => !showFavoritesOnly || item.isFavorite)
          .toList();

      if (currentSort != null) {
        switch (currentSort) {
          case SortType.rating:
            filteredList.sort((a, b) => b.rating.compareTo(a.rating));
            break;
          case SortType.price:
            filteredList.sort((a, b) => int.parse(a.price.replaceAll('.', ''))
                .compareTo(int.parse(b.price.replaceAll('.', ''))));
            break;
          case SortType.distance:
            filteredList.sort((a, b) => a.distance.compareTo(b.distance));
            break;
          default:
            break;
        }
      }
    });
  }

  void _toggleFavorite(Recommendation item) {
    setState(() {
      item.isFavorite = !item.isFavorite;
      _applyFilter();
    });
  }

  Future<void> _launchUrl(String? url) async {
    if (url != null) {
      if (!await launchUrl(Uri.parse(url))) {
        throw Exception('Could not launch $url');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekomendasi'),
        actions: [
          IconButton(
            icon: Icon(
              showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
              color: showFavoritesOnly ? Colors.red : null,
            ),
            onPressed: () {
              setState(() {
                showFavoritesOnly = !showFavoritesOnly;
                _applyFilter();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Segmented Control
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedCategory == 0
                          ? Colors.teal
                          : Colors.grey[300],
                    ),
                    onPressed: () {
                      setState(() {
                        selectedCategory = 0;
                        _applyFilter();
                      });
                    },
                    child: Text(
                      'Penginapan',
                      style: TextStyle(
                        color: selectedCategory == 0
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedCategory == 1
                          ? Colors.teal
                          : Colors.grey[300],
                    ),
                    onPressed: () {
                      setState(() {
                        selectedCategory = 1;
                        _applyFilter();
                      });
                    },
                    child: Text(
                      'Kuliner',
                      style: TextStyle(
                        color: selectedCategory == 1
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text('Urutkan: '),
                const SizedBox(width: 8),
                DropdownButton<SortType?>(
                  value: currentSort,
                  hint: const Text('Pilih'),
                  items: SortType.values.map((type) {
                    String label;
                    switch (type) {
                      case SortType.rating:
                        label = 'Rating';
                        break;
                      case SortType.price:
                        label = 'Harga';
                        break;
                      case SortType.distance:
                        label = 'Jarak';
                        break;
                    }
                    return DropdownMenuItem(
                      value: type,
                      child: Text(label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      currentSort = value;
                      _applyFilter();
                    });
                  },
                ),
              ],
            ),
          ),

          // List Data
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8)),
                            child: Image.asset(
                              item.imagePath,
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: Icon(
                                item.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: item.isFavorite ? Colors.red : Colors.white,
                              ),
                              onPressed: () => _toggleFavorite(item),
                            ),
                          ),
                          if (item.labels.isNotEmpty)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Wrap(
                                spacing: 4,
                                children: item.labels.map((label) {
                                  Color labelColor;
                                  switch (label.toLowerCase()) {
                                    case 'baru':
                                      labelColor = Colors.blue;
                                      break;
                                    case 'populer':
                                      labelColor = Colors.orange;
                                      break;
                                    case 'murah':
                                      labelColor = Colors.green;
                                      break;
                                    default:
                                      labelColor = Colors.grey;
                                  }
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: labelColor.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      label,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.shortDescription,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${item.rating} (${item.reviewCount} ulasan)',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 12),
                                const Icon(Icons.location_on,
                                    color: Colors.red, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${item.distance} km',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 12),
                                const Icon(Icons.attach_money,
                                    color: Colors.green, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Rp ${item.price}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (item.mapsUrl != null)
                                  TextButton.icon(
                                    icon: const Icon(Icons.map, size: 16),
                                    label: const Text('Maps'),
                                    onPressed: () => _launchUrl(item.mapsUrl),
                                  ),
                                if (item.reservationUrl != null)
                                  TextButton.icon(
                                    icon: const Icon(Icons.calendar_today,
                                        size: 16),
                                    label: const Text('Reservasi'),
                                    onPressed: () =>
                                        _launchUrl(item.reservationUrl),
                                  ),
                                if (item.websiteUrl != null)
                                  TextButton.icon(
                                    icon: const Icon(Icons.language, size: 16),
                                    label: const Text('Website'),
                                    onPressed: () => _launchUrl(item.websiteUrl),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Dummy Data
final List<Recommendation> dummyData = [
  Recommendation(
    name: 'Hotel Sejahtera',
    category: 0,
    rating: 4.5,
    reviewCount: 120,
    distance: 0.5,
    price: '450.000',
    imagePath: 'images/hotel1.jpeg',
    description:
        'Hotel nyaman di pusat kota, dekat destinasi wisata utama dengan fasilitas lengkap dan pemandangan indah.',
    shortDescription: 'Hotel bintang 4 dengan pemandangan kota yang menakjubkan',
    labels: ['Populer', 'Baru'],
    mapsUrl: 'https://maps.google.com',
    reservationUrl: 'https://wa.me/1234567890',
    websiteUrl: 'https://hotelsejahtera.com',
  ),
  Recommendation(
    name: 'Pondok Indah',
    category: 0,
    rating: 4.2,
    reviewCount: 85,
    distance: 0.3,
    price: '250.000',
    imagePath: 'images/hotel2.jpeg',
    description:
        'Penginapan sederhana tapi nyaman, cocok untuk backpacker dan wisatawan yang ingin dekat dengan alam.',
    shortDescription: 'Penginapan ekonomis dengan suasana alam yang tenang',
    labels: ['Murah'],
    mapsUrl: 'https://maps.google.com',
    reservationUrl: 'https://wa.me/1234567890',
  ),
  Recommendation(
    name: 'Warung Sari Rasa',
    category: 1,
    rating: 4.5,
    reviewCount: 200,
    distance: 0.2,
    price: '30.000',
    imagePath: 'images/food1.jpeg',
    description:
        'Warung lokal dengan menu khas Bali, rasa autentik dan harga bersahabat. Favorit wisatawan.',
    shortDescription: 'Warung lokal dengan cita rasa autentik Bali',
    labels: ['Populer', 'Murah'],
    mapsUrl: 'https://maps.google.com',
    websiteUrl: 'https://warungsarirasa.com',
  ),
  Recommendation(
    name: 'Cafe Santai',
    category: 1,
    rating: 4.8,
    reviewCount: 150,
    distance: 0.4,
    price: '50.000',
    imagePath: 'images/food2.jpeg',
    description:
        'Tempat nongkrong nyaman dengan menu western & lokal, view sawah, cocok untuk sunset-an bareng teman.',
    shortDescription: 'Cafe dengan pemandangan sawah yang menenangkan',
    labels: ['Baru', 'Populer'],
    mapsUrl: 'https://maps.google.com',
    reservationUrl: 'https://wa.me/1234567890',
    websiteUrl: 'https://cafesantai.com',
  ),
];
