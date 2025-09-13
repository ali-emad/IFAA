import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/post.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});
  
  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Tournaments', 'Training', 'Community', 'Announcements'];
  Post? _selectedPost;
  
  void _selectPost(Post post) {
    setState(() {
      _selectedPost = post;
    });
  }
  
  void _clearSelection() {
    setState(() {
      _selectedPost = null;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final posts = List.generate(10, Post.mock);
    final filteredPosts = _filterPosts(posts);
    
    // If a post is selected, show the full article view
    if (_selectedPost != null) {
      return _ArticleDetailView(
        post: _selectedPost!,
        onBack: _clearSelection,
      );
    }
    
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
                  Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.article,
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
                        'Latest News',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Stay updated with IFAA announcements, matches, and community updates',
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
        
        // Category Chips
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
                    selectedColor: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
                    checkmarkColor: Theme.of(context).colorScheme.secondary,
                    labelStyle: TextStyle(
                      color: isSelected 
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        
        // Featured Article (First Post)
        if (filteredPosts.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _FeaturedArticleCard(
                post: filteredPosts.first,
                onTap: () => _selectPost(filteredPosts.first),
              ),
            ),
          ),
        
        // Regular Articles
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Skip first post as it's featured
                final post = filteredPosts[index + 1];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ArticleCard(
                    post: post,
                    onTap: () => _selectPost(post),
                  ),
                );
              },
              childCount: filteredPosts.length - 1,
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
  
  List<Post> _filterPosts(List<Post> posts) {
    if (_selectedCategory == 'All') return posts;
    // In a real app, posts would have categories
    return posts;
  }
}

class _FeaturedArticleCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;
  
  const _FeaturedArticleCard({required this.post, required this.onTap});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Image
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(post.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'FEATURED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            post.excerpt,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('MMM dd, yyyy').format(post.date),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;
  
  const _ArticleCard({required this.post, required this.onTap});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Article Image
              Container(
                width: 120,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(post.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Article Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post.excerpt,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF374151), // Better contrast than opacity
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: const Color(0xFF6B7280), // Lighter gray for subtle info
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM dd').format(post.date),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF6B7280), // Lighter gray for subtle info
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Article Detail View Component
class _ArticleDetailView extends StatelessWidget {
  final Post post;
  final VoidCallback onBack;
  
  const _ArticleDetailView({
    required this.post,
    required this.onBack,
  });
  
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Back button and header
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Article Details',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Article content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Featured Image
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(post.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Article title
                Text(
                  post.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Article meta
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: const Color(0xFF6B7280), // Lighter gray for metadata
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM dd, yyyy').format(post.date),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B7280), // Lighter gray for metadata
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.article,
                      size: 16,
                      color: const Color(0xFF6B7280), // Lighter gray for metadata
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'IFAA News',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B7280), // Lighter gray for metadata
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Article content
                Text(
                  post.content,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    color: const Color(0xFF1F2937), // Explicitly set dark color for better readability
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Back button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to News'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}