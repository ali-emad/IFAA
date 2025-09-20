import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/news.dart';
import '../services/news_service.dart';
import '../services/auth_service.dart';
import 'auth_provider.dart';

final newsServiceProvider = Provider<NewsService>((ref) {
  return NewsService();
});

final newsListProvider = FutureProvider<List<News>>((ref) async {
  final newsService = ref.watch(newsServiceProvider);
  return await newsService.getAllNews();
});

final newsByIdProvider = FutureProvider.family<News?, String>((ref, id) async {
  final newsService = ref.watch(newsServiceProvider);
  return await newsService.getNewsById(id);
});

// Provider to check if user can edit a specific news item
final canEditNewsProvider = FutureProvider.family<bool, String>((ref, newsId) async {
  final authService = ref.watch(authServiceProvider);
  final newsService = ref.watch(newsServiceProvider);
  
  final userId = authService.currentUid;
  if (userId == null) return false;
  
  final userRole = await authService.getUserRole(userId);
  return await newsService.canEditNews(userId, userRole, newsId);
});