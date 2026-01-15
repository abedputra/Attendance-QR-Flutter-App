/// Application strings
/// Centralized string constants for the app
class AppStrings {
  // App Info
  static const String appTitle = 'Attendance with QR Code';
  static const String welcomeMessage = 'Welcome to \nAttendance with QR Code !';
  static const String appVersion = 'v 1.0';

  // Settings
  static const String settingsTitle = 'Settings';
  static const String scanQrButton = 'Scan QR';
  static const String settingsDescription =
      'Please scan the QR code from the management system to get the URL and KEY by clicking "Scan QR".';

  // Attendance
  static const String checkInTitle = 'Attendance Check-In';
  static const String checkOutTitle = 'Attendance Check-Out';
  static const String scanQrButtonText = 'Scan QR';
  static const String accuracyLabel = 'Accuracy:';
  static const String gpsWarning = 'Make sure turn on your GPS.';
  static const String clickToCheck = 'Click Scan QR to make check-';

  // Menu
  static const String menuCheckIn = 'Check-In';
  static const String menuCheckOut = 'Check-Out';
  static const String menuSettings = 'Settings';
  static const String menuReport = 'Report';
  static const String menuAbout = 'About';

  // Messages
  static const String sendingData = 'Sending...';
  static const String checkSuccess = 'Yes, check-{query} success !';
  static const String alreadyCheckedIn = "You have already checked-in for today.";
  static const String checkInFirst = "You haven't checked-in yet, please check-in first.";
  static const String invalidSecurityKey = "Invalid security key. Please check your settings.";
  static const String securityKeyMissing = 'Security key is missing. Please configure settings first.';
  static const String nameRequired = 'Name is required.';
  static const String queryParameterMissing = 'Query parameter is missing.';
  static const String wrongBarcodeFormat = 'The format of barcode is wrong.';
  static const String connectionTimeout = 'Connection timeout. Please check your internet connection.';
  static const String connectionError = 'Connection error. Please check your internet connection and server URL.';
  static const String networkError = 'Network error occurred';
  static const String unexpectedError = 'Unexpected error occurred: {error}';
  static const String waitForLocation = 'Wait, we are still checking your accurate location. Make sure to turn on your GPS Location.';

  // Location
  static const String locationServicesDisabled = 'Location services are disabled.';
  static const String locationPermissionsDenied = 'Location permissions are denied';
  static const String locationPermissionsPermanentlyDenied =
      'Location permissions are permanently denied, we cannot request permissions.';

  // Errors
  static const String error = 'Error';
  static const String warning = 'Warning';
  static const String success = 'Success';

  // Private constructor to prevent instantiation
  AppStrings._();
}
