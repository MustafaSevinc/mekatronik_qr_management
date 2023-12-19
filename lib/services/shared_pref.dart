import 'package:mekatronik_qr_management/objects/local_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late SharedPreferences _sharedPreferences;

  static Future init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future setString(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  static String? getString(String key) {
    return _sharedPreferences.getString(key);
  }

  static Future setBool(String key, bool value) async {
    await _sharedPreferences.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _sharedPreferences.getBool(key);
  }

  static Future setInt(String key, int value) async {
    await _sharedPreferences.setInt(key, value);
  }

  static int? getInt(String key) {
    return _sharedPreferences.getInt(key);
  }

  static Future setDouble(String key, double value) async {
    await _sharedPreferences.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return _sharedPreferences.getDouble(key);
  }

  static Future setStringList(String key, List<String> value) async {
    await _sharedPreferences.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return _sharedPreferences.getStringList(key);
  }

  static Future<bool> clear() async {
    return await _sharedPreferences.clear();
  }

  static Future<bool> remove(String key) async {
    return await _sharedPreferences.remove(key);
  }

  //================================================================================================
  //======================================== CUSTOM METHODS ========================================
  //================================================================================================

  static void setLocalDataList(String key, List<LocalData> localDataList) {
    final List<String> str = localDataList.map((e) => e.toString()).toList();
    _sharedPreferences.setStringList(key, str);
  }

  static List<LocalData> getLocalDataList(String key) {
    final List<String>? str = _sharedPreferences.getStringList(key);
    if (str == null) {
      return [];
    }
    return str.map((e) => LocalData.fromString(e)).toList();
  }
}
