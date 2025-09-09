import 'package:flutter/material.dart';
import 'package:p21_ip_info/src/features/get_ip/presentation/get_ip.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: GetIp());
  }
}
