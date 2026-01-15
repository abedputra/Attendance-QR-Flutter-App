import 'package:attendancewithqrwp/core/constants/app_constants.dart';
import 'package:attendancewithqrwp/core/theme/app_theme.dart';
import 'package:attendancewithqrwp/screen/scan_qr_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      home: const ScanQrPage(),
    );
  }
}
