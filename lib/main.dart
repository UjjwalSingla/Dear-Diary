import 'package:deardiary/model/diary_entry_model.dart';
import 'package:deardiary/utility/boxes.dart';
import 'package:deardiary/view/dairylogview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final encryptionKey = Hive.generateSecureKey();
  await Hive.initFlutter();
  Hive.registerAdapter(DailyEntryAdapter());
  box = await Hive.openBox<DailyEntry>("DailyEntry",
      encryptionCipher: HiveAesCipher(encryptionKey));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Dairy',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.libreBaskervilleTextTheme(),
        useMaterial3: true,
      ),
      home: const DiaryLogView(),
    );
  }
}
