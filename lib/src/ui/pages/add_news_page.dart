import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image/image.dart' as img; // Add image package for resizing
import '../../models/news.dart';
import '../../providers/news_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';

class AddNewsPage extends ConsumerStatefulWidget {
  final News? news; // If provided, we're editing an existing news item

  const AddNewsPage({super.key, this.news});

  @override
  ConsumerState<AddNewsPage> createState() => _AddNewsPageState();
}

class _AddNewsPageState extends ConsumerState<AddNewsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  File? _imageFile;
  Uint8List? _imageBytes;
  bool _isUploading = false;
  String? _uploadError;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.news?.title ?? '');
    _contentController = TextEditingController(text: widget.news?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // Add image resizing function
  Future<Uint8List?> _resizeImage(Uint8List imageBytes) async {
    try {
      // Decode the image
      final originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) {
        print('Could not decode image');
        return imageBytes; // Return original if decoding fails
      }

      // Resize the image to maximum 800x600 while maintaining aspect ratio
      final resizedImage = img.copyResize(
        originalImage,
        width: 800,
        height: 600,
        interpolation: img.Interpolation.linear,
      );

      // Encode the resized image with 80% quality
      final resizedBytes = img.encodeJpg(resizedImage, quality: 80);
      
      print('Original image size: ${imageBytes.length} bytes');
      print('Resized image size: ${resizedBytes.length} bytes');
      print('Size reduction: ${((imageBytes.length - resizedBytes.length) / imageBytes.length * 100).toStringAsFixed(1)}%');
      
      return Uint8List.fromList(resizedBytes);
    } catch (e) {
      print('Error resizing image: $e');
      return imageBytes; // Return original if resizing fails
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Uint8List? bytes;
      
      if (kIsWeb) {
        // For web, directly get bytes from the picked file
        bytes = await pickedFile.readAsBytes();
      } else {
        // For mobile, read from file path
        final file = File(pickedFile.path);
        bytes = await file.readAsBytes();
      }

      // Resize image to reduce file size
      if (bytes != null) {
        final resizedBytes = await _resizeImage(bytes);
        if (resizedBytes != null) {
          bytes = resizedBytes;
        }
      }

      // Validate image size (1MB limit for optimized usage)
      if (bytes.length > 1 * 1024 * 1024) {
        setState(() {
          _uploadError = 'Image is too large even after resizing. Please select a smaller image.';
        });
        return;
      }

      setState(() {
        if (kIsWeb) {
          _imageBytes = bytes;
          _imageFile = null; // We can't create a File from bytes in web
        } else {
          _imageFile = File(pickedFile.path);
          _imageBytes = bytes;
        }
        _uploadError = null;
      });
    }
  }

  void _saveNews(AuthService authService) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = authService.getCurrentUser();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in to save news')),
      );
      return;
    }

    final userRole = await authService.getUserRole(user.uid);
    final userName = user.displayName ?? user.email ?? 'Unknown User';

    final newsService = ref.read(newsServiceProvider);

    // Check if we can add more news
    final canAddMore = await newsService.canAddMoreNews();
    if (widget.news == null && !canAddMore) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot add more news. Maximum limit of 15 news items reached.')),
      );
      return;
    }

    try {
      String? imageUrl;

      // Upload image if a new one was selected
      if (_imageBytes != null) {
        setState(() {
          _isUploading = true;
          _uploadError = null;
        });

        // Generate a unique filename
        final fileName = 'news_${DateTime.now().millisecondsSinceEpoch}.jpg';
        
        // Upload image with size validation (1MB limit for optimized usage)
        imageUrl = await newsService.uploadImageWithSizeValidation(
          fileName, 
          _imageBytes!.toList(), 
          1 * 1024 * 1024 // 1MB limit for optimized usage
        );

        setState(() {
          _isUploading = false;
        });

        if (imageUrl == null) {
          setState(() {
            _uploadError = 'Failed to upload image. Please check console for details.';
          });
          // Check if this might be a CORS issue
          if (kIsWeb) {
            setState(() {
              _uploadError = 'Image upload failed. This might be a CORS issue. Check console for details. '
                  'Please follow instructions in STORAGE_CORS_FIX.md to resolve this issue.';
            });
          }
          return;
        }
      }

      if (widget.news == null) {
        // Adding new news
        final news = News(
          id: '', // Will be generated by Firebase
          title: _titleController.text,
          content: _contentController.text,
          imageUrl: imageUrl,
          authorId: user.uid,
          authorName: userName,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final newsId = await newsService.addNews(news);
        if (newsId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('News added successfully')),
          );
          Navigator.of(context).pop();
        } else {
          // Check the actual number of news items
          final currentNews = await newsService.getAllNews();
          if (currentNews.length >= 15) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to add news. Maximum limit of 15 news items reached.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to add news. Please try again.')),
            );
          }
        }
      } else {
        // Updating existing news
        final canEdit = await newsService.canEditNews(
          user.uid, 
          userRole, 
          widget.news!.id
        );

        if (!canEdit) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You do not have permission to edit this news')),
          );
          return;
        }

        final updatedNews = widget.news!.copyWith(
          title: _titleController.text,
          content: _contentController.text,
          imageUrl: imageUrl ?? widget.news!.imageUrl,
          updatedAt: DateTime.now(),
        );

        final success = await newsService.updateNews(widget.news!.id, updatedNews);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('News updated successfully')),
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update news. Please try again.')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      
      String errorMessage = 'Error saving news: ${e.toString()}';
      if (kIsWeb && (e.toString().contains('CORS') || e.toString().contains('cors'))) {
        errorMessage = 'Image upload failed due to CORS policy. Check console for details and follow CORS configuration instructions.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.news == null ? 'Add News' : 'Edit News'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: authState.when(
        data: (authService) {
          if (authService == null) {
            return const Center(child: Text('Please sign in to add news'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'Content',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 10,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter content';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Image picker section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'News Image',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (_imageFile != null || _imageBytes != null) ...[
                              Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: kIsWeb && _imageBytes != null
                                    ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                                    : _imageFile != null
                                        ? Image.file(_imageFile!, fit: BoxFit.cover)
                                        : const SizedBox(),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _imageFile = null;
                                    _imageBytes = null;
                                  });
                                },
                                child: const Text('Remove Image'),
                              ),
                            ] else ...[
                              Row(
                                children: [
                                  FilledButton.icon(
                                    onPressed: _pickImage,
                                    icon: const Icon(Icons.image),
                                    label: const Text('Pick Image'),
                                  ),
                                  const SizedBox(width: 16),
                                  const Text('No image selected'),
                                ],
                              ),
                            ],
                            const SizedBox(height: 8),
                            const Text(
                              'Note: Images are limited to 5MB to stay within Firebase free plan limits.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            if (_uploadError != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                _uploadError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isUploading ? null : () => _saveNews(authService),
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: _isUploading
                            ? const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    strokeWidth: 2,
                                  ),
                                  SizedBox(width: 8),
                                  Text('Uploading...'),
                                ],
                              )
                            : Text(widget.news == null ? 'Add News' : 'Update News'),
                      ),
                    ),
                    const SizedBox(height: 16), // Add some bottom padding
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}