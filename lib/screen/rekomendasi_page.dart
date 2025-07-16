import 'package:flutter/material.dart';
import 'detail_rekomendasi.dart';
import 'package:progmob_kelompok/models/mode_rekomendasi.dart';

class RekomendasiPage extends StatefulWidget {
  const RekomendasiPage({super.key});

  @override
  State<RekomendasiPage> createState() => _RekomendasiPageState();
}

class _RekomendasiPageState extends State<RekomendasiPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedCategory = 0; // 0 = Semua, 1 = Penginapan, 2 = Kuliner, 3 = Wisata

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.home, 'name': 'Semua', 'color': Colors.blue},
    {'icon': Icons.hotel, 'name': 'Penginapan', 'color': Colors.teal},
    {'icon': Icons.restaurant, 'name': 'Kuliner', 'color': Colors.orange},
    {'icon': Icons.landscape, 'name': 'Wisata', 'color': Colors.green},
  ];

  List<Recommendation> get _filteredRecommendations {
    return dummyData.where((item) {
      // Filter berdasarkan kategori
      if (_selectedCategory > 0 && item.category != _selectedCategory - 1) {
        return false;
      }

      // Filter berdasarkan pencarian
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return item.name.toLowerCase().contains(query) ||
            item.description.toLowerCase().contains(query) ||
            item.shortDescription.toLowerCase().contains(query) ||
            item.labels.any((label) => label.toLowerCase().contains(query));
      }

      return true;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar dengan Search
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari tempat...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ),
          ),

          // Kategori
          SliverToBoxAdapter(
            child: Container(
              height: 100,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCategory = index;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? category['color']
                              : category['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? category['color']
                                : category['color'].withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              category['icon'],
                              color: isSelected ? Colors.white : category['color'],
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              category['name'],
                              style: TextStyle(
                                color: isSelected ? Colors.white : category['color'],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Rekomendasi List
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = _filteredRecommendations[index];
                  return _buildRecommendationCard(item);
                },
                childCount: _filteredRecommendations.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(Recommendation item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailRecommendationPage(recommendation: item),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Labels
            Stack(
              children: [
                Image.asset(
                  item.imagePath,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      item.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: item.isFavorite ? Colors.red : Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        item.isFavorite = !item.isFavorite;
                      });
                    },
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
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: labelColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.shortDescription,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        '${item.rating}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${item.reviewCount})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        '${item.distance} km',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.attach_money, color: Colors.green, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        'Rp ${item.price}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy Data
final List<Recommendation> dummyData = [
  // Penginapan
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
  // Kuliner
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
  // Wisata
  Recommendation(
    name: 'Pantai Kuta',
    category: 2,
    rating: 4.7,
    reviewCount: 500,
    distance: 1.0,
    price: '25.000',
    imagePath: 'images/kuta.jpg',
    description:
        'Pantai terkenal di Bali dengan pasir putih, ombak yang cocok untuk berselancar, dan sunset yang menakjubkan.',
    shortDescription: 'Pantai populer dengan sunset terbaik di Bali',
    labels: ['Populer'],
    mapsUrl: 'https://maps.google.com',
    websiteUrl: 'https://balitourism.com/kuta',
  ),
  Recommendation(
    name: 'Tegallalang Rice Terrace',
    category: 2,
    rating: 4.6,
    reviewCount: 300,
    distance: 1.5,
    price: '15.000',
    imagePath: 'images/tegalalang.jpg',
    description:
        'Sawah berundak yang indah dengan pemandangan hijau yang menenangkan, cocok untuk foto dan menikmati alam.',
    shortDescription: 'Sawah berundak dengan pemandangan alam yang menakjubkan',
    labels: ['Populer', 'Baru'],
    mapsUrl: 'https://maps.google.com',
    websiteUrl: 'https://balitourism.com/tegalalang',
  ),
]; 