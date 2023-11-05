import 'package:deardiary/firebase_options.dart';
import 'package:deardiary/view/loginview.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:deardiary/model/diary_entry_model.dart';
import 'package:deardiary/view/dairylogview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(home: LogInView());
  //  {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     title: 'Daily Dairy',
  //     theme: ThemeData(
  //       scaffoldBackgroundColor: Colors.white,
  //       textTheme: GoogleFonts.libreBaskervilleTextTheme(),
  //       useMaterial3: true,
  //     ),
  //     home: const DiaryLogView(),
  //   );
  // }
}
