import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:telephony/telephony.dart';

import '../../models/register_result.dart';
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
    );
  }

  handleMessage(SmsMessage message, {int attempt = 0}) async {
    try {
      final success =
          await network.registerNumber(message.address, message.body);
      final result = RegisterResult(message, success);
      results = [...results, result];
      emit(MainStateNormal(results));
    } catch (e) {
      print(e);
      final result = RegisterResult(message, false);
      results = [...results, result];
      emit(MainStateNormal(results));

      await Future.delayed(Duration(seconds: 5));
      if (attempt < 25) handleMessage(message, attempt: ++attempt);
    }
  }
}
