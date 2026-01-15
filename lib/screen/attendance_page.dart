import 'dart:async';
import 'dart:convert';

import 'package:attendancewithqrwp/core/constants/app_constants.dart';
import 'package:attendancewithqrwp/core/constants/app_strings.dart';
import 'package:attendancewithqrwp/model/attendance.dart';
import 'package:attendancewithqrwp/screen/qr_scanner_page.dart';
import 'package:attendancewithqrwp/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../database/db_helper.dart';
import '../model/settings.dart';
import '../utils/utils.dart';

class AttendancePage extends StatefulWidget {
  final String? query;
  final String? title;

  const AttendancePage({super.key, this.query, this.title});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  // Progress dialog
  late ProgressDialog pr;

  // Database
  DbHelper dbHelper = DbHelper();

  // Utils
  Utils utils = Utils();

  // API Service
  final ApiService _apiService = ApiService();

  // Model settings
  Settings? settings;

  // Note: Removed deprecated GlobalKey<ScaffoldState>
  // Using BuildContext directly with ScaffoldMessenger

  // String
  String? getUrl,
      getKey,
      _barcode = "",
      getName,
      getQuery,
      mAccuracy;

  // Geolocation
  late Position _currentPosition;
  String? _currentAddress;
  final Geolocator geoLocator = Geolocator();
  late dynamic subscription;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    getSettings();
  }

  // Get latitude longitude
  void _getCurrentLocation() {
    subscription = Geolocator.getPositionStream().listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });

        _getAddressFromLatLng(_currentPosition.accuracy);
      }
    });
  }

  // Get address
  Future<void> _getAddressFromLatLng(double accuracy) async {
    final strAccuracy = accuracy.toStringAsFixed(1);
    if (accuracy > AppConstants.locationAccuracyThreshold) {
      mAccuracy = '$strAccuracy M (Not accurate).';
    } else {
      mAccuracy = '$strAccuracy M (Accurate).';
    }
    try {
      final List<Placemark> p = await placemarkFromCoordinates(
        _currentPosition.latitude,
        _currentPosition.longitude,
      );

      final Placemark placeMark = p[0];
      if (mounted) {
        setState(() {
          _currentAddress =
              "$mAccuracy ${placeMark.name}, ${placeMark.subLocality}, ${placeMark.subAdministrativeArea} - ${placeMark.administrativeArea}.";
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Get settings data
  Future<void> getSettings() async {
    final getSettings = await dbHelper.getSettings(1);
    setState(() {
      getUrl = getSettings.url.toString();
      getKey = getSettings.key.toString();
    });
  }

  // Send data post via http
  // IMPORTANT: Date and time are determined by the server PHP based on timezone settings,
  // NOT from the device. This prevents users from manipulating time by changing device settings.
  Future<void> sendData() async {
    try {
      // Prepare data to send to server
      // Note: We do NOT send date/time from device - server will determine this based on timezone settings
      final dataAddress = _currentAddress ?? '';
      final dataKey = getKey;
      final dataName = getName;
      final dataQuery = getQuery;

      // Validate required fields
      if (dataKey == null || dataKey.isEmpty) {
        await pr.hide();
        if (mounted) {
          utils.showAlertDialog(
            context,
            AppStrings.securityKeyMissing,
            AppStrings.error,
            AlertType.error,
            isAnyButton: true,
          );
        }
        return;
      }

      if (dataName == null || dataName.isEmpty) {
        await pr.hide();
        if (mounted) {
          utils.showAlertDialog(
            context,
            AppStrings.nameRequired,
            AppStrings.error,
            AlertType.error,
            isAnyButton: true,
          );
        }
        return;
      }

      if (dataQuery == null || dataQuery.isEmpty) {
        await pr.hide();
        if (mounted) {
          utils.showAlertDialog(
            context,
            AppStrings.queryParameterMissing,
            AppStrings.error,
            AlertType.error,
            isAnyButton: true,
          );
        }
        return;
      }

      // Send data using API service
      final responseData = await _apiService.sendAttendance(
        url: getUrl!,
        key: dataKey,
        name: dataName,
        query: dataQuery,
        location: dataAddress,
      );

      final parsedResponse = _apiService.parseResponse(responseData);
      final bool isSuccess = parsedResponse['success'] as bool;
      final responseBody = parsedResponse['data'] as Map<String, dynamic>?;

      if (isSuccess && responseBody != null) {
        // Check for success messages
        final message = responseBody['message']?.toString() ?? '';
        final messageLower = message.toLowerCase();

        if (messageLower.contains('successful') ||
            messageLower.contains('success')) {
          // Use date and time from server response
          // These are calculated by PHP based on timezone settings, not from device
          final attendance = _apiService.extractAttendanceData(
            responseBody: responseBody,
            name: dataName,
            location: dataAddress,
            query: dataQuery,
          );

          if (attendance != null) {
            // Insert the attendance
            insertAttendance(attendance);
          }

          // Hide the loading
          if (mounted) {
            subscription.cancel();
            await pr.hide();

            // Use context after async gap with mounted check
            if (mounted) {
              utils.showAlertDialog(
                context,
                AppStrings.checkSuccess.replaceAll('{query}', dataQuery),
                AppStrings.success,
                AlertType.success,
                isAnyButton: true,
              );
            }
          }
          return;
        }
      }

      // Handle error responses
      final errorMessage = _apiService.getErrorMessage(responseData);
      await pr.hide();

      // Handle specific error messages
      if (!mounted) return;

      if (errorMessage.toLowerCase().contains('already checked in') ||
          errorMessage.toLowerCase().contains('already check-in')) {
        utils.showAlertDialog(
          context,
          AppStrings.alreadyCheckedIn,
          AppStrings.warning,
          AlertType.warning,
          isAnyButton: true,
        );
      } else if (errorMessage.toLowerCase().contains('check-in first') ||
          errorMessage.toLowerCase().contains('please check-in')) {
        utils.showAlertDialog(
          context,
          AppStrings.checkInFirst,
          AppStrings.warning,
          AlertType.warning,
          isAnyButton: true,
        );
      } else if (errorMessage.toLowerCase().contains('invalid security key') ||
          errorMessage.toLowerCase().contains('security key')) {
        utils.showAlertDialog(
          context,
          AppStrings.invalidSecurityKey,
          AppStrings.error,
          AlertType.error,
          isAnyButton: true,
        );
      } else {
        utils.showAlertDialog(
          context,
          errorMessage,
          AppStrings.error,
          AlertType.error,
          isAnyButton: true,
        );
      }
    } on DioException catch (e) {
      await pr.hide();

      final errorMessage = _apiService.getDioErrorMessage(e);

      if (kDebugMode) {
        print('DioException: ${e.type} - ${e.message}');
        print('Response: ${e.response?.data}');
      }

      if (mounted) {
        utils.showAlertDialog(
          context,
          errorMessage,
          AppStrings.error,
          AlertType.error,
          isAnyButton: true,
        );
      }
    } catch (e) {
      await pr.hide();
      
      if (kDebugMode) {
        print('Unexpected error: $e');
      }
      
      if (mounted) {
        utils.showAlertDialog(
          context,
          AppStrings.unexpectedError.replaceAll('{error}', e.toString()),
          AppStrings.error,
          AlertType.error,
          isAnyButton: true,
        );
      }
    }
  }

  Future<void> insertAttendance(Attendance object) async {
    await dbHelper.newAttendances(object);
  }

  // Scan the QR name of user
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

        if (data['name'] != null && result != '') {
          setState(() {
            // Show dialog
            pr.show();

            // Get name from QR
            getName = data['name'].toString();
            // Sending the data
            sendData();
          });
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

  @override
  Widget build(BuildContext context) {
    // Show progress
    pr = ProgressDialog(context, type: ProgressDialogType.normal);
    // Style progress
    pr.style(
      message: AppStrings.sendingData,
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: const CircularProgressIndicator(),
      elevation: 10.0,
      padding: const EdgeInsets.all(10.0),
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 13.0,
        fontWeight: FontWeight.w400,
      ),
      messageTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 19.0,
        fontWeight: FontWeight.w600,
      ),
    );

    // Init the query
    getQuery = widget.query;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${AppStrings.accuracyLabel} $mAccuracy \n${AppStrings.gpsWarning}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
              textAlign: TextAlign.center,
            ),
            Container(
              margin: const EdgeInsets.all(20.0),
              child: ButtonTheme(
                minWidth: double.infinity,
                height: 60.0,
                child: ElevatedButton(
                  style: Utils().elevatedButtonStyle(
                    Colors.black,
                    const Color(0xFFf7c846),
                  ),
                  onPressed: () {
                    if (mAccuracy != null) {
                      scan();
                    } else {
                      const snackBar = SnackBar(
                        content: Text(AppStrings.waitForLocation),
                      );

                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: const Text(AppStrings.scanQrButtonText),
                ),
              ),
            ),
            Text(
              '${AppStrings.clickToCheck}$getQuery.',
              style: const TextStyle(color: Colors.grey, fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}
