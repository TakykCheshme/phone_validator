import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      ),
      body: Container(child: BlocBuilder<MainCubit, MainStateNormal>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              final m = state.results[index].message;
              final success = state.results[index].success;
              return ListTile(
                title: Text((m.address ?? '') + ' - ' + (m.body ?? '')),
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
