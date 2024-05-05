import 'package:shared_preferences/shared_preferences.dart';

class CashHelper {
  static SharedPreferences? sharedPreferences;


  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

 static Future<bool> putBoolData({required String key, required bool value}) async {

    return await sharedPreferences!.setBool(key, value);
  }

 static bool? getBoolData({required String key}){
    return sharedPreferences!.getBool(key);
  }


  static Future<bool> putStringData({required String key, required String value}) async {

    return await sharedPreferences!.setString(key, value);
  }

  static String? getStringData({required String key}){
    return sharedPreferences!.getString(key);
  }

  static void deleteData({required String key}){
     sharedPreferences!.remove(key);
  }

}
