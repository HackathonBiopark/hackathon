import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String userTypeKey = 'userType';

  // Salvar o tipo de usuário
  static Future<void> saveUserType(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userTypeKey, userType);
  }

  // Recuperar o tipo de usuário
  static Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userTypeKey);
  }

  // Remover o tipo de usuário (logout)
  static Future<void> clearUserType() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userTypeKey);
  }
}
