import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Utils {
  AlertStyle alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    descStyle: const TextStyle(fontSize: 18.0),
    animationDuration: const Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: const BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: const TextStyle(
      color: Colors.red,
    ),
  );

  // Show alert dialog
  // Updated to use BuildContext instead of deprecated GlobalKey<ScaffoldState>
  void showAlertDialog(
    BuildContext context,
    String? message,
    String title,
    AlertType alertType, {
    required bool isAnyButton,
  }) {
    if (isAnyButton) {
      Alert(
        context: context,
        style: alertStyle,
        type: alertType,
        title: title,
        desc: message,
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            width: 120,
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ).show();
    } else {
      Alert(
        context: context,
        style: alertStyle,
        type: alertType,
        title: title,
        desc: message,
        buttons: [],
      ).show();
    }
  }

  // Get the url, and this function will check if the last is any slash (/) or not
  String getRealUrl(String url, String? path) {
    String realUrl;
    final count = url.length - 1;
    final getLast = url[count];
    if (getLast == '/') {
      realUrl = '$url$path';
    } else {
      realUrl = '$url/$path';
    }
    return realUrl;
  }

  ButtonStyle textButtonStyle(Color foregroundColor) {
    return TextButton.styleFrom(
      foregroundColor: foregroundColor,
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
    );
  }

  ButtonStyle elevatedButtonStyle(
    Color backgroundColor,
    Color foregroundColor,
  ) {
    return ElevatedButton.styleFrom(
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    );
  }
}
