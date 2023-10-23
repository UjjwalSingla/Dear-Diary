import 'package:deardiary/controller/diarycontroller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyAveragesView extends StatelessWidget {
  final DiaryController controller = DiaryController();

  MonthlyAveragesView({super.key});

  @override
  Widget build(BuildContext context) {
    final monthlyAverages = controller.calculateMonthlyAverages();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF800020),
        title: const Text('Monthly Averages'),
      ),
      body: ListView.builder(
        itemCount: monthlyAverages.length,
        itemBuilder: (context, index) {
          final entry = monthlyAverages.entries.elementAt(index);
          final dateParts = entry.key.split('-');
          final year = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);

          return Card(
              child: ListTile(
            title: Text(
                '${DateFormat.MMMM().format(DateTime(year, month, 1))} $year'),
            subtitle: Text('Average Rating: ${entry.value.toStringAsFixed(2)}'),
          ));
        },
      ),
    );
  }
}
