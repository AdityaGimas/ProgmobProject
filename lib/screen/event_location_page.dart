import 'package:flutter/material.dart';
import '../models/event_data.dart';
import 'event_card.dart';

// Halaman menampilkan event untuk lokasi tertentu
// ACCESSIBILITY: ada slider di bawah untuk kontrol font global

class EventLocationPage extends StatefulWidget {
  final String location;

  const EventLocationPage({super.key, required this.location});

  @override
  State<EventLocationPage> createState() => _EventLocationPageState();
}

class _EventLocationPageState extends State<EventLocationPage> {
  double fontSize = 18; // Accessibility: default font size

  @override
  Widget build(BuildContext context) {
    // Filter hanya event di lokasi ini
    final locationEvents = events.where((e) => e.location == widget.location).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.location),
        backgroundColor: const Color(0xFFF5A94D),
      ),
      body: locationEvents.isEmpty
          ? const Center(child: Text('Belum ada event di lokasi ini.'))
          : Column(
              children: [
                // Media + Accessibility (EventCard)
                Expanded(
                  child: ListView.builder(
                    itemCount: locationEvents.length,
                    itemBuilder: (context, index) => EventCard(
                      event: locationEvents[index],
                      fontSize: fontSize, // Accessibility: semua ikut slider
                    ),
                  ),
                ),

                // ACCESSIBILITY: Slider global di bawah halaman
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.format_size, color: Color(0xFFF5A94D)),
                      Expanded(
                        child: Slider(
                          min: 14,
                          max: 26,
                          divisions: 6,
                          value: fontSize,
                          label: fontSize.round().toString(),
                          onChanged: (val) {
                            setState(() {
                              fontSize = val; // Semua EventCard langsung update
                            });
                          },
                        ),
                      ),
                      Text(
                        fontSize.round().toString(),
                        style: const TextStyle(
                          color: Color(0xFFF5A94D),
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
