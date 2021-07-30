import 'package:better_sitt/first_page/first_page_widget.dart';
// import 'package:better_sitt/login_v1/models/user.dart';
// import 'package:better_sitt/login_v1/services/auth.dart';
import 'package:better_sitt/model/positions.dart';
import 'package:better_sitt/registration/registration_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:better_sitt/today/today_widget.dart';
import 'package:provider/provider.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'archive/archive_widget.dart';
import 'login_v1/authentication_services.dart';
import 'login_v1/login_v1_widget.dart';
import 'today/today_widget.dart';
import 'settings/settings_widget.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(PositionsAdapter());
  await Hive.openBox<Positions>('positions');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BetterSitt',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FirstPageWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// class AuthenticationWrapper extends StatelessWidget {
//   const AuthenticationWrapper({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     final fireBaseUser = context.watch<User>();
//     if (fireBaseUser != null){
//       return NavBarPage();
//     }
//     return LoginV1Widget();
//   }
// }


class NavBarPage extends StatefulWidget {
  NavBarPage({Key? key, this.initialPage}) : super(key: key);

  final String? initialPage;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPage = 'Today';

  @override
  void initState() {

    super.initState();
    _currentPage = widget.initialPage ?? _currentPage;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'Archive': ArchiveWidget(),
      'Today': TodayWidget(),
      'Settings': SettingsWidget(),
    };
    return Scaffold(
      body: tabs[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.date_range,
              size: 24,
            ),
            activeIcon: Icon(
              Icons.date_range_outlined,
              size: 24,
            ),
            label: 'Archive',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.data_usage,
              size: 24,
            ),
            activeIcon: Icon(
              Icons.data_usage_outlined,
              size: 24,
            ),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: 24,
            ),
            activeIcon: Icon(
              Icons.settings_outlined,
              size: 24,
            ),
            label: 'Settings',
          )
        ],
        backgroundColor: FlutterFlowTheme.primaryColor,
        currentIndex: tabs.keys.toList().indexOf(_currentPage),
        selectedItemColor: FlutterFlowTheme.secondaryColor,
        unselectedItemColor: FlutterFlowTheme.tertiaryColor,
        onTap: (i) => setState(() => _currentPage = tabs.keys.toList()[i]),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
