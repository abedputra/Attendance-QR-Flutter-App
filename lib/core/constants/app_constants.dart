/// Application constants
/// Contains all hardcoded values and configuration constants
class AppConstants {
  // API Configuration
  static const String apiPath =
      'wp-content/plugins/attendance_with_qr_code/insert-attendance.php';

  // Location Configuration
  static const double locationAccuracyThreshold = 200.0; // meters

  // App Configuration
  static const String appName = 'Attendance with QR code';
  static const String appVersion = '1.0';

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration splashScreenDuration = Duration(seconds: 5);

  // Colors
  static const int primaryColorValue = 0xFF3f6ae0;
  static const int accentColorValue = 0xFFf7c846;

  // Database
  static const String databaseName = 'attendance.db';
  static const String tableSettings = 'settings';
  static const String tableAttendance = 'attendances';

  // Private constructor to prevent instantiation
  AppConstants._();
}
