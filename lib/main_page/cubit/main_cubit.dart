import 'package:bloc/bloc.dart';
import 'package:phone_validator/models/persistentStorage.dart';
import 'package:phone_validator/services/backgroundSMSService.dart';
import 'package:telephony/telephony.dart';

import '../../models/register_result.dart';
import '../../network.dart';


class MainCubit extends Cubit<List<RegisterResult>> {
  late Network network;

  MainCubit() : super([]) {
    network = Network();
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
      final success =
          await network.registerNumber(message.address, message.body);
      final result = RegisterResult.fromSMS(message, success);
      await saveResults([...state, result]);
      emit([...state, result]);
    } catch (e) {
      print(e);
      final result = RegisterResult.fromSMS(message, false);
      await saveResults([...state, result]);
      emit([...state, result]);
      await Future.delayed(Duration(seconds: 5));
      if (attempt < 25) handleMessage(message, attempt: ++attempt);
    }
  }
}
