import 'package:deardiary/model/diary_entry_model.dart';
import 'package:hive/hive.dart';

class DiaryController {
  final Box<DailyEntry> _diaryBox = Hive.box<DailyEntry>('DailyEntry');

  Future<void> addEntry(DailyEntry entry) async {
    final DailyEntry existingEntry = _diaryBox.values.firstWhere(
      (e) =>
          e.date.year == entry.date.year &&
          e.date.month == entry.date.month &&
          e.date.day == entry.date.day,
      orElse: () =>
          DailyEntry(date: DateTime.now(), description: "new", rating: 2),
    );

    if (existingEntry.description != "new") {
      throw Exception('An entry for this date already exists.');
    } else {
      await _diaryBox.add(entry);
    }
  }

  bool checkEntry(DailyEntry entry) {
    try {
      _diaryBox.values.firstWhere((e) =>
          e.date.year == entry.date.year &&
          e.date.month == entry.date.month &&
          e.date.day == entry.date.day);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> removeEntry(DateTime date) async {
    final index =
        _diaryBox.values.toList().indexWhere((entry) => entry.date == date);
    if (index != -1) {
      _diaryBox.deleteAt(index);
    }
  }

  List<DailyEntry> getAllEntries() {
    return _diaryBox.values.toList();
  }

  Map<String, double> calculateMonthlyAverages() {
    final List<DailyEntry> entries = _diaryBox.values.toList();
    final Map<String, List<double>> monthlyRatings = {};

    for (final entry in entries) {
      final key = '${entry.date.year}-${entry.date.month}';
      if (monthlyRatings.containsKey(key)) {
        monthlyRatings[key]!.add(entry.rating.toDouble());
      } else {
        monthlyRatings[key] = [entry.rating.toDouble()];
      }
    }

    final Map<String, double> monthlyAverages = {};
    monthlyRatings.forEach((key, ratings) {
      final totalRating = ratings.reduce((a, b) => a + b);
      final averageRating = totalRating / ratings.length;
      monthlyAverages[key] = averageRating;
    });

    return monthlyAverages;
  }
}
