import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_validator/models/register_result.dart';
import 'package:phone_validator/settingsScreen.dart';
import 'package:wakelock/wakelock.dart';

import 'cubit/main_cubit.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    Wakelock.enable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Verifier'),
        actions: [
          IconButton(
            icon: Icon( Icons.settings, color: Colors.white, ),
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => SettingsScreen())
              );
            },
          )
        ],
      ),
      body: Container(child: BlocBuilder<MainCubit, List<RegisterResult>>(
        builder: (context, state) {

          var results = state.toList();

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final m = results[index].message;
              final success = results[index].success;
              return ListTile(
                title: Text((m.address) + ' - ' + (m.body)),
                subtitle: m.date != null
                    ? Text(DateTime.fromMillisecondsSinceEpoch(m.date!)
                        .toString()
                        .split('.')[0])
                    : Text('Näbelli'),
                trailing: Icon(
                  success ? Icons.check : Icons.close,
                  color: success ? Colors.green : Colors.red,
                ),
              );
            },
          );
        },
      )),
    );
  }
}
