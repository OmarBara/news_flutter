import 'dart:async';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_model.dart';

class Repository {
  List<Source> sources = <Source>[
    // NewsDbProvider(),
    // call single instance of dbProvider because of multi DB connection to be single connection
    newsDbProvider,
    NewsApiProvider(),
  ];

  List<Cache> caches = <Cache>[
    // NewsDbProvider(),
    newsDbProvider,
  ];

  // iterate over sourcess when bdProvider get fetchTopIds
  Future<List<int>> fetchTopIds() {
    return sources[1].fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    Source source;

    // find the item match
    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }

    // add it to dbProvider "Caches"
    for (var cache in caches) {
      cache.addItem(item);
    }

    return item;
  }

// before add abstract class
// NewsDbProvider dbProvider = NewsDbProvider();
// NewsApiProvider apiProvider = NewsApiProvider();

// Future<List<int>> fetchTopIds() {
//   return apiProvider.fetchTopIds();
// }

// Future<ItemModel> fetchItem(int id) async {
//   var item = await dbProvider.fetchItem(id);
//   if (item != null) {
//     return item;
//   }
//
//   item = await apiProvider.fetchItem(id);
//   dbProvider.addItem(item);
//
//   return item;
// }
}

abstract class Source {
  Future<List<int>> fetchTopIds();

  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
}
