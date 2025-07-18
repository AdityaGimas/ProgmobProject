import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import '../models/detailwisatamodel.dart';
import 'event_list_page.dart';
import 'reservation_form_page.dart';

class DetailUbudPage extends StatefulWidget {
  final Wisata wisata;
  const DetailUbudPage({Key? key, required this.wisata}) : super(key: key);

  @override
  State<DetailUbudPage> createState() => _DetailUbudPageState();
}

class _DetailUbudPageState extends State<DetailUbudPage> {
  int _currentPage = 0;
  bool _isBookmarked = false;
  double fontSize = 16; // ✅ Variabel tambahan fontSize
  VideoPlayerController? _videoController;

  final String googleMapsUrl =
      'https://www.google.com/maps/place/Ubud/@-8.506,115.262,17z/data=!3m1!4b1!4m6!3m5!1s0x2dd2470b0b0b0b0b:0x0b0b0b0b0b0b0b0b!8m2!3d-8.506!4d115.264!16s%2Fg%2F11c4w2w2w2';

  final List<Map<String, String>> media = [
    {'type': 'image', 'path': 'images/ubud.jpg'},
    {'type': 'image', 'path': 'images/ubud2.jpg'},
    {'type': 'image', 'path': 'images/ubud3.jpg'},
    {'type': 'video', 'path': 'assets/video/Ubud_fix.mp4'},
  ];

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/video/Ubud_fix.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
    _videoController?.setLooping(true);
    _videoController?.setVolume(0.0);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _launchMaps() async {
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka Google Maps')),
      );
    }
  }

  void _shareInfo() {
    Share.share(
      'Yuk kunjungi Ubud di Gianyar!\n'
      'Jam buka: 24 Jam\n'
      'Ubud adalah pusat budaya Bali dengan museum seni, pasar tradisional, dan hutan monyet. Cocok untuk penikmat seni dan alam.\n'
      'Lokasi: $googleMapsUrl',
      subject: 'Rekomendasi Wisata Bali - Ubud',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9E8D9),
      floatingActionButton: FloatingActionButton(
        onPressed: _shareInfo,
        backgroundColor: const Color(0xFFF5A94D),
        child: const Icon(Icons.share, color: Colors.white, size: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carousel
              SizedBox(
                height: 300,
                width: double.infinity,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
                      child: PageView.builder(
                        itemCount: media.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                            if (index == media.length - 1) {
                              _videoController?.play();
                            } else {
                              _videoController?.pause();
                            }
                          });
                        },
                        itemBuilder: (context, index) {
                          final item = media[index];
                          if (item['type'] == 'image') {
                            return Image.asset(item['path']!, fit: BoxFit.cover);
                          } else if (item['type'] == 'video' && _videoController?.value.isInitialized == true) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: _videoController!.value.aspectRatio,
                                  child: VideoPlayer(_videoController!),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _videoController!.value.isPlaying
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_filled,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _videoController!.value.isPlaying
                                          ? _videoController!.pause()
                                          : _videoController!.play();
                                    });
                                  },
                                ),
                              ],
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    Positioned(
                      top: 24,
                      left: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.85),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Color(0xFF2F2F2F)),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 24,
                      right: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.85),
                        child: IconButton(
                          icon: Icon(
                            _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                            color: _isBookmarked ? Color(0xFFF5A94D) : Color(0xFF2F2F2F),
                          ),
                          onPressed: () {
                            setState(() {
                              _isBookmarked = !_isBookmarked;
                            });
                          },
                          tooltip: _isBookmarked ? 'Hapus Bookmark' : 'Tambah Bookmark',
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          media.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 22 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index ? const Color(0xFFF5A94D) : Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Konten
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      elevation: 4,
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.wisata.nama,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2F2F2F),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.place, color: Color(0xFFF5A94D), size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  widget.wisata.lokasi,
                                  style: const TextStyle(fontSize: 16, color: Color(0xFF6D6D6D)),
                                ),
                                const Spacer(),
                                const Icon(Icons.access_time, color: Color(0xFFF5A94D), size: 20),
                                const SizedBox(width: 4),
                                const Text(
                                  "24 Jam",
                                  style: TextStyle(fontSize: 16, color: Color(0xFF6D6D6D)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Ubud adalah pusat budaya Bali dengan museum seni, pasar tradisional, dan hutan monyet. Cocok untuk penikmat seni dan alam.",
                        style: TextStyle(
                          fontSize: fontSize,
                          color: const Color(0xFF2F2F2F),
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _launchMaps,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF5A94D),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            icon: const Icon(Icons.map, color: Colors.white),
                            label: const Text(
                              "Rute",
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => EventListPage(namaWisata: widget.wisata.nama),
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              side: const BorderSide(color: Color(0xFFF5A94D)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            icon: const Icon(Icons.event, color: Color(0xFFF5A94D)),
                            label: const Text(
                              "Lihat Event",
                              style: TextStyle(fontSize: 16, color: Color(0xFFF5A94D), fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => ReservationFormPage(namaWisata: widget.wisata.nama),
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            icon: const Icon(Icons.calendar_month, color: Colors.white),
                            label: const Text(
                              "Reservasi",
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _InfoIcon(icon: Icons.art_track_rounded, label: "Seni", color: Colors.purple),
                        _InfoIcon(icon: Icons.directions_walk_rounded, label: "Tari", color: Colors.orange),
                        _InfoIcon(icon: Icons.shopping_bag_rounded, label: "Pasar", color: Colors.pink),
                      ],
                    ),
                    // Slider
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      color: Colors.orange.withOpacity(0.1),
                      child: Row(
                        children: [
                          const Icon(Icons.format_size, color: Colors.orange),
                          Expanded(
                            child: Slider(
                              min: 14,
                              max: 26,
                              divisions: 6,
                              value: fontSize,
                              label: fontSize.round().toString(),
                              onChanged: (val) => setState(() => fontSize = val),
                            ),
                          ),
                          Text(
                            fontSize.round().toString(),
                            style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoIcon({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF6D6D6D))),
      ],
    );
  }
}
