import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../models/news.dart';
import '../../providers/news_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';
import 'add_news_page.dart';

class NewsManagementPage extends ConsumerStatefulWidget {
  const NewsManagementPage({super.key});

  @override
  ConsumerState<NewsManagementPage> createState() => _NewsManagementPageState();
}

class _NewsManagementPageState extends ConsumerState<NewsManagementPage> {
  @override
  Widget build(BuildContext context) {
    final newsListAsync = ref.watch(newsListProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Management'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddNewsPage(),
                ),
              );
            },
            style: IconButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
      body: newsListAsync.when(
        data: (newsList) {
          if (newsList.isEmpty) {
            return const Center(
              child: Text('No news items found'),
            );
          }

          return ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final news = newsList[index];
              return _NewsItemTile(
                news: news,
                authState: authState,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error loading news: $error')),
      ),
    );
  }
}

class _NewsItemTile extends ConsumerWidget {
  final News news;
  final AsyncValue<AuthService?> authState;

  const _NewsItemTile({
    required this.news,
    required this.authState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canEditNewsAsync = ref.watch(canEditNewsProvider(news.id));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          news.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              news.content.length > 100
                  ? '${news.content.substring(0, 100)}...'
                  : news.content,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'By ${news.authorName}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat('MMM dd, yyyy').format(news.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: canEditNewsAsync.when(
          data: (canEdit) {
            if (!canEdit) {
              return const Icon(Icons.visibility, color: Colors.grey);
            }

            return PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  // Navigate to edit page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddNewsPage(news: news),
                    ),
                  );
                } else if (value == 'delete') {
                  // Show delete confirmation
                  _showDeleteConfirmation(context, ref, news);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => const Icon(Icons.error, color: Colors.red),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, News news) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete News'),
        content: Text('Are you sure you want to delete "${news.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteNews(ref, news);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteNews(WidgetRef ref, News news) {
    final newsService = ref.read(newsServiceProvider);
    
    newsService.deleteNews(news.id).then((success) {
      if (success) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          const SnackBar(content: Text('News deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          const SnackBar(content: Text('Failed to delete news')),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(ref.context).showSnackBar(
        SnackBar(content: Text('Error deleting news: $error')),
      );
    });
  }
}