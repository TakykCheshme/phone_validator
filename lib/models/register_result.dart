import 'package:phone_validator/models/orm.dart';
import 'package:telephony/telephony.dart';

class RegisterResult extends Orm{

  bool get success => jSON['success'] ?? false;
  AppMessage get message => AppMessage(
      address: jSON['message']?['address'] ?? "", 
      body: jSON['message']?['body'] ?? "", 
      date: jSON['message']?['date']
  );

  RegisterResult.fromSMS(
    SmsMessage message, 
    bool success
  ):super({ 
    'message': {
      'body': message.body ?? "",
      'address': message.address ?? "",
      'date': message.date
    }, 
    'id': message.id ?? -1,
    'success': success
  });

  RegisterResult.fromMap(Map<String,dynamic> data):super({...data});
}

class AppMessage{
  final String address;
  final String body;
  final int? date;

  AppMessage({this.address = "", this.body = "", this.date});
}
