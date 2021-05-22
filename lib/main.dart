import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_page/cubit/main_cubit.dart';
import 'main_page/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainCubit>(
      create: (context) => MainCubit(),
      child: MaterialApp(
        title: 'Phone Validator',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Colors.amber,
          brightness: Brightness.dark,
        ),
        home: MainPage(),
      ),
    );
  }
}
