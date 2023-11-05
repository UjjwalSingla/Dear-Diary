import 'package:deardiary/controller/diary_entry_service.dart.dart';
import 'package:deardiary/model/diary_entry_model.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class DairyEntryView extends StatefulWidget {
  final DiaryController controller = DiaryController();
  DairyEntryView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DairyEntryViewState createState() => _DairyEntryViewState();
}

class _DairyEntryViewState extends State<DairyEntryView> {
  final TextEditingController _textController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  double _userRating = 0.0;

  Future<void> generateDiaryEntriesPDF(DiaryEntry entry) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Date: ${DateFormat('MMMM d, y').format(entry.date)}'),
              pw.Text('Description: ${entry.description}'),
              pw.Text('Rating: ${entry.rating} stars'),
            ],
          );
        },
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    print("output: $output");
    const LocalFileSystem localFileSystem = LocalFileSystem();
    final file = localFileSystem.file('$output/diary_entries.pdf');
    await file.writeAsBytes(await pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF800020),
        title: const Center(
          child: Text(
            'Add DairyEntry',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _textController,
              maxLength: 140,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            const Text('Rate Your Day:'),
            RatingBar(
              ratingWidget: RatingWidget(
                  full: const Icon(Icons.star, color: Color(0xFF800020)),
                  half: const Icon(Icons.star_half, color: Color(0xFF800020)),
                  empty:
                      const Icon(Icons.star_border, color: Color(0xFF800020))),
              initialRating: _userRating,
              onRatingUpdate: (rating) {
                setState(() {
                  _userRating = rating;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Date: ${DateFormat('MMMM d, y').format(_selectedDate)}'),
                IconButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2015, 8),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  icon: const Icon(Icons.date_range),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF800020)),
                ),
                onPressed: () {
                  DiaryEntry entry = DiaryEntry(
                      date: _selectedDate,
                      rating: _userRating.toInt(),
                      description: _textController.text);

                  // if (widget.controller.checkEntry(entry)) {
                  //   const snackBar = SnackBar(
                  //     content: Text('An entry for this date already exists.'),
                  //   );
                  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  // } else {
                  widget.controller.addEntry(entry);
                  Navigator.of(context).pop(1);
                  // }
                },
                child: const Text(
                  'Save Entry',
                  style: TextStyle(
                    color: Colors.white,
                    backgroundColor: Color(0xFF800020),
                  ),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  DiaryEntry entry = DiaryEntry(
                      date: _selectedDate,
                      rating: _userRating.toInt(),
                      description: _textController.text);
                  generateDiaryEntriesPDF(entry);
                },
                child: const Text('Download'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
