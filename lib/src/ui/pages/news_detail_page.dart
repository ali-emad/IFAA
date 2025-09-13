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
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF1F2937), // Dark color for better readability
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Article content goes here...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF1F2937), // Dark color for better readability
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}