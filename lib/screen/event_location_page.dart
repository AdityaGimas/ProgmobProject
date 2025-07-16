import 'package:flutter/material.dart';
import '../models/event_data.dart';
import 'event_card.dart';

class EventLocationPage extends StatelessWidget {
  final String location;

  const EventLocationPage({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final locationEvents = events.where((e) => e.location == location).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(location),
        backgroundColor: Color(0xFFF5A94D),
      ),
      body: locationEvents.isEmpty
          ? Center(child: Text('Belum ada event di lokasi ini.'))
          : ListView.builder(
              itemCount: locationEvents.length,
              itemBuilder: (context, index) => EventCard(event: locationEvents[index]),
            ),
    );
  }
}