import 'package:flutter/material.dart';
import 'package:p21_ip_info/src/app.dart';
import 'package:p21_ip_info/src/data/shared_prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final shared = SharedPrefs();
  await shared.initialize();
  runApp(const MainApp());
}
