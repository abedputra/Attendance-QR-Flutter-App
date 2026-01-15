<img width="1536" height="1024" alt="Attendance Qr Code Plugin WP and Flutter App" src="https://github.com/user-attachments/assets/2b484743-ea9c-4fc2-82af-019d0dfd38c7" />

# Attendance with QR Code - Flutter Mobile App

[![Flutter](https://img.shields.io/badge/Flutter-3.35.5-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-GPL%20v2%2B-blue.svg)](https://www.gnu.org/licenses/gpl-2.0)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey.svg)](https://flutter.dev/)

A comprehensive Flutter mobile application for employee or student attendance tracking using QR codes. This app works seamlessly with the [Attendance with QR Code WordPress Plugin](https://github.com/abedputra/Attendance-QR-Plugin-Wordpress) to provide a complete attendance management solution.

## 📋 Table of Contents

- [Features](#-features)
- [Screenshots](#-screenshots)
- [Requirements](#-requirements)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Usage](#-usage)
- [Project Structure](#-project-structure)
- [Building the App](#-building-the-app)
- [WordPress Plugin Integration](#-wordpress-plugin-integration)
- [Technical Details](#-technical-details)
- [Contributing](#-contributing)
- [Support](#-support)
- [License](#-license)

## ✨ Features

### Core Features
- **QR Code Scanning**: Fast and accurate QR code scanning for attendance check-in/check-out
- **Check-In/Check-Out**: Simple one-tap attendance recording
- **GPS Location Tracking**: Automatic location recording for attendance verification
- **Location Accuracy Indicator**: Real-time GPS accuracy display
- **Offline Support**: Local database storage for offline access
- **Attendance History**: View all attendance records locally
- **Settings Management**: Easy configuration of server URL and security key
- **QR Code Setup**: Scan QR code for one-time configuration
- **Server-Side Time**: Date and time determined by server (prevents time manipulation)
- **Error Handling**: Comprehensive error handling with user-friendly messages

### User Experience
- **Modern UI**: Clean and intuitive Material Design interface
- **Splash Screen**: Professional splash screen on app launch
- **Progress Indicators**: Visual feedback during API calls
- **Alert Dialogs**: Clear success and error notifications
- **Permission Management**: Automatic handling of camera and location permissions
- **Responsive Design**: Optimized for various screen sizes

### Security Features
- **Security Key Authentication**: Secure API communication
- **Server-Side Validation**: All attendance data validated on server
- **Time Zone Support**: Accurate time tracking based on server timezone
- **Input Validation**: Client-side and server-side validation
- **Secure Storage**: Local database with encrypted storage

## 📱 Screenshots

### Main Features
- **Splash Screen**: Welcome screen with app branding
- **Main Menu**: Easy access to all features
- **Check-In/Check-Out**: Simple attendance recording
- **Settings**: Configure server connection
- **Reports**: View attendance history
- **About**: App information and version

## 📦 Requirements

### Development Requirements
- **Flutter SDK**: 3.35.5 or higher
- **Dart SDK**: 3.9.2 or higher
- **Android Studio** / **VS Code** with Flutter extensions
- **Android SDK**: API level 21 or higher (for Android development)
- **Xcode**: Latest version (for iOS development, macOS only)

### Runtime Requirements
- **Android**: 5.0 (API 21) or higher
- **iOS**: 12.0 or higher
- **Permissions**:
  - Camera (for QR code scanning)
  - Location (for GPS tracking)
  - Internet (for API communication)

### Backend Requirements
- **WordPress Plugin**: [Attendance with QR Code WordPress Plugin](https://github.com/your-repo/attendance-with-qr-code-wordpress) must be installed and configured
- **WordPress Site**: Accessible WordPress installation with the plugin activated
- **API Endpoint**: WordPress plugin API endpoint must be accessible

## 🚀 Installation

### Prerequisites

1. **Install Flutter**
   ```bash
   # Check Flutter installation
   flutter --version
   
   # If not installed, follow: https://flutter.dev/docs/get-started/install
   ```

2. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/attendance-with-qr-code-wp-flutter.git
   cd attendance-with-qr-code-wp-flutter
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

### Setup

1. **Configure Assets**
   - Place your app icon at `assets/icon/icon.png`
   - Place your logo at `images/logo.png`

2. **Configure App Package Name** (Optional)
   - Edit `android/app/build.gradle` to change package name
   - Update `applicationId` in `defaultConfig`

3. **Run the App**
   ```bash
   # For Android
   flutter run
   
   # For specific device
   flutter devices
   flutter run -d <device-id>
   ```

## 🎯 Quick Start

### First Time Setup

1. **Install the App**
   - Build and install the APK on your Android device
   - Or run `flutter run` for development

2. **Configure Server Connection**
   - On first launch, you'll see the setup screen
   - Scan the QR code from WordPress plugin settings
   - The app will automatically configure:
     - Server URL
     - Security Key
   - You'll be redirected to the main menu

3. **Grant Permissions**
   - Allow camera access (for QR scanning)
   - Allow location access (for GPS tracking)
   - These are required for attendance functionality

### Using the App

1. **Check-In**
   - Tap **Check-In** from main menu
   - Wait for GPS location to be accurate
   - Tap **Scan QR** button
   - Scan your personal QR code
   - Attendance is recorded automatically

2. **Check-Out**
   - Tap **Check-Out** from main menu
   - Wait for GPS location to be accurate
   - Tap **Scan QR** button
   - Scan your personal QR code
   - Check-out is recorded automatically

3. **View Reports**
   - Tap **Report** from main menu
   - View all attendance records
   - Data is stored locally and synced with server

4. **Settings**
   - Tap **Settings** from main menu
   - Scan new QR code to update server configuration
   - Change server URL and security key

## 📖 Usage

### Check-In Process

1. Open the app
2. Navigate to **Check-In** from main menu
3. Wait for GPS accuracy indicator (recommended: < 200m)
4. Tap **Scan QR** button
5. Point camera at your personal QR code
6. Wait for confirmation message
7. Attendance is recorded with:
   - Your name
   - Current date (from server)
   - Current time (from server)
   - GPS location
   - Location accuracy

### Check-Out Process

1. Open the app
2. Navigate to **Check-Out** from main menu
3. Wait for GPS accuracy indicator
4. Tap **Scan QR** button
5. Point camera at your personal QR code
6. Wait for confirmation message
7. Check-out is recorded with:
   - Out time (from server)
   - GPS location
   - Calculated work hours
   - Overtime (if applicable)

### Viewing Attendance History

1. Navigate to **Report** from main menu
2. View all locally stored attendance records
3. Records include:
   - Date and time
   - Check-in/Check-out type
   - Location information
   - Status

### Updating Settings

1. Navigate to **Settings** from main menu
2. Tap **Scan QR** button
3. Scan the configuration QR code from WordPress admin
4. Settings are updated automatically
5. Return to main menu

## 📁 Project Structure

```
lib/
├── core/                          # Core functionality
│   ├── constants/
│   │   ├── app_constants.dart    # App constants (API paths, thresholds, etc.)
│   │   └── app_strings.dart      # All string literals
│   └── theme/
│       └── app_theme.dart        # Theme configuration
├── data/                          # Data layer
│   ├── models/                   # Data models
│   │   ├── attendance.dart      # Attendance model
│   │   └── settings.dart        # Settings model
│   └── database/                 # Local database
│       └── db_helper.dart       # SQLite database helper
├── services/                      # Business logic
│   └── api_service.dart         # API service for WordPress integration
├── presentation/                  # UI layer
│   ├── screens/                  # App screens
│   │   ├── main_menu_page.dart  # Main menu
│   │   ├── attendance_page.dart # Check-in/Check-out
│   │   ├── scan_qr_page.dart    # Initial setup
│   │   ├── setting_page.dart    # Settings
│   │   ├── report_page.dart     # Attendance reports
│   │   ├── about_page.dart      # About page
│   │   └── qr_scanner_page.dart # QR scanner widget
│   └── utils/                    # Utilities
│       ├── utils.dart           # Helper functions
│       └── single_menu.dart     # Reusable menu widget
└── main.dart                     # App entry point
```

## 🔨 Building the App

### Build APK (Android)

```bash
# Build release APK
flutter build apk --release

# Build APK for specific architecture
flutter build apk --release --target-platform android-arm64

# Output location
# build/app/outputs/flutter-apk/app-release.apk
```

### Build App Bundle (Android - for Play Store)

```bash
# Build app bundle
flutter build appbundle --release

# Output location
# build/app/outputs/bundle/release/app-release.aab
```

### Build iOS (macOS only)

```bash
# Build iOS app
flutter build ios --release

# Or open in Xcode
open ios/Runner.xcworkspace
```

### Build Configuration

The app uses the following build configuration:
- **Min SDK**: Android API 21 (Android 5.0)
- **Target SDK**: Latest Android SDK
- **Kotlin**: 2.1.0
- **Gradle**: 8.7
- **Android Gradle Plugin**: 8.6.0

## 🔗 WordPress Plugin Integration

This mobile app is designed to work with the **Attendance with QR Code WordPress Plugin**.

### How It Works

1. **WordPress Plugin** generates QR codes for employees/students
2. **Mobile App** scans QR codes to record attendance
3. **API Communication** between app and WordPress server
4. **Server-Side Processing**:
   - Date/time calculation (prevents manipulation)
   - Attendance validation
   - Database storage
   - Work hours calculation

### API Endpoint

The app communicates with WordPress via:
```
POST {wordpress-url}/wp-content/plugins/attendance_with_qr_code/insert-attendance.php
```

**Request Parameters:**
- `key`: Security key (from WordPress settings)
- `name`: Employee/student name (from QR code)
- `q`: Command ('in' for check-in, 'out' for check-out)
- `location`: GPS location string

**Response Format:**
```json
{
  "success": true,
  "data": {
    "message": "Check-in successful!",
    "date": "2025-01-15",
    "time": "14:30:00",
    "location": "Location string",
    "query": "Check-in"
  }
}
```

### Security

- **Security Key**: Required for all API requests
- **Server Validation**: All data validated on WordPress server
- **Time Zone**: Server determines date/time based on configured timezone
- **Input Sanitization**: All inputs sanitized before processing

## 🛠️ Technical Details

### Dependencies

**Core:**
- `flutter`: SDK framework
- `dio`: HTTP client for API calls
- `sqflite`: Local SQLite database
- `path_provider`: File system paths

**Features:**
- `mobile_scanner`: QR code scanning
- `geolocator`: GPS location tracking
- `geocoding`: Reverse geocoding (address from coordinates)
- `permission_handler`: Runtime permissions
- `rflutter_alert`: Alert dialogs
- `progress_dialog_null_safe`: Loading indicators
- `font_awesome_flutter`: Icons

### Architecture

- **Clean Architecture**: Separation of concerns
- **Service Layer**: API calls separated from UI
- **Constants**: Centralized configuration
- **Models**: Data models for type safety
- **State Management**: setState() for state (can be upgraded to Provider/Riverpod)

### Code Quality

- ✅ Follows Flutter best practices
- ✅ Dart 3.0+ null safety
- ✅ Proper error handling
- ✅ Code documentation
- ✅ Linter compliant

### Database Schema

**Settings Table:**
- `id`: Primary key
- `url`: WordPress site URL
- `key`: Security key

**Attendance Table:**
- `id`: Primary key
- `date`: Attendance date
- `time`: Attendance time
- `name`: Employee/student name
- `location`: GPS location
- `type`: Check-in or Check-out

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
   - Follow Flutter/Dart style guide
   - Add comments for complex logic
   - Test your changes thoroughly
4. **Commit your changes**
   ```bash
   git commit -m "Add: Description of your feature"
   ```
5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```
6. **Create a Pull Request**

### Contribution Guidelines

- Follow [Flutter Style Guide](https://flutter.dev/docs/development/ui/widgets-intro)
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Write clear commit messages
- Test your code before submitting
- Update documentation if needed
- Be respectful and constructive in discussions

### Areas for Contribution

- 🐛 Bug fixes
- ✨ New features
- 📚 Documentation improvements
- 🎨 UI/UX enhancements
- ⚡ Performance optimizations
- 🔒 Security improvements
- 🌐 Localization/Internationalization
- 🧪 Unit tests and widget tests

## 📧 Support

- **Developer**: Abed Putra
- **Website**: [https://abedputra.my.id](https://abedputra.my.id)
- **Issues**: [GitHub Issues](https://github.com/your-username/attendance-with-qr-code-wp-flutter/issues)

If you encounter any issues or have questions:
1. Check the documentation above
2. Search existing GitHub issues
3. Create a new issue with detailed information
4. Contact support through the author's website

## 📄 License

This project is licensed under the GPL v2 or later.

```
Copyright (C) 2025 Abed Putra

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
```

## 🙏 Credits

- Built with ❤️ by [Abed Putra](https://abedputra.my.id)
- Uses [Flutter](https://flutter.dev/) framework
- QR Code scanning via [mobile_scanner](https://pub.dev/packages/mobile_scanner)
- Icons from [Font Awesome](https://fontawesome.com/)
- Location services via [geolocator](https://pub.dev/packages/geolocator)

## 📚 Related Projects

- **WordPress Plugin**: [Attendance with QR Code WordPress Plugin](https://github.com/abedputra/Attendance-QR-Plugin-Wordpress)
  - Required backend for this mobile app
  - Handles server-side attendance processing
  - Provides admin interface for attendance management

## 📝 Changelog

### Version 1.0.0
- Initial release
- QR code scanning for attendance
- Check-in/Check-out functionality
- GPS location tracking
- Local database storage
- WordPress plugin integration
- Settings management
- Attendance history
- Modern Material Design UI
- Comprehensive error handling
- Server-side time validation
- Security key authentication

## 🚀 Getting Started for Developers

### Prerequisites
- Flutter SDK 3.35.5+
- Dart SDK 3.9.2+
- Android Studio / VS Code
- Git

### Setup Steps

1. **Clone Repository**
   ```bash
   git clone https://github.com/your-username/attendance-with-qr-code-wp-flutter.git
   cd attendance-with-qr-code-wp-flutter
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

4. **Build APK**
   ```bash
   flutter build apk --release
   ```

### Development Tips

- Use `flutter analyze` to check code quality
- Use `flutter test` to run tests
- Check `analysis_options.yaml` for linting rules
- Follow the project structure for new features

---

**Made with ❤️ for efficient attendance management**

For more information, visit [https://abedputra.my.id](https://abedputra.my.id)
