import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryEntry {
  final String? id;
  DateTime date;
  String description;
  int rating;

  DiaryEntry(
      {this.id,
      required this.date,
      required this.description,
      required this.rating});

  // Convert a DiaryEntry to Map
  Map<String, dynamic> toMap() {
    return {'date': date, 'description': description, 'rating': rating};
  }

  // Convert a Map to DiaryEntry
  static DiaryEntry fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return DiaryEntry(
      id: doc.id,
      date: map['date'].toDate(),
      description: map['description'],
      rating: map['rating'],
    );
  }
}
