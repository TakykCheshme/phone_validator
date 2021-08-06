import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast_io.dart';

class PersistentStorage{


  static Future<Directory> get _directory => getApplicationDocumentsDirectory();
  static String? _dbPath;
  static const String _dbName = "persistent.db"; 
  static final PersistentStorage _instance = PersistentStorage._();
  static late Database _database;

  static Future<void> relaunchDataBase()async{
    if(_dbPath != null)
      await _database.close();
    await _init();
  }

  static Future<void> _init()async{
     var dir = await _directory;
      await dir.create(recursive: true);
      _dbPath = join(dir.path,_dbName);
      _database = await databaseFactoryIo.openDatabase(_dbPath!);
  }

  static Future<Map<String,dynamic>> _getNewMap()async{
    var store = StoreRef<String,dynamic>.main();
    var records = await store.find(_database);
    var recordsProcessed = Map.fromIterable(records,key: (element) => (element as RecordSnapshot<String,dynamic>).key, value: (element) => (element as RecordSnapshot<String,dynamic>).value);
    return recordsProcessed;
  }

  static Future<PersistentStorage> getInstance()async{
    if(_dbPath == null){
      await _init();
    }
    return _instance.._update(await _getNewMap());
  }

  Map<String, dynamic> _data = {};

  T? getItem<T>(String key){
    return _data[key];
  }

  Future<void> setItem<T>(String key, T value)async{
    var store = StoreRef<String,dynamic>.main();
    await store.record(key).put(_database, value);
    _update(await _getNewMap());
  }
 
  Future<void> remove(String key)async{
    var store = StoreRef<String,dynamic>.main();
    await store.record(key).delete(_database);
    return _update(await _getNewMap());
  } 

  void _update(Map _newData){
    _data = {..._data,..._newData};
  }

  PersistentStorage._();

}