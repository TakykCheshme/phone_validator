import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_validator/models/textMetaData.dart';
import 'package:phone_validator/models/sizing.dart';

class TextInputCustom extends StatefulWidget{
  final double? fontSize;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final TextEditingController controller;
  final TextInputMetaData fieldStandart;
  final bool? showPassword;
  final void Function(String?)? onChanged;

  TextInputCustom({ 
    Key? key,
    this.showPassword,
    this.fontSize, 
    this.padding, 
    this.margin, 
    required this.fieldStandart,
    this.onChanged,
    required this.controller, 
  }):super(key: key);

  @override
  _TextInputCustomState createState() => _TextInputCustomState();
}

class _TextInputCustomState extends State<TextInputCustom> {

  late FocusNode _focusNode;
  bool hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(() {
        setState(() {
          hasFocus = _focusNode.hasFocus;
        });
     });
  }


  @override
  Widget build(BuildContext context) {

    final double textSize = 14.font();
    final border = OutlineInputBorder(
     borderSide: BorderSide( 
        color:Colors.grey.shade300,
        width:0.9.font(),
       ),
    );
    print(hasFocus);

    return Container(
      margin: widget.margin ?? EdgeInsets.symmetric(
        vertical: 12.font()
      ),
      child: Column(
        children: <Widget>[
           Container(  
             child: GestureDetector(
               onTap: widget.fieldStandart.pickerMode == null?  null: ()async{
                   widget.controller.text = (await widget.fieldStandart.pickerMode!(context))?.toString() ?? "";                   
               },
               child: Row(
                 children: [
                   Expanded(
                     child: TextFormField(
                        cursorColor: Theme.of(context).accentColor,
                        keyboardType: widget.fieldStandart.type,
                        focusNode: _focusNode,
                        controller: widget.controller,
                        autofocus: widget.fieldStandart.autoFocus,
                        onChanged: widget.onChanged,
                        cursorHeight: 15.2.font(),
                        style: TextStyle(
                          fontSize: widget.fontSize ?? textSize*0.9,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyText1?.color
                        ),
                        validator: (i) => widget.fieldStandart.validation.validate(i ?? ""),
                        inputFormatters: widget.fieldStandart.formatters,
                        obscureText: widget.fieldStandart.key == 'password' && widget.showPassword == true,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding:widget.padding ??  EdgeInsets.symmetric( 
                            horizontal: 15.font(), 
                            vertical: 14.font() 
                          ), 
                          disabledBorder: border,
                          enabled: widget.fieldStandart.pickerMode == null,
                          border: border,
                          enabledBorder: border,
                          prefix: Text(
                            widget.fieldStandart.prefix ?? "",
                            style: TextStyle(
                               fontSize: widget.fontSize ?? textSize*0.9,
                               fontWeight: FontWeight.w500,
                               color: Theme.of(context).textTheme.bodyText1?.color
                             ),
                          ),
                          focusedBorder: border.copyWith( borderSide: BorderSide( color: Theme.of(context).accentColor)),
                          focusedErrorBorder: border.copyWith( borderSide: BorderSide( color: Theme.of(context).accentColor)),
                          hintText: widget.fieldStandart.hint,
                          labelText: widget.fieldStandart.label,
                          errorStyle: TextStyle(
                            color: Theme.of(context).errorColor
                          ),
                          errorBorder:  border.copyWith( borderSide: BorderSide( color: Colors.redAccent)),
                          suffixIcon: widget.fieldStandart.suffix,
                          focusColor: Colors.red,
                          hintStyle: TextStyle(
                            color:Colors.grey.shade500,
                          ),
                          labelStyle: TextStyle(
                            color: hasFocus? Theme.of(context).accentColor: Colors.grey.shade400,
                          ),
                        ),
                      ),
                   ),
                 ],
               ),
             )
           )
        ],
      ),
    );
  }
}