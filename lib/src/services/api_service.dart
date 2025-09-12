import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.example.com/wp-json',
    ),
  );

  Future<List<Map<String, dynamic>>> fetchPosts({int page = 1}) async {
    final res = await _dio.get('/wp/v2/posts', queryParameters: {
      '_embed': true,
      'page': page,
    });
    return (res.data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> fetchPost(String id) async {
    final res = await _dio.get('/wp/v2/posts/$id', queryParameters: {
      '_embed': true,
    });
    return res.data as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> fetchEvents() async {
    // Replace with your events endpoint or custom post type
    return [];
  }
}