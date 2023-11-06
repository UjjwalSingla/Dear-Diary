import 'package:deardiary/controller/diary_entry_service.dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MonthlyInsightsView extends StatelessWidget {
  final DiaryService diaryService = DiaryService();

  MonthlyInsightsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the color as a constant so it can be reused easily.
    const infoColor = Color(0xFF800020);
    // Define a larger text style for the fields
    const infoTextStyle = TextStyle(fontSize: 22.0, color: infoColor);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: infoColor,
        title: const Text('Monthly Diary Insights'),
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: diaryService.getMonthlyInsights(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No entries found'));
          } else {
            Map<String, dynamic> insights = snapshot.data!;
            return ListView.builder(
              itemCount: insights.keys.length,
              itemBuilder: (context, index) {
                String monthYear = insights.keys.elementAt(index);
                var monthlyData = insights[monthYear];
                return Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                monthYear, // "Month Year" format
                                style: const TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  color: infoColor,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Average Rating',
                                  style: infoTextStyle,
                                ),
                                RatingBarIndicator(
                                  rating: monthlyData['averageRating'] * 1.0,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: infoColor,
                                  ),
                                  itemCount: 5,
                                  itemSize: 30.0, // Larger star size
                                  direction: Axis.horizontal,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Entries: ${monthlyData['totalEntries']}',
                                style: infoTextStyle,
                              ),
                              Text(
                                'Five Star Entries: ${monthlyData['fiveStarEntries']}',
                                style: infoTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
