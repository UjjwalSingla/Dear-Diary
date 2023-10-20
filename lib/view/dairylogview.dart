import 'package:deardiary/controller/diarycontroller.dart';
import 'package:deardiary/model/diary_entry_model.dart';
import 'package:deardiary/view/diaryentryview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiaryLogView extends StatelessWidget {
  const DiaryLogView({super.key});
  void newEntry(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DairyEntryView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF800020),
        title: Row(children: [
          const Expanded(
            child: Text(
              'Diary Enteries',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
              onPressed: () => newEntry(context),
              icon: const Icon(Icons.add, color: Colors.white))
        ]),
      ),
      body: DiaryLogList(),
    );
  }
}

class DiaryLogList extends StatelessWidget {
  final DiaryController controller = DiaryController();
  DiaryLogList({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming you have a list of diary entries, you can sort them in reverse chronological order.
    final sortedEntries = getSortedEntries();

    return ListView.builder(
      itemCount: sortedEntries.length,
      itemBuilder: (context, index) {
        final entry = sortedEntries[index];

        // Check if a new month has started.
        if (index == 0 ||
            entry.date.month != sortedEntries[index - 1].date.month ||
            entry.date.year != sortedEntries[index - 1].date.year) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  DateFormat('MMMM, y').format(entry.date),
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF800020)),
                ),
              ),
              DiaryLogEntry(entry: entry),
            ],
          );
        } else {
          return DiaryLogEntry(entry: entry);
        }
      },
    );
  }

  // Replace this with your actual data retrieval method.
  List<DailyEntry> getSortedEntries() {
    // Implement how to retrieve and sort your diary entries.
    var entries = controller.getAllEntries();
    entries.sort(
      (a, b) => b.date.compareTo(a.date),
    );
    return entries;
  }
}

class DiaryLogEntry extends StatelessWidget {
  final DailyEntry entry;

  const DiaryLogEntry({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(entry.date.toString()),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(entry.description),
          Text('Rating: ${entry.rating}'),
        ],
      ),
    );
  }
}
