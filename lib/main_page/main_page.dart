import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/main_cubit.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Validator'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.send),
        //     onPressed: () => context.read<MainCubit>().handleMessage(),
        //   )
        // ],
      ),
      body: Container(child: BlocBuilder<MainCubit, MainStateNormal>(
        builder: (context, state) {
          print(state);
          return ListView.builder(
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              final m = state.results[index].message;
              final success = state.results[index].success;
              return ListTile(
                title: Text((m.address ?? '') + ' - ' + (m.body ?? '')),
                subtitle: m.dateSent != null
                    ? Text(
                        DateTime.fromMillisecondsSinceEpoch(m.date!).toString())
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
