import 'dart:async';
import 'dart:convert';

import 'package:attendancewithqrwp/core/constants/app_constants.dart';
import 'package:attendancewithqrwp/core/constants/app_strings.dart';
import 'package:attendancewithqrwp/database/db_helper.dart';
import 'package:attendancewithqrwp/model/settings.dart';
import 'package:attendancewithqrwp/screen/qr_scanner_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../utils/utils.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  DbHelper dbHelper = DbHelper();
  Utils utils = Utils();
  String _barcode = "";
  late Settings settings;

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
          settings = Settings(id: 1, url: getUrl, key: getKey);
          // Update the settings
          updateSettings(settings);
        } else {
          if (mounted) {
            utils.showAlertDialog(
              context,
              AppStrings.wrongBarcodeFormat,
              AppStrings.error,
              AlertType.error,
              isAnyButton: true,
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
          isAnyButton: true,
        );
      }
    }
  }

  // Insert the URL and KEY
  Future<void> updateSettings(Settings object) async {
    await dbHelper.updateSettings(object);
    goToMainMenu();
  }

  void goToMainMenu() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settingsTitle),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              width: double.infinity,
              height: 100.0,
              child: Image(
                image: AssetImage('images/logo.png'),
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            ElevatedButton(
              style: Utils()
                  .elevatedButtonStyle(Colors.black, const Color(AppConstants.accentColorValue)),
              onPressed: () => scan(),
              child: const Text(AppStrings.scanQrButton),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              AppStrings.settingsDescription,
              style: TextStyle(color: Colors.grey, fontSize: 12.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
