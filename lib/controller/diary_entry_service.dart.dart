import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary/model/diary_entry_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart'; 
import 'dart:io';

class DiaryService {
  final user = FirebaseAuth.instance.currentUser;
  final storageRef = FirebaseStorage.instance.ref(); 
  CollectionReference entryCollection;
  DiaryService()
      : entryCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('enteries');
      
 Future<String> uploadDiaryImage(File imageFile, String entryId) async {
    var uploadTask = storageRef
        .child('users/${user!.uid}/entry_images/$entryId')
        .putFile(imageFile);
    var downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }
  // Diary Entry Management
    Future<DocumentReference> addEntry(DiaryEntry entry, {File? imageFile}) async {
    DocumentReference docRef = await entryCollection.add(entry.toMap());
    if (imageFile != null) {
      String imageUrl = await uploadDiaryImage(imageFile, docRef.id);
      await docRef.update({'imageUrl': imageUrl});
    }
    return docRef;
  }

  Stream<List<DiaryEntry>> getAllEntries() {
    return entryCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => DiaryEntry.fromMap(doc)).toList();
    });
  }

  Future<void> updateDiaryEntry(DiaryEntry updatedEntry, {File? imageFile}) async {
    if (imageFile != null) {
      String imageUrl = await uploadDiaryImage(imageFile, updatedEntry.id.toString());
      await entryCollection.doc(updatedEntry.id).update(
        updatedEntry.toMap()..['imageUrl'] = imageUrl,
      );
    } else {
      await entryCollection.doc(updatedEntry.id).update(updatedEntry.toMap());
    }
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
