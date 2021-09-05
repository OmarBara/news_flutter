import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/item_model.dart';
import 'dart:async';
import 'repository.dart';

final _root = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider implements Source {
  Client client = Client();

  Future<List<int>> fetchTopIds() async{
    final res = await client.get(Uri.parse('$_root/topstories.json'));
    final ids = json.decode(res.body);
      // convert or cast type to int
    return ids.Cast<int>();
  }

  Future<ItemModel> fetchItem(int id) async {
    final res = await client.get(Uri.parse('$_root/item/$id.json'));
    final parsedJson = json.decode(res.body);
    
    return ItemModel.formJson(parsedJson);
  }
}