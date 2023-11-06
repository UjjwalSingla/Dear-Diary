import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary/model/diary_entry_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DiaryService {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference entryCollection;
  DiaryService()
      : entryCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('enteries');

  // Diary Entry Management
  Future<DocumentReference<Object?>> addEntry(DiaryEntry entry) async {
    return await entryCollection.add(entry.toMap());
  }

  Stream<List<DiaryEntry>> getAllEntries() {
    return entryCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => DiaryEntry.fromMap(doc)).toList();
    });
  }

  Future<void> updateDiaryEntry(DiaryEntry updatedEntry) async {
    await entryCollection.doc(updatedEntry.id).update(updatedEntry.toMap());
  }

  Future<void> removeEntry(String entryId) async {
    await entryCollection.doc(entryId).delete();
  }

  Stream<List<DiaryEntry>> getEntriesForMonth(int year, int month) {
    var startOfMonth = DateTime(year, month);
    var endOfMonth = DateTime(year, month + 1).subtract(Duration(days: 1));

    return entryCollection
        .where('date', isGreaterThanOrEqualTo: startOfMonth)
        .where('date', isLessThanOrEqualTo: endOfMonth)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => DiaryEntry.fromMap(doc)).toList());
  }

  Stream<Map<String, dynamic>> getMonthlyInsights() {
    return entryCollection.snapshots().map((querySnapshot) {
      var monthlyEntriesMap = Map<String, List<DiaryEntry>>();

      for (var doc in querySnapshot.docs) {
        var entry = DiaryEntry.fromMap(doc);
        String monthKey = DateFormat('yyyy-MM').format(entry.date);

        if (!monthlyEntriesMap.containsKey(monthKey)) {
          monthlyEntriesMap[monthKey] = [];
        }

        monthlyEntriesMap[monthKey]!.add(entry);
      }

      var monthlyInsights = Map<String, dynamic>();

      monthlyEntriesMap.forEach((month, entries) {
        int totalEntries = entries.length;
        double averageRating =
            entries.fold(0, (prev, entry) => prev + entry.rating) /
                totalEntries;
        int fiveStarEntries =
            entries.where((entry) => entry.rating == 5).length;

        monthlyInsights[month] = {
          'totalEntries': totalEntries,
          'averageRating': averageRating,
          'fiveStarEntries': fiveStarEntries,
        };
      });

      return monthlyInsights;
    });
  }
}
