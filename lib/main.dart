import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_validator/models/persistentStorage.dart';
import 'main_page/cubit/main_cubit.dart';
import 'main_page/main_page.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await PersistentStorage.getInstance();
  runApp(
    BlocProvider<MainCubit>(
      create: (context) => MainCubit()..init(prefs),
      child: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{

  void updateData()async{
    BlocProvider.of<MainCubit>(context, listen: false).init(await PersistentStorage.getInstance());
  }

  @override
    void didChangeAppLifecycleState(AppLifecycleState state) {
      super.didChangeAppLifecycleState(state);
      updateData();
    }

   @override
   void initState() {
     super.initState();
     WidgetsBinding.instance?.addObserver(this);
   }
   
   @override
   void dispose() {
     WidgetsBinding.instance?.removeObserver(this);
     super.dispose();
   }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Validator',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.amber,
        brightness: Brightness.dark,
      ),
      home: MainPage(),
    );
  }
}
