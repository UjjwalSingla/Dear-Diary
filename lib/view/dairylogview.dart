import 'package:flutter/material.dart';

class DiaryLogView extends StatelessWidget {
  const DiaryLogView({super.key});
  void newEntry() {}

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
              onPressed: newEntry,
              icon: const Icon(Icons.add, color: Colors.white))
        ]),
      ),
      body: const DiaryLogList(),
    );
  }
}

class DiaryLogList extends StatelessWidget {
  const DiaryLogList({super.key});

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
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${entry.date.month}/${entry.date.year}',
                  style: TextStyle(fontWeight: FontWeight.bold),
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
  List<DiaryEntry> getSortedEntries() {
    // Implement how to retrieve and sort your diary entries.
    return [];
  }
}

class DiaryLogEntry extends StatelessWidget {
  final DiaryEntry entry;

  DiaryLogEntry({required this.entry});

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

class DiaryEntry {
  final DateTime date;
  final String description;
  final int rating;

  DiaryEntry({
    required this.date,
    required this.description,
    required this.rating,
  });
}
