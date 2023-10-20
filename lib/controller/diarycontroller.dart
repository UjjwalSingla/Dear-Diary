import 'package:deardiary/model/diary_entry_model.dart';
import 'package:hive/hive.dart';

class DiaryController {
  final Box<DailyEntry> _diaryBox = Hive.box<DailyEntry>('DailyEntry');

  Future<void> addEntry(DailyEntry entry) async {
    // Check if an entry with the same date already exists.
    final DailyEntry existingEntry = _diaryBox.values.firstWhere(
      (e) =>
          e.date.year == entry.date.year &&
          e.date.month == entry.date.month &&
          e.date.day == entry.date.day,
      orElse: () => DailyEntry(
          date: DateTime.now(),
          description: "new",
          rating: 2), // Return null if no matching entry is found.
    );

    if (existingEntry.description != "new") {
      // An entry with the same date already exists.
      throw Exception('An entry for this date already exists.');
    } else {
      await _diaryBox.add(entry);
    }
  }

  bool checkEntry(DailyEntry entry) {
    // Check if an entry with the same date already exists.
    try {
      _diaryBox.values.firstWhere((e) =>
              e.date.year == entry.date.year &&
              e.date.month == entry.date.month &&
              e.date.day ==
                  entry.date.day // Return null if no matching entry is found.
          );
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
}
