import 'package:deardiary/controller/diary_entry_service.dart.dart';
import 'package:deardiary/model/diary_entry_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DairyEntryView extends StatefulWidget {
  final DiaryEntry? entry;
  final DiaryService service = DiaryService();
  DairyEntryView({super.key, this.entry});

  @override
  // ignore: library_private_types_in_public_api
  _DairyEntryViewState createState() => _DairyEntryViewState();
}

class _DairyEntryViewState extends State<DairyEntryView> {
  final TextEditingController _textController = TextEditingController();
  double userRating = 0.0;
  DateTime selectedDate = DateTime.now();
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFiles = []; 
  
@override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _textController.text = widget.entry!.description;
      userRating = widget.entry!.rating.toDouble();
      selectedDate = widget.entry!.date;
    }
  }
Future<void> _pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _imageFiles!.addAll(selectedImages);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles!.removeAt(index);
    });
  }
     Widget _buildImageDisplay() {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
    ),
    itemCount: _imageFiles!.length,
    itemBuilder: (context, index) {
      return GridTile(
        child: Image.file(
          File(_imageFiles![index].path),
          fit: BoxFit.cover, // Add this line to ensure each image covers its grid area
          errorBuilder: (context, error, stackTrace) {
            // Add error handling here
            return Center(child: Icon(Icons.error)); // Fallback content inside the grid
          },
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    String text = (widget.entry == null) ? 'Add a New Entry' : 'Update Entry';

    _textController.text =
        widget.entry == null ? _textController.text : widget.entry!.description;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF800020),
        title: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageDisplay(),
            ElevatedButton(
                onPressed: _pickImages,
                child: const Text('Pick Images'),
              ),
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
              initialRating:
                  widget.entry == null ? 0.0 : widget.entry!.rating.toDouble(),
              onRatingUpdate: (rating) {
                setState(() {
                  userRating = rating;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                    'Date: ${DateFormat('MMMM d, y').format(widget.entry == null ? selectedDate : widget.entry!.date)}'),
                IconButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: widget.entry == null
                          ? selectedDate
                          : widget.entry!.date,
                      firstDate: DateTime(2015, 8),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        widget.entry == null
                            ? selectedDate = pickedDate
                            : widget.entry!.date = pickedDate;
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
                  try {
                    DiaryEntry entry = DiaryEntry(
                        id: widget.entry == null ? null : widget.entry!.id,
                        date: widget.entry == null
                            ? selectedDate
                            : widget.entry!.date,
                        rating: userRating != 0.0
                            ? userRating.toInt()
                            : widget.entry!.rating,
                        description: _textController.text);
                    widget.entry != null
                        ? widget.service.updateDiaryEntry(entry)
                        : widget.service.addEntry(entry);
                    Navigator.of(context).pop(1);
                  } catch (e) {
                    final snackBar = SnackBar(
                      backgroundColor: Colors.redAccent, // Red color for errors
                      content: Text(e.toString()),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop(2);
                  }

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
            if (widget.entry != null)
              Center(
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () async {
                        try {
                          await widget.service.removeEntry(widget.entry!.id!);
                          Navigator.of(context).pop(1);
                        } catch (e) {
                          final snackBar = SnackBar(
                            backgroundColor:
                                Colors.redAccent, // Red color for errors
                            content: Text(e.toString()),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.of(context).pop(2);
                        }
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                          color: Color(0xFF800020),
                          backgroundColor: Colors.white,
                        ),
                      )))
          ],
        ),
      ),
    );
  }
}
