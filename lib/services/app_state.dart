import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  bool _isThai = true;
  ThemeMode _themeMode = ThemeMode.light;
  bool _isLoading = true;

  bool get isThai => _isThai;
  ThemeMode get themeMode => _themeMode;
  bool get isLoading => _isLoading;

  // Load settings จาก SharedPreferences
  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isThai = prefs.getBool('is_thai') ?? true;
      final themeIndex = prefs.getInt('theme_mode') ?? 0;
      _themeMode = ThemeMode.values[themeIndex];
    } catch (e) {
      _isThai = true;
      _themeMode = ThemeMode.light;
    }

    _isLoading = false;
    notifyListeners();
  }

  // เปลี่ยนภาษา
  Future<void> setLocale(bool isThai) async {
    _isThai = isThai;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_thai', isThai);
    } catch (e) {
      debugPrint('Error saving language preference: $e');
    }
  }

  // เปลี่ยนธีม
  Future<void> setTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('theme_mode', themeMode.index);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }
}

// Inherited Widget สำหรับ MyApp
class MyApp extends InheritedNotifier<AppState> {
  const MyApp({
    super.key,
    required AppState appState,
    required super.child,
  }) : super(notifier: appState);

  static AppState of(BuildContext context) {
    final appState = context.dependOnInheritedWidgetOfExactType<MyApp>()?.notifier;
    if (appState == null) {
      throw Exception('AppState not found in context');
    }
    return appState;
  }
}

// --------------------
// ตัวอย่างการใช้งาน
// --------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppState();
  await appState.loadSettings();

  runApp(
    MyApp(
      appState: appState,
      child: const MyHomePage(),
    ),
  );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = MyApp.of(context);

    if (appState.isLoading) {
      return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: appState.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: const Text('Demo AppState')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Language: ${appState.isThai ? 'Thai' : 'English'}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => appState.setLocale(!appState.isThai),
                child: const Text('Toggle Language'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => appState.setTheme(
                  appState.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
                ),
                child: const Text('Toggle Theme'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
