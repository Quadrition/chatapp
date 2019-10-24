import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AppSettingsService {
  static AppSettingsService _instance;
  static SharedPreferences _preferences;

  static const String _UsernameKey = 'username';
  static const String _FcmTokenKey = 'fcm_token';
  static const String _DeviceIdKey = 'device_id';

  static Future<AppSettingsService> getInstance() async {
    if (_instance == null) {
      _instance = AppSettingsService();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }


  String get username => _getFromDisk(_UsernameKey) ?? "";
  set username(String value) => _saveToDisk(_UsernameKey, value);

  //checks whether the user is already registered which is the same as if the username exists
  bool get isFirstRun {
    if (username=="") {
      return true;
    } else {
      return false;
    }
  }

  //this is token for the Firebase messaging services
  String get fcmToken => _getFromDisk(_FcmTokenKey) ?? "";
  set fcmToken(String value) => _saveToDisk(_FcmTokenKey, value);

//An unique device id, which identifies the mobile device, it it does not exists
  String get deviceId {
    if (!_preferences.containsKey(_DeviceIdKey)) {
      var uuid = new Uuid();
      deviceId = uuid.v4();
    }
    return _getFromDisk(_DeviceIdKey);
  }

  set deviceId(String value) => _saveToDisk(_DeviceIdKey, value);


  //a helper function which gets an individual setting to disk
  dynamic _getFromDisk(String key) {
    var value  = _preferences.get(key);
    //print('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

// a helper function that saves an individual setting , can handle all types
  void _saveToDisk<T>(String key, T content){
    //print('(TRACE) LocalStorageService:_saveToDisk. key: $key value: $content');

    if(content is String) {
      _preferences.setString(key, content);
    }
    if(content is bool) {
      _preferences.setBool(key, content);
    }
    if(content is int) {
      _preferences.setInt(key, content);
    }
    if(content is double) {
      _preferences.setDouble(key, content);
    }
    if(content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }


}
