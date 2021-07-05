import 'package:phone_validator/const.dart';
import 'package:phone_validator/models/persistentStorage.dart';
import 'package:phone_validator/models/register_result.dart';
import 'package:phone_validator/network.dart';
import 'package:telephony/telephony.dart';

Future<void> saveResults(List<RegisterResult> results)async{
  var prefs = await PersistentStorage.getInstance();
  prefs.setItem<List<Map<String,dynamic>>>(
    kDefaultResultsStorageFolder, 
    [
      for(var result in results)
        result.jSON
    ]
  );
}

List<RegisterResult> getResults(PersistentStorage prefs){
  return [
    for(var item in [...prefs.getItem<List>(kDefaultResultsStorageFolder) ?? []])
      RegisterResult.fromMap(item)
  ];
}


Future<void> sendIfError( Telephony telephony ){

  return telephony.sendSms(to: '+99364419426', message: 'Phone validator sboy!', statusListener: (_){
    print(_);
  });

}

void backgroundSMSService(SmsMessage message)async{
  final prefs = await PersistentStorage.getInstance();
  final previous = [...getResults(prefs)];
  final network = Network();
  late final bool success;  
  try {
    success = await network.registerNumber(message.address, message.body);
  } catch (e) {
    success = false;
    await sendIfError(Telephony.backgroundInstance);
  }
  final newResult = RegisterResult.fromSMS(message, success);
  await saveResults([...previous,newResult]);
}