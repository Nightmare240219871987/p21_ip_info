import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPrefs? _instance;
  SharedPreferences? _shared;
  List<String> _history = [];

  SharedPrefs._internal();

  Future<void> initialize() async {
    _shared = await SharedPreferences.getInstance();
    _history = _shared!.getStringList("history") ?? [];
  }

  factory SharedPrefs() {
    _instance ??= SharedPrefs._internal();
    return _instance!;
  }

  List<String> getHistory() {
    _history = _shared!.getStringList("history") ?? [];
    return _history;
  }

  void addToHistory(String ip) {
    if (!_history.contains(ip)) {
      _history.add(ip);
    }
    _shared!.setStringList("history", _history);
  }

  void clearHistory() {
    _history.clear();
    _shared!.setStringList("history", _history);
  }
}
