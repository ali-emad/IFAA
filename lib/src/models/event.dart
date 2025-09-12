class EventModel {
  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final String location;
  final String description;
  final String? imageUrl;

  EventModel({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.location,
    required this.description,
    this.imageUrl,
  });

  factory EventModel.mock(int i) {
    return EventModel(
      id: '$i',
      title: 'Futsal Competition #$i',
      start: DateTime.now().add(Duration(days: i * 7)),
      end: DateTime.now().add(Duration(days: i * 7, hours: 8)),
      location: 'Peel Park, Gladesville',
      description: 'Event details for competition #$i',
      imageUrl: 'https://picsum.photos/seed/event$i/1200/600',
    );
  }
}