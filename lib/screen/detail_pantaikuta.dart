import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import '../models/detailwisatamodel.dart';
import 'event_list_page.dart';
import 'reservation_form_page.dart';

class DetailPantaiKutaPage extends StatefulWidget {
  final Wisata wisata;
  const DetailPantaiKutaPage({Key? key, required this.wisata})
    : super(key: key);

  @override
  State<DetailPantaiKutaPage> createState() => _DetailPantaiKutaPageState();
}

class _DetailPantaiKutaPageState extends State<DetailPantaiKutaPage> {
  int _currentPage = 0;
  bool _isBookmarked = false;
  double fontSize = 16;
  VideoPlayerController? _videoController;

  final String googleMapsUrl =
      'https://www.google.com/maps/place/Kuta+Beach/@-8.717761,115.168236,17z/data=!3m1!4b1!4m6!3m5!1s0x2dd2470b0b0b0b0b:0x0b0b0b0b0b0b0b0b!8m2!3d-8.717761!4d115.170424!16s%2Fg%2F11c4w2w2w2';

  final List<Map<String, String>> media = [
    {'type': 'image', 'path': 'images/kuta.jpg'},
    {'type': 'image', 'path': 'images/kuta2.jpg'},
    {'type': 'image', 'path': 'images/kuta3.jpg'},
    {'type': 'video', 'path': 'assets/video/Kuta_fix.mp4'},
  ];

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/video/Kuta_fix.mp4')
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
      await launchUrl(
        Uri.parse(googleMapsUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka Google Maps')),
      );
    }
  }

  void _shareInfo() {
    Share.share(
      'Yuk kunjungi Pantai Kuta di Badung!\n'
      'Jam buka: 24 Jam\n'
      'Pantai ikonik dengan ombak surfing dan sunset romantis. Dikelilingi kafe dan pusat perbelanjaan.\n'
      'Lokasi: $googleMapsUrl',
      subject: 'Rekomendasi Wisata Bali',
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
              // Carousel media
              SizedBox(
                height: 300,
                width: double.infinity,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(32),
                      ),
                      child: PageView.builder(
                        itemCount: media.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                            if (index == media.length - 1 &&
                                _videoController != null &&
                                _videoController!.value.isInitialized) {
                              _videoController!.play();
                            } else {
                              _videoController?.pause();
                            }
                          });
                        },
                        itemBuilder: (context, index) {
                          final item = media[index];
                          if (item['type'] == 'image') {
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(item['path']!, fit: BoxFit.cover),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.15),
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.35),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (item['type'] == 'video' &&
                              _videoController != null &&
                              _videoController!.value.isInitialized) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio:
                                      _videoController!.value.aspectRatio,
                                  child: VideoPlayer(_videoController!),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: IconButton(
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
                                ),
                              ],
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                    // Tombol kembali & bookmark
                    Positioned(
                      top: 24,
                      left: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.85),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF2F2F2F),
                          ),
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
                            _isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color:
                                _isBookmarked
                                    ? Color(0xFFF5A94D)
                                    : Color(0xFF2F2F2F),
                          ),
                          onPressed: () {
                            setState(() {
                              _isBookmarked = !_isBookmarked;
                            });
                          },
                        ),
                      ),
                    ),
                    // Dots
                    Positioned(
                      bottom: 18,
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
                              color:
                                  _currentPage == index
                                      ? const Color(0xFFF5A94D)
                                      : Colors.white.withOpacity(0.8),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info card
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 4,
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
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
                                const Icon(
                                  Icons.place,
                                  color: Color(0xFFF5A94D),
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.wisata.lokasi,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF6D6D6D),
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.access_time,
                                  color: Color(0xFFF5A94D),
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  "24 Jam",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF6D6D6D),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Deskripsi menggunakan fontSize dinamis
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
                        "Pantai Kuta adalah destinasi wisata favorit di Bali dengan pasir putih dan ombak ideal untuk selancar. Dikelilingi kafe, restoran, dan pusat perbelanjaan.",
                        style: TextStyle(
                          fontSize: fontSize,
                          color: Color(0xFF2F2F2F),
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Tombol aksi: Rute, Reservasi, Lihat Event
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _launchMaps,
                            icon: const Icon(Icons.map, color: Colors.white),
                            label: const Text(
                              "Rute",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF5A94D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 2,
                              shadowColor: Colors.orangeAccent.withOpacity(0.2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ReservationFormPage(
                                        namaWisata: widget.wisata.nama,
                                      ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Reservasi",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 2,
                              shadowColor: Colors.greenAccent.withOpacity(0.2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => EventListPage(
                                        namaWisata: widget.wisata.nama,
                                      ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.event,
                              color: Color(0xFFF5A94D),
                            ),
                            label: const Text(
                              "Lihat Event",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFFF5A94D),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              side: const BorderSide(color: Color(0xFFF5A94D)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 2,
                              shadowColor: Colors.orangeAccent.withOpacity(0.2),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Icon info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _InfoIcon(
                          icon: Icons.surfing_rounded,
                          label: "Surfing",
                          color: Colors.blue,
                        ),
                        _InfoIcon(
                          icon: Icons.shopping_bag_rounded,
                          label: "Shopping",
                          color: Colors.pink,
                        ),
                        _InfoIcon(
                          icon: Icons.wb_sunny_rounded,
                          label: "Sunset",
                          color: Colors.orange,
                        ),
                      ],
                    ),

                    // Slider
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
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
                              onChanged: (val) {
                                setState(() {
                                  fontSize = val;
                                });
                              },
                            ),
                          ),
                          Text(
                            fontSize.round().toString(),
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
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
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF6D6D6D)),
        ),
      ],
    );
  }
}
