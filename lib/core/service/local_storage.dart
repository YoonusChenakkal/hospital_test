import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._(); // private constructor to prevent instantiation

  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences instance
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Write data (supports basic types)
  static Future<void> write({
    required String key,
    required dynamic value,
  }) async {
    if (_prefs == null) await init();

    if (value is String) {
      await _prefs!.setString(key, value);
    } else if (value is int) {
      await _prefs!.setInt(key, value);
    } else if (value is double) {
      await _prefs!.setDouble(key, value);
    } else if (value is bool) {
      await _prefs!.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs!.setStringList(key, value);
    } else {
      throw Exception("Unsupported value type");
    }
  }

  /// Read data
  static dynamic read(String key) {
    return _prefs?.get(key);
  }

  /// Remove a specific key
  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  /// Clear all stored keys
  static Future<void> clear() async {
    await _prefs?.clear();
  }
}
