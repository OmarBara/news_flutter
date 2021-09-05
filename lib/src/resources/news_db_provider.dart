import 'package:news/src/resources/repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:async';
import '../models/item_model.dart';
import 'repository.dart';

class NewsDbProvider implements Source, Cache {
  Database db;

  // constructor after making instance of NewsDbProvider to call init()
  NewsDbProvider() {
    init();
  }

  // Todo store and fetch top ids -- this fun will not be used
  Future<List<int>> fetchTopIds() {
    return null;
  }

  void init() async {
    //reference to directory inside the device
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'item.db');

    db = await openDatabase(path, version: 1,
        // called on the first time you run the app and if db does not exest
        onCreate: (Database newDb, int version) {
      newDb.execute("""
          CREATE TABLE Items
            (
              id  INTEGER PRIMARY KEY,
              type TEXT,
              time INTEGER,
              parent INTEGER,
              kids BLOB,
              dead  INTEGER,
              deleted INTEGER,
              url TEXT,
              score INTEGER,
              title TEXT,
              descendants INTEGER
            )
        """);
    });
  }

  Future<ItemModel> fetchItem(int id) async {
    // return "List<Maps<String, dynamic>>" list of Maps == Object in js
    final maps = await db.query(
      "Items",
      columns: null,
      // sanitize input to avoid sql injection
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return ItemModel.fromDb(maps.first);
    }
    return null;
  }

  Future<int> addItem(ItemModel item) {
    db.insert("Item", item.toMap());
  }
}

// create single instance of the dbProvider
final newsDbProvider = NewsDbProvider();
