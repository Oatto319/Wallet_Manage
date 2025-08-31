import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart' as home;
import 'screens/profile_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'utils/constants.dart';
import 'package:provider/provider.dart';

// ------------------- Mock AuthService -------------------
class AuthService {
  static String? currentUser = 'John Doe';
  static String? currentEmail = 'john@example.com';

  static Future<void> updateUser(String name, String email) async {
    await Future.delayed(const Duration(seconds: 1));
    currentUser = name;
    currentEmail = email;
  }

  static Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    currentUser = null;
    currentEmail = null;
  }
}

// ------------------- AppState -------------------
class AppState extends ChangeNotifier {
  bool _isThai = true;
  ThemeMode _themeMode = ThemeMode.light;

  bool get isThai => _isThai;
  ThemeMode get themeMode => _themeMode;

  void setLocale(bool isThai) {
    _isThai = isThai;
    notifyListeners();
  }

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

// ------------------- MyApp -------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static AppState of(BuildContext context) =>
      Provider.of<AppState>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: AppConfig.appName,
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light().copyWith(primaryColor: AppConfig.primaryColor),
            darkTheme: ThemeData.dark().copyWith(primaryColor: AppConfig.primaryColor),
            themeMode: appState.themeMode,
            locale: appState.isThai ? const Locale('th') : const Locale('en'),
            supportedLocales: const [Locale('th'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale != null) {
                for (var supported in supportedLocales) {
                  if (supported.languageCode == locale.languageCode) {
                    return supported;
                  }
                }
              }
              return supportedLocales.first;
            },
            initialRoute: '/login',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/login':
                  return MaterialPageRoute(builder: (_) => const LoginScreen());
                case '/register':
                  return MaterialPageRoute(builder: (_) => const RegisterScreen());
                case '/home':
                  return MaterialPageRoute(builder: (_) => const home.HomeScreen());
                case '/profile':
                  return MaterialPageRoute(builder: (_) => const ProfileScreen());
                case '/editProfile':
                  return MaterialPageRoute(builder: (_) => const EditProfileScreen());
                default:
                  return MaterialPageRoute(builder: (_) => const LoginScreen());
              }
            },
          );
        },
      ),
    );
  }
}

// ------------------- Entry Point -------------------
void main() {
  runApp(const MyApp());
}