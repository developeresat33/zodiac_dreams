import 'package:shared_preferences/shared_preferences.dart';

const String TOKEN_KEY = 'userToken';

class StorageManager {
  static Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefs;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences?> initPrefs() async {
    _prefs = await _instance;
    return _prefs;
  }

  static String getString(String key, [String? defValue]) {
    return _prefs?.getString(key) ?? defValue ?? '';
  }

  /// Returns user token
  ///
  /// Default value is null except you point [defValue] parameter
  static String? getToken([String? defValue]) {
    return _prefs?.getString(TOKEN_KEY) ?? defValue;
  }

  /// Returns if user authenticated or not
  ///
  /// return token == null || token == '';
  static bool get auth {
    var token = _prefs?.getString(TOKEN_KEY);
    return token != null && token != '';
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return prefs.setString(key, value);
  }

  static Future<bool> setToken(String? value) async {
    var prefs = await _instance;
    return prefs.setString(TOKEN_KEY, value!);
  }

  static bool? getBool(String? key, [String? defValue]) {
    return _prefs!.getBool(key!);
  }

  static Future<bool> setBool(String key, bool value) async {
    var prefs = await _instance;
    return prefs.setBool(key, value);
  }

  static Future<Future<bool>> setCacheVersion(int value) async {
    var prefs = await _instance;
    return prefs.setInt('cache_version', value);
  }

  static Future<int> getCacheVersion() async {
    var prefs = await _instance;
    return prefs.getInt('cache_version') ?? 0;
  }

  static Future<bool> isKeyExist(String key) async {
    var prefs = await _instance;
    return prefs.containsKey(key);
  }

/*   static Future<TokenModel> token() async {
    var prefs = await _instance;
    var token = prefs.getString(TOKEN_KEY);
    if (token == null || token == '') return TokenModel();
    return TokenModel.fromJson(parseJwt(token));
  }

  static void clearUserData() {
    _prefs.remove(TOKEN_KEY);
  }

  static void clearAll() {
    _prefs.clear();
  } */
}
