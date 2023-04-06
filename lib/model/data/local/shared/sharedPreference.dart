import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constant/constants.dart';
import '../../../../constant/functions.dart';

class SharedPreference{

  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static setData(String key,dynamic value)async{
    SharedPreferences prefs =await _prefs;
    if (value is bool) {
      await prefs.setBool(key, value);
    }else if(value is String){
      await prefs.setString(key, value);
    }else if(value is double){
      await prefs.setDouble(key, value);
    }else if(value is int){
      await prefs.setInt(key, value);
    }else if(value is List<String>){
      await prefs.setStringList(key, value);
    }
  }

  Future<String?> getString(String key)async{
    SharedPreferences prefs =await _prefs;
    return prefs.getString(key);
  }
  Future<int?> getInt(String key)async{
    SharedPreferences prefs =await _prefs;
    return prefs.getInt(key);
  }

  Future<void> removeValue(String key)async{
    SharedPreferences prefs =await _prefs;
    await prefs.remove(key);
  }

  void clearAllSavedUserData(){
    debugPrintFunction("(------------------clearAllSavedUserData------------------)");
    removeValue(sharedAccessToken);
    removeValue(sharedMobileNumber);
    removeValue(sharedRefreshToken);
  }
}