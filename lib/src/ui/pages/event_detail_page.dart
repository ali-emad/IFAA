import 'package:flutter/material.dart';

class EventDetailPage extends StatelessWidget {
  final String id;
  const EventDetailPage({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Event #$id',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Full event details go here.'),
        ],
      ),
    );
  }
}