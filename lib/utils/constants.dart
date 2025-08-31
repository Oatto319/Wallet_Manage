import 'package:flutter/material.dart';

class AppConfig {
  static const String appName = 'Flutter API Transaction';
  static const String version = '1.0.0';

  // API Config
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const int timeoutSeconds = 30;

  // UI
  static const double cardElevation = 2.0;
  static const double borderRadius = 12.0;
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);

  // Colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);
}
