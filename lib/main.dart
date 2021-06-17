import 'package:better_sitt/first_page/first_page_widget.dart';
import 'package:better_sitt/registration/registration_widget.dart';
import 'package:flutter/material.dart';
import 'package:better_sitt/today/today_widget.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'archive/archive_widget.dart';
import 'today/today_widget.dart';
import 'settings/settings_widget.dart';

void main() {
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
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({Key key, this.initialPage}) : super(key: key);

  final String initialPage;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPage = 'Archive';

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
