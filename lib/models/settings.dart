import 'package:phone_validator/models/persistentStorage.dart';
import 'package:phone_validator/models/textMetaData.dart';
import 'package:phone_validator/models/validator.dart';

const _BASE_URL = "http://95.85.122.117/api/";
const _REGISTER_NUMBER = 'sms';
const _POINT_ID = 1;
const _GATEAWAY_PHONE = '99361100343';
const _TOKEN = "E6HUEhG8GTC2PO7HIIWpr1MrvaUBlKr7";

class Settings{

  final String baseUrl;
  final String smsPath;
  final String gateWayPhone;
  final String gateWayToken;

  static List<TextInputMetaData> get credentials => [
    TextInputMetaData(
      name: 'Url', 
      label: 'Url',
      validation: Validation(
        condition: (inp){ return Uri.tryParse(inp) == null; },
        message: 'Specify valid url'
      ), 
      hint: 'http(s)://domen.com/api/',
      key: 'url'
    ),
    TextInputMetaData(
      name: 'Gateway phone', 
      label: 'Gateway phone',
      validation: Validation(
        condition: (inp){ return  RegExp(r'9936[1-9]\d{6}$').hasMatch(inp);},
        message: 'Specify valid phone'
      ), 
      hint: '993xxxxxxxx',
      key: 'phone'
    ),
    TextInputMetaData(
      name: 'Token', 
      label: 'Token',
      validation: Validation(
        condition: (inp){ return inp.isEmpty; },
        message: 'Must Not be Empty'
      ), 
      hint: 'Enter token here',
      key: 'token'
    ),
    TextInputMetaData(
      name: 'Sms api path', 
      label: 'Sms api path',
      validation: Validation(
        condition: (inp){ return inp.isNotEmpty; },
        message: 'Must Not be Empty'
      ), 
      hint: 'sms',
      key: 'path'
    ),
  ];

  String getValueByKey(String key){
    return {
      'url': baseUrl,
      'token':gateWayToken,
      'phone': gateWayPhone,
      'path': smsPath
    }[key]!;
  }

  static Future<Settings> getInstance()async{

    var prefs = await PersistentStorage.getInstance();

    return Settings._(
      baseUrl: prefs.getItem<String>('settings_url') ?? _BASE_URL, 
      gateWayPhone: prefs.getItem<String>('settings_phone') ?? _GATEAWAY_PHONE, 
      gateWayToken: prefs.getItem<String>('settings_token') ?? _TOKEN, 
      smsPath: prefs.getItem<String>('settings_path') ?? _REGISTER_NUMBER
    ); 

  }

  static Future<void> changeModel({required String key,required String value})async{
    var prefs = await PersistentStorage.getInstance();
    return prefs.setItem<String>('settings_$key', value);
  }

  Settings._({ required this.baseUrl, required this.gateWayPhone, required this.gateWayToken, required this.smsPath  });

}