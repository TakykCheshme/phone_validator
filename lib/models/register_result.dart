import 'package:equatable/equatable.dart';
import 'package:telephony/telephony.dart';

class RegisterResult extends Equatable {
  final SmsMessage message;
  final bool success;

  RegisterResult(this.message, this.success);

  @override
  List<Object?> get props => [message, success];
}
