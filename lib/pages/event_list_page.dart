import 'package:flutter/material.dart';
import '../models/event_data.dart';         // untuk data event
import '../pages/event_card.dart';         // untuk komponen kartu event

class EventListPage extends StatelessWidget {
  final String namaWisata;

  const EventListPage({Key? key, required this.namaWisata}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ambil event yang lokasi-nya sama dengan nama wisata
    final filteredEvents = events.where((e) => e.location == namaWisata).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Event di $namaWisata'),
        backgroundColor: Colors.orange,
      ),
      body: filteredEvents.isEmpty
          ? Center(child: Text('Belum ada event di lokasi ini.'))
          : ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                return EventCard(event: filteredEvents[index]);
              },
            ),
    );
  }
}