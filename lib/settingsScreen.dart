import 'package:flutter/material.dart';
import 'package:phone_validator/components/TextInputCustom.dart';
import 'package:phone_validator/models/settings.dart';
import 'package:phone_validator/models/sizing.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  late List<TextEditingController> controllers;
  bool isLoading = true;

  void init()async{
    var settings = await Settings.getInstance();
    controllers = [
      for(var field in Settings.credentials)
        TextEditingController(text: settings.getValueByKey(field.key))
    ];
    setState(() {
      isLoading = false;      
    });
  }
  void save()async{
    setState(() {
          isLoading = true;
    });
    for(var i=0;i<Settings.credentials.length;i++)
      await Settings.changeModel(key: Settings.credentials[i].key, value: controllers[i].text);
    setState(() {
      isLoading = false;      
    });
  }

  @override
  void initState() { 
    super.initState();
    init();
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
         shrinkWrap: isLoading,
         padding: EdgeInsets.all(
           10.font()
         ),
         children: [
           if(isLoading)
             Center(
               child: CircularProgressIndicator(),
             )
           else
             ...[
               for(int i=0;i<controllers.length;i++)
                TextInputCustom(
                  fieldStandart: Settings.credentials[i], 
                  controller: controllers[i]
                ),
               ElevatedButton(
                 onPressed:save, 
                 child: Text('Save')
               )
             ]
         ],
       ),
    );
  }
}