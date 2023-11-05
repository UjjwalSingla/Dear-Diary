import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryEntry {
  DateTime date;
  String description;
  int rating;

  DiaryEntry(
      {required this.date, required this.description, required this.rating});

  // Convert a DiaryEntry to Map
  Map<String, dynamic> toMap() {
    return {'date': date, 'description': description, 'rating': rating};
  }

  // Convert a Map to DiaryEntry
  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      date: map['date'].toDate(),
      description: map['description'],
      rating: map['rating'],
    );
  }
}
