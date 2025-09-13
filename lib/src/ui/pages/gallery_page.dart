import 'package:flutter/material.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});
  
  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Matches', 'Training', 'Events', 'Awards'];
  
  // Football-related images from Unsplash
  final List<Map<String, String>> _footballImages = [
    // Match photos
    {'url': 'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=600&h=600&fit=crop', 'title': 'Championship Match', 'category': 'Matches'},
    {'url': 'https://images.unsplash.com/photo-1522778119026-d647f0596c20?w=600&h=600&fit=crop', 'title': 'Goal Celebration', 'category': 'Matches'},
    {'url': 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=600&h=600&fit=crop', 'title': 'Team Victory', 'category': 'Matches'},
    {'url': 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=600&h=600&fit=crop', 'title': 'Stadium Match', 'category': 'Matches'},
    {'url': 'https://images.unsplash.com/photo-1489944440615-453fc2b6a9a9?w=600&h=600&fit=crop', 'title': 'Derby Game', 'category': 'Matches'},
    {'url': 'https://images.unsplash.com/photo-1553778263-73a83bab9b0c?w=600&h=600&fit=crop', 'title': 'Final Whistle', 'category': 'Matches'},
    
    // Training photos
    {'url': 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=600&h=600&fit=crop', 'title': 'Skills Training', 'category': 'Training'},
    {'url': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=600&h=600&fit=crop', 'title': 'Dribbling Practice', 'category': 'Training'},
    {'url': 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=600&h=600&fit=crop', 'title': 'Youth Training', 'category': 'Training'},
    {'url': 'https://images.unsplash.com/photo-1575361204480-aadea25e6e68?w=600&h=600&fit=crop', 'title': 'Team Practice', 'category': 'Training'},
    {'url': 'https://images.unsplash.com/photo-1529900748604-07564a03e7a6?w=600&h=600&fit=crop', 'title': 'Ball Control', 'category': 'Training'},
    {'url': 'https://images.unsplash.com/photo-1484318571209-661cf29a69ea?w=600&h=600&fit=crop', 'title': 'Fitness Training', 'category': 'Training'},
    
    // Events photos
    {'url': 'https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=600&h=600&fit=crop', 'title': 'Award Ceremony', 'category': 'Events'},
    {'url': 'https://images.unsplash.com/photo-1582296650261-6e44e82bdca1?w=600&h=600&fit=crop', 'title': 'Community Event', 'category': 'Events'},
    {'url': 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=600&h=600&fit=crop', 'title': 'Youth Academy Graduation', 'category': 'Events'},
    {'url': 'https://images.unsplash.com/photo-1459865264687-595d652de67e?w=600&h=600&fit=crop', 'title': 'Season Opening', 'category': 'Events'},
    {'url': 'https://images.unsplash.com/photo-1516401266446-6432a8a07d41?w=600&h=600&fit=crop', 'title': 'Fan Meet & Greet', 'category': 'Events'},
    {'url': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600&h=600&fit=crop', 'title': 'Charity Match', 'category': 'Events'},
    
    // Awards photos
    {'url': 'https://images.unsplash.com/photo-1579952363873-27d3bfad9c0d?w=600&h=600&fit=crop', 'title': 'Golden Boot Award', 'category': 'Awards'},
    {'url': 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?w=600&h=600&fit=crop', 'title': 'Championship Trophy', 'category': 'Awards'},
    {'url': 'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=600&h=600&fit=crop', 'title': 'Player of the Year', 'category': 'Awards'},
    {'url': 'https://images.unsplash.com/photo-1526232761682-d26066ba4da3?w=600&h=600&fit=crop', 'title': 'Team Achievement', 'category': 'Awards'},
    {'url': 'https://images.unsplash.com/photo-1614107151491-6876eecbff89?w=600&h=600&fit=crop', 'title': 'Medal Ceremony', 'category': 'Awards'},
    {'url': 'https://images.unsplash.com/photo-1571835781869-48ba5bce1f98?w=600&h=600&fit=crop', 'title': 'Victory Celebration', 'category': 'Awards'},
  ];
  
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Header Section
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.orange.withOpacity(0.1),
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.photo_library,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Photo Gallery',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Explore our collection of memorable moments from matches, training, and community events',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF374151), // Better contrast than opacity
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Category Filter
        SliverToBoxAdapter(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.transparent,
                    selectedColor: Colors.orange.withOpacity(0.15),
                    checkmarkColor: Colors.orange,
                    labelStyle: TextStyle(
                      color: isSelected 
                          ? Colors.orange
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        
        // Photo Grid
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(context),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final filteredImages = _selectedCategory == 'All' 
                    ? _footballImages 
                    : _footballImages.where((img) => img['category'] == _selectedCategory).toList();
                
                if (index >= filteredImages.length) {
                  return const SizedBox.shrink();
                }
                
                final imageData = filteredImages[index];
                return _PhotoCard(
                  imageUrl: imageData['url']!,
                  title: imageData['title']!,
                  category: imageData['category']!,
                );
              },
              childCount: _selectedCategory == 'All' 
                  ? _footballImages.length 
                  : _footballImages.where((img) => img['category'] == _selectedCategory).length,
            ),
          ),
        ),
        
        // Bottom spacing
        const SliverToBoxAdapter(
          child: SizedBox(height: 32),
        ),
      ],
    );
  }
  
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 2;
  }
}

class _PhotoCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String category;
  
  const _PhotoCard({
    required this.imageUrl,
    required this.title,
    required this.category,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () {
          _showFullScreenImage(context);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Photo
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: const Icon(
                    Icons.broken_image,
                    size: 48,
                    color: Colors.grey,
                  ),
                );
              },
            ),
            
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            
            // Content Overlay
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            // Bottom info
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.zoom_in,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showFullScreenImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 32,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}