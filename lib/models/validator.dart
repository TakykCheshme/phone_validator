class Validation{

  final bool Function(String) condition;
  final String message;

  String? validate(String input){
    if(!condition(input)){
      return message;
    }
    return null;
  }

  Validation({required this.condition, required this.message});

  static bool phoneValidator(String input) => RegExp(r'6[1-9] \d{6}$').hasMatch('${input.trim()}');

}