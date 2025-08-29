class AuthService {
  static String? _loggedInUser;
  static final Map<String, String> _users = {
    'test@test.com': 'password', // user เริ่มต้น
  };

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
}