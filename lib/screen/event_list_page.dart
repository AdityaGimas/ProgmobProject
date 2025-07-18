import 'package:flutter/material.dart';
import '../models/event_data.dart';
import 'event_card.dart';

// Halaman menampilkan daftar event di satu lokasi wisata
// Accessibility: ada slider global untuk mengubah font semua event sekaligus

class EventListPage extends StatefulWidget {
  final String namaWisata;

  const EventListPage({Key? key, required this.namaWisata}) : super(key: key);

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  double fontSize = 18; // Accessibility: ukuran font default

  @override
  Widget build(BuildContext context) {
    // Filter event berdasarkan lokasi wisata
    final filteredEvents = events.where((e) => e.location == widget.namaWisata).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Event di ${widget.namaWisata}'),
        backgroundColor: Colors.orange,
      ),
      body: filteredEvents.isEmpty
          ? const Center(child: Text('Belum ada event di lokasi ini.'))
          : Column(
              children: [
                // Daftar event (Media + Accessibility dari EventCard)
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      return EventCard(
                        event: filteredEvents[index],
                        fontSize: fontSize, // Accessibility: semua ikut slider
                      );
                    },
                  ),
                ),

                // ACCESSIBILITY: Slider di bawah untuk mengubah ukuran font global
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                              fontSize = val; // Update semua EventCard
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
    );
  }
}
