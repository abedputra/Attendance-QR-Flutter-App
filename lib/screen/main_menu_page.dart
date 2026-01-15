import 'package:attendancewithqrwp/core/constants/app_strings.dart';
import 'package:attendancewithqrwp/core/theme/app_theme.dart';
import 'package:attendancewithqrwp/screen/about_page.dart';
import 'package:attendancewithqrwp/screen/attendance_page.dart';
import 'package:attendancewithqrwp/screen/report_page.dart';
import 'package:attendancewithqrwp/screen/setting_page.dart';
import 'package:attendancewithqrwp/utils/single_menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Menu();
  }
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  void initState() {
    _getPermission();
    super.initState();
  }

  Future<void> _getPermission() async {
    getPermissionAttendance();
  }

  Future<void> getPermissionAttendance() async {
    await [
      Permission.camera,
      Permission.location,
      Permission.locationWhenInUse,
    ].request().then((value) {
      _determinePosition();
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    /// Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      getSnackBar(AppStrings.locationServicesDisabled);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        getSnackBar(AppStrings.locationPermissionsDenied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      getSnackBar(AppStrings.locationPermissionsPermanentlyDenied);
    }

    return Geolocator.getCurrentPosition();
  }

  /// Show snackBar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> getSnackBar(
    String messageSnackBar,
  ) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(messageSnackBar)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(bottom: 40.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 200.0,
                color: AppTheme.checkInColor,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('images/logo.png'),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      AppStrings.appTitle,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  SingleMenu(
                    icon: FontAwesomeIcons.clock,
                    menuName: AppStrings.menuCheckIn,
                    color: AppTheme.checkInColor,
                    action: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AttendancePage(
                          query: 'in',
                          title: AppStrings.checkInTitle,
                        ),
                      ),
                    ),
                  ),
                  SingleMenu(
                    icon: FontAwesomeIcons.rightFromBracket,
                    menuName: AppStrings.menuCheckOut,
                    color: AppTheme.checkOutColor,
                    action: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AttendancePage(
                          query: 'out',
                          title: AppStrings.checkOutTitle,
                        ),
                      ),
                    ),
                  ),
                  SingleMenu(
                    icon: FontAwesomeIcons.gears,
                    menuName: AppStrings.menuSettings,
                    color: AppTheme.settingsColor,
                    action: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SettingPage(),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SingleMenu(
                    icon: FontAwesomeIcons.calendar,
                    menuName: AppStrings.menuReport,
                    color: AppTheme.reportColor,
                    action: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ReportPage(),
                      ),
                    ),
                  ),
                  SingleMenu(
                    icon: FontAwesomeIcons.user,
                    menuName: AppStrings.menuAbout,
                    color: AppTheme.aboutColor,
                    action: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AboutPage(),
                      ),
                    ),
                  ),
                  const SingleMenu(
                    icon: FontAwesomeIcons.info,
                    menuName: AppStrings.appVersion,
                    color: AppTheme.versionColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
