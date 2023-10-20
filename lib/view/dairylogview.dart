import 'package:deardiary/controller/diarycontroller.dart';
import 'package:deardiary/model/diary_entry_model.dart';
import 'package:deardiary/view/diaryentryview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class DiaryLogView extends StatefulWidget {
  const DiaryLogView({super.key});

  @override
  State<DiaryLogView> createState() => _DiaryLogViewState();
}

class _DiaryLogViewState extends State<DiaryLogView> {
  int data = 2;
  Future<void> newEntry(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DairyEntryView()),
    );
    setState(() {
      data = result as int;
    });
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
    var sortedEntries = getSortedEntries();

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

class DiaryLogEntry extends StatefulWidget {
  final DailyEntry entry;

  const DiaryLogEntry({super.key, required this.entry});

  @override
  State<DiaryLogEntry> createState() => _DiaryLogEntryState();
}

class _DiaryLogEntryState extends State<DiaryLogEntry> {
  late bool refresh;
  final DiaryController controller = DiaryController();
  Future<void> removeEntry(BuildContext context) async {
    await controller.removeEntry(widget.entry.date);
    setState(() {
      refresh = !refresh;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('E MMM, d').format(widget.entry.date),
                  style: const TextStyle(color: Color(0xFF800020)),
                ),
                RatingBar(
                  itemCount: 5,
                  initialRating: widget.entry.rating.toDouble(),
                  ratingWidget: RatingWidget(
                    full: const Icon(Icons.star, color: Color(0xFF800020)),
                    empty: const Icon(Icons.star_border, color: Colors.grey),
                    half: const Icon(Icons.star_half, color: Colors.grey),
                  ),
                  onRatingUpdate: (rating) {},
                  ignoreGestures: true,
                ),
                IconButton(
                    onPressed: () {
                      removeEntry(context);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Color(0xFF800020),
                    ))
              ],
            ),
            Text(
              widget.entry.description,
              style: const TextStyle(color: Color(0xFF800020)),
            )
          ],
        ));
  }
}
