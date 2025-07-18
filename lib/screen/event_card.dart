import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event_data.dart';
import 'package:share_plus/share_plus.dart';

// Komponen kartu untuk menampilkan informasi event
// Media: gambar event (slide + fullscreen), share button
// Accessibility: ukuran font bisa dikontrol dari parent

class EventCard extends StatefulWidget {
  final Event event;
  final double fontSize; // Accessibility: ukuran font global dikirim dari parent

  const EventCard({
    Key? key,
    required this.event,
    this.fontSize = 18, // Default ukuran font
  }) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  int _currentImageIndex = 0; // Media: untuk indikator slide gambar

  // Media: menampilkan gambar fullscreen saat ditap
  void _showFullscreenImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.contain, // Media: menyesuaikan ukuran layar
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Accessibility: semua ukuran font proporsional terhadap slider parent
    double titleFont = widget.fontSize;
    double descFont = widget.fontSize - 2;
    double dateFont = widget.fontSize - 4;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MEDIA: Slide gambar event (PageView)
          Stack(
            children: [
              SizedBox(
                height: 180,
                child: PageView.builder(
                  itemCount: widget.event.imageUrls.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index; // update dot indicator
                    });
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _showFullscreenImage(widget.event.imageUrls[index]), // Tap = fullscreen
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.asset(
                          widget.event.imageUrls[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // MEDIA: indikator dot untuk slide gambar
              Positioned(
                bottom: 8,
                right: 8,
                child: Row(
                  children: List.generate(
                    widget.event.imageUrls.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentImageIndex == index
                            ? const Color(0xFFF5A94D)
                            : Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Konten teks (judul, deskripsi, tanggal)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Accessibility: ukuran font ikut slider parent
                Text(
                  widget.event.title,
                  style: GoogleFonts.poppins(
                    fontSize: titleFont,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2F2F2F),
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  widget.event.description,
                  style: GoogleFonts.poppins(
                    fontSize: descFont,
                    color: const Color(0xFF6D6D6D),
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Color(0xFF6D6D6D)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.event.date,
                        style: GoogleFonts.poppins(
                          fontSize: dateFont,
                          color: const Color(0xFF6D6D6D),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),

                // MEDIA: tombol share event
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.share, color: Color(0xFFF5A94D)),
                    onPressed: () {
                      Share.share(
                        'Cek event ini: ${widget.event.title}\n'
                        '${widget.event.description}\n'
                        'Jadwal: ${widget.event.date}',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
