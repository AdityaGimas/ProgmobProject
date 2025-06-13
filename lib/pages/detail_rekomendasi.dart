import 'package:flutter/material.dart';
import 'package:progmob_kelompok/models/mode_rekomendasi.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class DetailRecommendationPage extends StatefulWidget {
  final Recommendation recommendation;

  const DetailRecommendationPage({super.key, required this.recommendation});

  @override
  State<DetailRecommendationPage> createState() => _DetailRecommendationPageState();
}

class _DetailRecommendationPageState extends State<DetailRecommendationPage> {
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.recommendation.imagePath,
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    widget.recommendation.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.recommendation.isFavorite
                        ? Colors.red
                        : Colors.black,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    widget.recommendation.isFavorite =
                        !widget.recommendation.isFavorite;
                  });
                },
              ),
              IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.share, color: Colors.black),
                ),
                onPressed: () {
                  Share.share(
                    'Yuk kunjungi ${widget.recommendation.name}!\n'
                    '${widget.recommendation.shortDescription}\n'
                    '⭐ ${widget.recommendation.rating} (${widget.recommendation.reviewCount} ulasan)\n'
                    '📍 ${widget.recommendation.distance} km\n'
                    '💰 Mulai Rp ${widget.recommendation.price}',
                    subject: 'Rekomendasi ${widget.recommendation.name}',
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Labels
                  if (widget.recommendation.labels.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: widget.recommendation.labels.map((label) {
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
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: labelColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: labelColor),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              color: labelColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),

                  // Title and Rating
                  Text(
                    widget.recommendation.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.recommendation.rating}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${widget.recommendation.reviewCount} ulasan)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Info Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.location_on,
                          title: 'Jarak',
                          value: '${widget.recommendation.distance} km',
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.attach_money,
                          title: 'Harga',
                          value: 'Rp ${widget.recommendation.price}',
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.recommendation.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  if (widget.recommendation.mapsUrl != null ||
                      widget.recommendation.reservationUrl != null ||
                      widget.recommendation.websiteUrl != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Aksi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (widget.recommendation.mapsUrl != null)
                          ElevatedButton.icon(
                            icon: const Icon(Icons.map),
                            label: const Text('Buka di Google Maps'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () =>
                                _launchUrl(widget.recommendation.mapsUrl),
                          ),
                        if (widget.recommendation.mapsUrl != null)
                          const SizedBox(height: 8),
                        if (widget.recommendation.reservationUrl != null)
                          ElevatedButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            label: const Text('Reservasi'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () =>
                                _launchUrl(widget.recommendation.reservationUrl),
                          ),
                        if (widget.recommendation.reservationUrl != null)
                          const SizedBox(height: 8),
                        if (widget.recommendation.websiteUrl != null)
                          ElevatedButton.icon(
                            icon: const Icon(Icons.language),
                            label: const Text('Kunjungi Website'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () =>
                                _launchUrl(widget.recommendation.websiteUrl),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
