import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import '../models/news.dart';

class NewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collection reference for news
  CollectionReference get _newsCollection => _firestore.collection('news');

  // Get all news items (limited to 15)
  Future<List<News>> getAllNews() async {
    try {
      final querySnapshot = await _newsCollection
          .orderBy('createdAt', descending: true)
          .limit(15)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return News(
          id: doc.id,
          title: data['title'] as String,
          content: data['content'] as String,
          imageUrl: data['imageUrl'] as String?,
          authorId: data['authorId'] as String,
          authorName: data['authorName'] as String,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          updatedAt: (data['updatedAt'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      print('Error getting news: $e');
      return [];
    }
  }

  // Get a single news item by ID
  Future<News?> getNewsById(String id) async {
    try {
      final docSnapshot = await _newsCollection.doc(id).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return News(
          id: docSnapshot.id,
          title: data['title'] as String,
          content: data['content'] as String,
          imageUrl: data['imageUrl'] as String?,
          authorId: data['authorId'] as String,
          authorName: data['authorName'] as String,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          updatedAt: (data['updatedAt'] as Timestamp).toDate(),
        );
      }
      return null;
    } catch (e) {
      print('Error getting news by ID: $e');
      return null;
    }
  }

  // Add a new news item
  Future<String?> addNews(News news) async {
    try {
      // Check if we've reached the limit of 15 news items
      final countSnapshot = await _newsCollection.get();
      if (countSnapshot.size >= 15) {
        print('Cannot add more news items. Limit of 15 reached. Current count: ${countSnapshot.size}');
        return null;
      }

      final docRef = await _newsCollection.add(news.toJson());
      print('News added successfully with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error adding news: $e');
      return null;
    }
  }

  // Update an existing news item
  Future<bool> updateNews(String id, News news) async {
    try {
      await _newsCollection.doc(id).update(news.toJson());
      return true;
    } catch (e) {
      print('Error updating news: $e');
      return false;
    }
  }

  // Delete a news item
  Future<bool> deleteNews(String id) async {
    try {
      // First, get the news item to check if it has an image to delete
      final docSnapshot = await _newsCollection.doc(id).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final imageUrl = data['imageUrl'] as String?;

        // If there's an image, delete it from storage
        if (imageUrl != null && imageUrl.isNotEmpty) {
          try {
            final ref = _storage.refFromURL(imageUrl);
            await ref.delete();
          } catch (e) {
            print('Error deleting image from storage: $e');
            // Continue with news deletion even if image deletion fails
          }
        }
      }

      // Delete the news document
      await _newsCollection.doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting news: $e');
      return false;
    }
  }

  // Check if user can edit/delete a news item
  Future<bool> canEditNews(String userId, String userRole, String newsId) async {
    try {
      // Admins can edit/delete all news
      if (userRole == 'admin') {
        return true;
      }

      // Get the news item to check the author
      final docSnapshot = await _newsCollection.doc(newsId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final authorId = data['authorId'] as String;

        // Editors can edit/delete their own news
        if (userRole == 'editor' && authorId == userId) {
          return true;
        }
      }

      return false;
    } catch (e) {
      print('Error checking edit permissions: $e');
      return false;
    }
  }

  // Upload image to Firebase Storage with size validation and optimization
  Future<String?> uploadImageWithSizeValidation(
      String fileName, List<int> imageBytes, int maxSizeInBytes) async {
    try {
      // Check image size
      if (imageBytes.length > maxSizeInBytes) {
        print('Image is too large. Maximum allowed size is ${maxSizeInBytes} bytes.');
        print('Current image size: ${imageBytes.length} bytes');
        return null;
      }

      // Convert List<int> to Uint8List
      final uint8List = Uint8List.fromList(imageBytes);

      // Upload image to Firebase Storage with cache control
      final ref = _storage.ref().child('news_images/$fileName');
      final uploadTask = ref.putData(
        uint8List,
        SettableMetadata(
          cacheControl: 'public,max-age=31536000', // 1 year cache
        ),
      );
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      print('Firebase error uploading image: ${e.code} - ${e.message}');
      if (e.code == 'unavailable' || e.message?.contains('CORS') == true || e.message?.contains('cross-origin') == true) {
        print('CORS error detected. This is a common issue in web development.');
        print('To fix this issue, you need to configure CORS for your Firebase Storage bucket.');
        print('Please follow the instructions in STORAGE_CORS_FIX.md file in your project directory.');
        print('The solution involves:');
        print('1. Installing Google Cloud SDK');
        print('2. Running: gsutil cors set cors.json gs://ifaa-54ebf.appspot.com');
        print('If gsutil is not available or the bucket is not found, you can also configure CORS through the Firebase Console:');
        print('1. Go to https://console.firebase.google.com/');
        print('2. Select your project');
        print('3. Click on "Storage" in the left sidebar');
        print('4. Click on the "Rules" tab');
        print('5. Replace the existing rules with the rules from storage.rules file');
        print('6. Click "Publish" to save the rules');
      }
      return null;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
  
  // Simple image validation without actual upload
  Future<bool> validateImageSize(List<int> imageBytes, int maxSizeInBytes) async {
    try {
      // Check image size
      if (imageBytes.length > maxSizeInBytes) {
        print('Image is too large. Maximum allowed size is ${maxSizeInBytes} bytes.');
        print('Current image size: ${imageBytes.length} bytes');
        return false;
      }
      return true;
    } catch (e) {
      print('Error validating image size: $e');
      return false;
    }
  }

  // Get current news count to monitor usage
  Future<int> getCurrentNewsCount() async {
    try {
      final snapshot = await _newsCollection.get();
      return snapshot.size;
    } catch (e) {
      print('Error getting news count: $e');
      return 0;
    }
  }

  // Check if we can add more news within limits
  Future<bool> canAddMoreNews() async {
    try {
      final count = await getCurrentNewsCount();
      final canAdd = count < 15; // Your limit of 15 news items
      print('Current news count: $count, Can add more: $canAdd');
      return canAdd;
    } catch (e) {
      print('Error checking if more news can be added: $e');
      return false;
    }
  }
}