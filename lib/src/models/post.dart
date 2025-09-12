class Post {
  final String id;
  final String title;
  final String excerpt;
  final String imageUrl;
  final DateTime date;
  final String content;

  Post({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.imageUrl,
    required this.date,
    required this.content,
  });

  factory Post.mock(int i) {
    return Post(
      id: '$i',
      title: 'News Item #$i',
      excerpt: 'Short summary for news item #$i',
      imageUrl: 'https://picsum.photos/seed/post$i/800/450',
      date: DateTime.now().subtract(Duration(days: i * 3)),
      content: 'Long-form content for post #$i. Replace with CMS data.',
    );
  }
}