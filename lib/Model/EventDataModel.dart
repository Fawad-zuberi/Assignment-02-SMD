class EventModel {
  final String? id;
  final String eventName;
  final String category;
  final String venue;
  final String eventAuthor;
  final String date;
  final String timing;
  final String rsvp;
  final String image;
  final String authorId;

  EventModel({
    this.id,
    required this.eventName,
    required this.category,
    required this.venue,
    required this.eventAuthor,
    required this.date,
    required this.timing,
    required this.rsvp,
    required this.image,
    required this.authorId,
  });

  factory EventModel.fromJson(Map<String, dynamic> json, String id) {
    return EventModel(
      id: id,
      eventName: json['eventName'] ?? '',
      category: json['category'] ?? '',
      venue: json['venue'] ?? '',
      eventAuthor: json['eventAuthor'] ?? '',
      date: json['date'] ?? '',
      timing: json['timing'] ?? '',
      rsvp: json['rsvp'] ?? '',
      image: json['image'] ?? '',
      authorId: json['uidAuthor'] ?? '',
    );
  }

  Map<String, dynamic> toJson(EventModel event) {
    return {
      'eventName': eventName,
      'category': category,
      'venue': venue,
      'eventAuthor': eventAuthor,
      'date': date,
      'timing': timing,
      'rsvp': rsvp,
      'image': image,
      'authorId': authorId,
    };
  }
}
