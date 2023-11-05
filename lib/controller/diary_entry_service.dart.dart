import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary/model/diary_entry_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiaryController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference get _diaryEntries =>
      _firestore.collection('diaryEntries');

  // Authentication
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  // Other authentication methods (sign-up, sign-out, reset password) would be handled through FirebaseUI Auth.

  // Diary Entry Management
  Future<void> addEntry(DiaryEntry entry) async {
    await _diaryEntries
        .doc(_auth.currentUser!.uid)
        .collection('entries')
        .add(entry.toMap());
  }

  Future<List<DiaryEntry>> getAllEntries() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _diaryEntries.get() as QuerySnapshot<Map<String, dynamic>>;
    return snapshot.docs.map((doc) => DiaryEntry.fromMap(doc.data())).toList();
  }

  Future<void> updateDiaryEntry(String entryId, DiaryEntry updatedEntry) async {
    await _diaryEntries
        .doc(_auth.currentUser!.uid)
        .collection('entries')
        .doc(entryId)
        .update(updatedEntry.toMap());
  }

  Future<void> removeEntry(String entryId) async {
    await _diaryEntries
        .doc(_auth.currentUser!.uid)
        .collection('entries')
        .doc(entryId)
        .delete();
  }
}

// import 'package:deardiary/model/diary_entry_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:hive/hive.dart';

// class DiaryController {
//   final Box<DailyEntry> _diaryBox = Hive.box<DailyEntry>('DailyEntry');
//   final user = FirebaseAuth.instance.currentUser;

//   Future<void> addEntry(DailyEntry entry) async {
//     final DailyEntry existingEntry = _diaryBox.values.firstWhere(
//       (e) =>
//           e.date.year == entry.date.year &&
//           e.date.month == entry.date.month &&
//           e.date.day == entry.date.day,
//       orElse: () =>
//           DailyEntry(date: DateTime.now(), description: "new", rating: 2),
//     );

//     if (existingEntry.description != "new") {
//       throw Exception('An entry for this date already exists.');
//     } else {
//       await _diaryBox.add(entry);
//     }
//   }

//   bool checkEntry(DailyEntry entry) {
//     try {
//       _diaryBox.values.firstWhere((e) =>
//           e.date.year == entry.date.year &&
//           e.date.month == entry.date.month &&
//           e.date.day == entry.date.day);
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<void> removeEntry(DateTime date) async {
//     final index =
//         _diaryBox.values.toList().indexWhere((entry) => entry.date == date);
//     if (index != -1) {
//       _diaryBox.deleteAt(index);
//     }
//   }

//   List<DailyEntry> getAllEntries() {
//     return _diaryBox.values.toList();
//   }

//   Map<String, double> calculateMonthlyAverages() {
//     final List<DailyEntry> entries = _diaryBox.values.toList();
//     final Map<String, List<double>> monthlyRatings = {};

//     for (final entry in entries) {
//       final key = '${entry.date.year}-${entry.date.month}';
//       if (monthlyRatings.containsKey(key)) {
//         monthlyRatings[key]!.add(entry.rating.toDouble());
//       } else {
//         monthlyRatings[key] = [entry.rating.toDouble()];
//       }
//     }

//     final Map<String, double> monthlyAverages = {};
//     monthlyRatings.forEach((key, ratings) {
//       final totalRating = ratings.reduce((a, b) => a + b);
//       final averageRating = totalRating / ratings.length;
//       monthlyAverages[key] = averageRating;
//     });

//     return monthlyAverages;
//   }
// }
