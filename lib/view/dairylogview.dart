import 'package:deardiary/controller/diary_entry_service.dart.dart';
import 'package:deardiary/model/diary_entry_model.dart';
import 'package:deardiary/view/monthlyratingview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deardiary/view/diaryentryview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class DiaryLogView extends StatefulWidget {
  DiaryLogView({super.key});

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
    const snackBar = SnackBar(
      backgroundColor: Colors.indigo,
      content: Text("Successfully Created"),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
            IconButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MonthlyInsightsView()),
                )
              },
              icon: const Icon(Icons.insights),
            ),
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
        body: DiaryLogList());
  }
}

class DiaryLogList extends StatefulWidget {
  DiaryLogList({super.key});

  @override
  State<DiaryLogList> createState() => _DiaryLogListState();
}

class _DiaryLogListState extends State<DiaryLogList> {
  final DiaryService service = DiaryService();

  Future<void> updateState() async {
    setState(() async {
      // var sortedEntries = await getSortedEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DiaryEntry>>(
        stream: service.getAllEntries(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          final sortedEntries = getSortedEntries(snapshot.data!);
          return ListView.builder(
            itemCount: sortedEntries.length,
            itemBuilder: (context, index) {
              final entry = sortedEntries[index];

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
                    DiaryLogEntry(updateParent: updateState, entry: entry),
                  ],
                );
              } else {
                return DiaryLogEntry(updateParent: updateState, entry: entry);
              }
            },
          );
        });
  }

  List<DiaryEntry> getSortedEntries(List<DiaryEntry> unsorted) {
    unsorted.sort(
      (a, b) => b.date.compareTo(a.date),
    );
    return unsorted;
  }
}

class DiaryLogEntry extends StatefulWidget {
  final DiaryEntry entry;
  final VoidCallback updateParent;
  const DiaryLogEntry(
      {super.key, required this.entry, required this.updateParent});

  @override
  State<DiaryLogEntry> createState() => _DiaryLogEntryState();
}

class _DiaryLogEntryState extends State<DiaryLogEntry> {
  late bool refresh;
  final DiaryService service = DiaryService();

  Future<void> removeEntry(BuildContext context) async {
    try {
      await service.removeEntry(widget.entry.id!);
      const snackBar = SnackBar(
        backgroundColor: Colors.indigo, // Red color for errors
        content: Text("Successfully Deleted"),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      final snackBar = SnackBar(
        backgroundColor: Colors.redAccent, // Red color for errors
        content: Text(e.toString()),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      refresh = !refresh;
    });
  }

  Future<void> EntryLog() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DairyEntryView()),
    );
    const snackBar = SnackBar(
      backgroundColor: Colors.indigo,
      content: Text("Successfully Created"),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DairyEntryView(
                      entry: widget.entry,
                    )),
          );
          const snackBar = SnackBar(
            backgroundColor: Colors.indigo,
            content: Text("Successfully Updated"),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Container(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
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
                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  DateFormat('E MMM, d')
                                      .format(widget.entry.date),
                                  style: const TextStyle(
                                    color: Color(0xFF800020),
                                    fontSize: 20,
                                  ),
                                )),
                            RatingBar(
                              itemCount: 5,
                              initialRating: widget.entry.rating.toDouble(),
                              ratingWidget: RatingWidget(
                                full: const Icon(Icons.star,
                                    color: Color(0xFF800020)),
                                empty: const Icon(Icons.star_border,
                                    color: Colors.grey),
                                half: const Icon(Icons.star_half,
                                    color: Colors.grey),
                              ),
                              onRatingUpdate: (rating) {},
                              ignoreGestures: true,
                            ),
                            IconButton(
                                onPressed: () {
                                  removeEntry(context);
                                  widget.updateParent();
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  size: 30,
                                  color: Color(0xFF800020),
                                ))
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              widget.entry.description,
                              style: const TextStyle(
                                color: Color(0xFF800020),
                                fontSize: 20,
                              ),
                            ))
                      ],
                    )))));
  }
}
