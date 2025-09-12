import 'package:flutter/material.dart';

class NewsDetailPage extends StatelessWidget {
  final String id;
  const NewsDetailPage({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'News #$id',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Article content goes here...'),
        ],
      ),
    );
  }
}