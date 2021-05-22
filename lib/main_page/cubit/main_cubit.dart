import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:phone_validator/models/register_result.dart';
import 'package:telephony/telephony.dart';

import '../../network.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainStateNormal> {
  late Network network;
  List<RegisterResult> results = [];
  MainCubit() : super(MainStateNormal([])) {
    network = Network();
    final telephony = Telephony.instance;
    telephony.listenIncomingSms(
      onNewMessage: handleMessage,
      listenInBackground: false,
      // TODO Try background message handling
    );
  }

  handleMessage(SmsMessage message) async {
    try {
      final success =
          await network.registerNumber(message.address, message.body);
      final result = RegisterResult(message, success);
      results = [...results, result];
      emit(MainStateNormal(results));
    } catch (e) {
      final result = RegisterResult(message, false);
      results = [...results, result];
      emit(MainStateNormal(results));

      Future.delayed(Duration(seconds: 5));
      handleMessage(message);
    }
  }
}
