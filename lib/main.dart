import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mekatronik_qr_management/firebase_options.dart';
import 'package:mekatronik_qr_management/services/shared_pref.dart';
import 'package:mekatronik_qr_management/utils/custom_colors.dart';
import 'package:mekatronik_qr_management/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeDependencies();
  runApp(const MyApp());
}

Future<void> _initializeDependencies() async {
  await SharedPref.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mekatronik',
      theme: ThemeData(
        scaffoldBackgroundColor: CustomColors.appBarColor,
      ),
      home: LoginScreen(),
    );
  }
}
