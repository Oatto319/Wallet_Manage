import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // --------------------
  // Private Fields
  // --------------------
  static String? _loggedInUser;
  static String? _currentEmail;

  // Users เริ่มต้น รวม Admin
  static final Map<String, String> _users = {
    'test@test.com': 'password',       // user ปกติ
    'admin@domain.com': 'admin123',    // Admin
  };

  // รายชื่อ admin
  static final List<String> _admins = [
    'admin@domain.com',
  ];

  // --------------------
  // Initialize - เรียกตอนเริ่มแอพ
  // --------------------
  static Future<void> init() async {
    await loadFromPrefs();
  }

  // --------------------
  // Login
  // --------------------
  static Future<bool> login(String email, String password) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      if (_users[email] == password) {
        _loggedInUser = email.split('@')[0];
        _currentEmail = email;
        await _saveToPrefs();
        debugPrint('Login success: $email');
        return true;
      }
      debugPrint('Login failed: invalid email or password');
      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  // --------------------
  // Register
  // --------------------
  static Future<bool> register(String email, String password) async {
    try {
      if (!isValidEmail(email)) {
        debugPrint('❌ Invalid email format: $email');
        return false;
      }
      if (!isValidPassword(password)) {
        debugPrint('❌ Password too short (min 6 chars)');
        return false;
      }
      if (_users.containsKey(email)) {
        debugPrint('❌ Email already exists: $email');
        return false;
      }

      await Future.delayed(const Duration(milliseconds: 500));
      _users[email] = password;
      _loggedInUser = email.split('@')[0];
      _currentEmail = email;
      await _saveToPrefs();
      debugPrint('✅ User registered successfully: $email');
      return true;
    } catch (e) {
      debugPrint('Register error: $e');
      return false;
    }
  }

  // --------------------
  // Logout
  // --------------------
  static Future<void> logout() async {
    try {
      _loggedInUser = null;
      _currentEmail = null;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('name');
      await prefs.remove('email');

      debugPrint('User logged out');
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  // --------------------
  // Update Profile (ชื่อ + อีเมล)
  // --------------------
  static Future<bool> updateProfile({
    required String name,
    required String email,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _loggedInUser = name;
      _currentEmail = email;
      await _saveToPrefs();
      debugPrint('✅ Profile updated: $name, $email');
      return true;
    } catch (e) {
      debugPrint('Update profile error: $e');
      return false;
    }
  }

  // --------------------
  // Check if logged in
  // --------------------
  static bool get isLoggedIn => _currentEmail != null;

  // --------------------
  // Public Getters
  // --------------------
  static String? get currentUser => _loggedInUser;
  static String? get currentEmail => _currentEmail;
  static bool get isAdmin => _currentEmail != null && _admins.contains(_currentEmail);

  // --------------------
  // SharedPreferences
  // --------------------
  static Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', _loggedInUser ?? '');
      await prefs.setString('email', _currentEmail ?? '');
    } catch (e) {
      debugPrint('Save to prefs error: $e');
    }
  }

  static Future<void> loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _loggedInUser = prefs.getString('name');
      _currentEmail = prefs.getString('email');
      debugPrint('Loaded from prefs: $_loggedInUser, $_currentEmail');
    } catch (e) {
      debugPrint('Load from prefs error: $e');
    }
  }

  // --------------------
  // Additional Helpers
  // --------------------
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static Map<String, String> get allUsers => Map.unmodifiable(_users);

  static Future<bool> deleteUser(String email) async {
    try {
      if (!isAdmin) {
        debugPrint('❌ Only admin can delete users');
        return false;
      }
      if (_admins.contains(email)) {
        debugPrint('❌ Cannot delete admin account');
        return false;
      }
      if (_users.remove(email) != null) {
        debugPrint('✅ User deleted: $email');
        return true;
      }
      debugPrint('❌ User not found: $email');
      return false;
    } catch (e) {
      debugPrint('Delete user error: $e');
      return false;
    }
  }
}
