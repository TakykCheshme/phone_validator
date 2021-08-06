import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:phone_validator/models/validator.dart';

class TextInputMetaData{

  final String key;
  final String name;
  final Validation validation;
  final List<TextInputFormatter>? formatters;
  final String? hint;
  final String? prefix;
  final String? label;
  final Future<T?> Function<T>(BuildContext)? pickerMode;
  final Widget? suffix;
  final TextInputType? type;
  final bool autoFocus;

  TextInputMetaData({required this.name, this.autoFocus = false,this.type,required this.validation,required this.key,this.formatters, this.hint, this.prefix, this.label, this.suffix,this.pickerMode});

}