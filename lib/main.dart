import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(WorldExplorerApp());
}

class WorldExplorerApp extends StatefulWidget {
  // GlobalKey para poder acceder a los métodos de cambio desde otras pantallas
  static final GlobalKey<_WorldExplorerAppState> appKey = GlobalKey();

  WorldExplorerApp() : super(key: appKey);

  @override
  _WorldExplorerAppState createState() => _WorldExplorerAppState();
}

class _WorldExplorerAppState extends State<WorldExplorerApp> {
  bool isDarkMode = false;
  bool isFahrenheit = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
      isFahrenheit = prefs.getBool('isFahrenheit') ?? false;
    });
  }

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = !isDarkMode;
      prefs.setBool('isDarkMode', isDarkMode);
    });
  }

  void toggleUnits() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFahrenheit = !isFahrenheit;
      prefs.setBool('isFahrenheit', isFahrenheit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorldExplorer',
      theme: isDarkMode ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true),
      home: SearchScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}