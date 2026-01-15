import 'dart:async';
import 'dart:convert';

import 'package:attendancewithqrwp/core/constants/app_constants.dart';
import 'package:attendancewithqrwp/core/constants/app_strings.dart';
import 'package:attendancewithqrwp/database/db_helper.dart';
import 'package:attendancewithqrwp/model/settings.dart';
import 'package:attendancewithqrwp/screen/main_menu_page.dart';
import 'package:attendancewithqrwp/screen/qr_scanner_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../utils/utils.dart';

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key});

  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  DbHelper dbHelper = DbHelper();
  Utils utils = Utils();
  String _barcode = "";
  late Settings settings;
  String _isAlreadyDoSettings = 'loading';

  Future<void> scan() async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const QRScannerPage(),
        ),
      );

      if (result != null && result is String) {
        // The value of Qr Code
        // Return the json data
        // We need replaceAll because Json from web use single-quote ({' '}) not double-quote ({" "})
        final newJsonData = result.replaceAll("'", '"');
        final data = jsonDecode(newJsonData);
        // Check the type of barcode
        if (data['url'] != null && data['key'] != null) {
          // Decode the json data form QR
          final getUrl = data['url'].toString();
          final getKey = data['key'].toString();

          // Set the url and key
          settings = Settings(url: getUrl, key: getKey);
          // Insert the settings
          insertSettings(settings);
        } else {
          if (mounted) {
            utils.showAlertDialog(
              context,
              AppStrings.wrongBarcodeFormat,
              AppStrings.error,
              AlertType.error,
              isAnyButton: false,
            );
          }
        }
      }
    } catch (e) {
      _barcode = 'Unknown error : $e';
      if (kDebugMode) {
        print(_barcode);
      }
      if (mounted) {
        utils.showAlertDialog(
          context,
          _barcode,
          AppStrings.error,
          AlertType.error,
          isAnyButton: false,
        );
      }
    }
  }

  // Insert the URL and KEY
  Future<void> insertSettings(Settings object) async {
    await dbHelper.newSettings(object);
    setState(() {
      _isAlreadyDoSettings = 'yes';
      goToMainMenu();
    });
  }

  Future<void> getSettings() async {
    final checking = await dbHelper.countSettings();
    checking! > 0 ? _isAlreadyDoSettings = 'yes' : _isAlreadyDoSettings = 'no';
    setState(() {});
    if (mounted) {
      goToMainMenu();
    }
  }

  // Init for the first time
  @override
  void initState() {
    super.initState();
    splashScreen();
  }

  /// Show splash screen with time duration
  Future<Timer> splashScreen() async {
    return Timer(AppConstants.splashScreenDuration, () {
      getSettings();
    });
  }

  // Got to main menu after scanning the QR or if user scanned the QR.
  void goToMainMenu() {
    if (_isAlreadyDoSettings == 'yes') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainMenuPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if user already do settings
    if (_isAlreadyDoSettings == 'no') {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xff3f6ae0),
          body: Container(
            margin: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Image(
                  image: AssetImage('images/logo.png'),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                  AppStrings.welcomeMessage,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  AppStrings.settingsDescription,
                  style: TextStyle(fontSize: 12.0, color: Colors.grey[300]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 40.0,
                ),
                ElevatedButton(
                  style: Utils().elevatedButtonStyle(
                    Colors.black,
                    const Color(AppConstants.accentColorValue),
                  ),
                  onPressed: () => scan(),
                  child: const Text(AppStrings.scanQrButton),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      color: Colors.blue,
      child: const Center(
        child: Image(
          image: AssetImage('images/logo.png'),
        ),
      ),
    );
  }
}
