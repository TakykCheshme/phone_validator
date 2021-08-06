import 'package:bloc/bloc.dart';
import 'package:phone_validator/models/persistentStorage.dart';
import 'package:phone_validator/models/settings.dart';
import 'package:phone_validator/network.dart';
import 'package:phone_validator/services/backgroundSMSService.dart';
import 'package:telephony/telephony.dart';

import '../../models/register_result.dart';


class MainCubit extends Cubit<List<RegisterResult>> {

  MainCubit() : super([]) {
    final telephony = Telephony.instance;
    telephony.listenIncomingSms(
      onNewMessage: handleMessage,
      listenInBackground: true,
      onBackgroundMessage: backgroundSMSService 
    );
  }

  void init(PersistentStorage prefs){
    emit([...getResults(prefs)]);
  }

  void handleMessage(SmsMessage message, {int attempt = 0}) async {
    try {
      var settings = await Settings.getInstance();
      var network = Network(settings.baseUrl);
      final success =
          await network.registerNumber(message.address, message.body);
      final result = RegisterResult.fromSMS(message, success);
      await saveResults([...state, result]);
      emit([...state, result]);
    } catch (e){
      print(e);
      final result = RegisterResult.fromSMS(message, false);
      await saveResults([...state, result]);
      emit([...state, result]);
      await Future.delayed(Duration(seconds: 5));
      if (attempt < 25) handleMessage(message, attempt: ++attempt);
      else await sendIfError(Telephony.instance);
    }
  }
}
