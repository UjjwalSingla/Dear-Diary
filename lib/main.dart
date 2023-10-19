import 'package:deardiary/model/diary_entry_model.dart';
import 'package:deardiary/utility/boxes.dart';
import 'package:deardiary/view/dairylogview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DailyEntryAdapter());
  box = await Hive.openBox<DailyEntry>("DailyEntry");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Dairy',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white54,
        textTheme: GoogleFonts.libreBaskervilleTextTheme(),
        useMaterial3: true,
      ),
      home: const DiaryLogView(),
    );
  }
}