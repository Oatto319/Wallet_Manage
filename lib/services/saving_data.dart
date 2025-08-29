class SavingData {
  static final List<Map<String, dynamic>> history = [];

  static void addSaving(double amount) {
    history.insert(0, {
      'date': DateTime.now().toIso8601String().substring(0, 10),
      'amount': amount,
    });
  }
}