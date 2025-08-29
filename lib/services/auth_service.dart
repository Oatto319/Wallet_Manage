class AuthService {
  static String? _loggedInUser;

  // Users เริ่มต้น รวม Admin
  static final Map<String, String> _users = {
    'test@test.com': 'password',       // user ปกติ
    'admin@domain.com': 'admin123',    // Admin
  };

  // Optionally กำหนด list ของ admin
  static final List<String> _admins = [
    'admin@domain.com',
  ];

  static Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_users[email] == password) {
      _loggedInUser = email;
      return true;
    }
    return false;
  }

  static Future<bool> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_users.containsKey(email)) {
      return false; // มี email นี้แล้ว
    }
    _users[email] = password;
    _loggedInUser = email;
    return true;
  }

  static void logout() {
    _loggedInUser = null;
  }

  static String? get currentUser => _loggedInUser;

  // เช็คว่า user ปัจจุบันเป็น admin หรือไม่
  static bool get isAdmin => _loggedInUser != null && _admins.contains(_loggedInUser);
}
