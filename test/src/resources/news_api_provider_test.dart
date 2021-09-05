import 'package:news/src/models/item_model.dart';
import 'package:news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test('fetchId return id list', () async {
    //setup of test case
    // final sum = 1 + 3;
    final newsApi = NewsApiProvider();
    MockClient((request) async {
      return Response(json.encode([1, 2, 3, 4]), 200);
    });

    final ids = await newsApi.fetchTopIds();

    // expectation
    // expect(sum, 4);
    expect(ids, [1, 2, 3, 4]);
  });
}
