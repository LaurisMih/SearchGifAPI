import 'package:flutter_test/flutter_test.dart';
import 'package:gif_search_project/Pages/home_page.dart';
import 'package:http/http.dart' as http;

void main() {

  HomePageState state = HomePageState();
  String _key = 'SvWzp4qyn5UA9cYCpNF9tYbNyyHqA3Vl';// insert your key from home_page.dart file here
  int _offset = 0;
  int _limit = 20;

  var delay = Future.delayed(Duration(milliseconds: 300));

  test('If list is null then data.length should be null', () {
      //setup
      List<dynamic> data = <dynamic>[];
      //do
      state.GetCount(data);
      //test
      expect(data.length, 0);
    }
  );

  test('If list is not null then GetCount method should add one to list length', () {
      //setup   
      List<dynamic> data = <dynamic>[];
      data.add('some data');
      //do
      state.GetCount(data);
      //test
      expect(data.length, 1);
    }
  );

   test('If delay is 300 milliseconds then delay variable should be identical to delay variable', () {
      //setup   
      var delay300 = Future.delayed(Duration(milliseconds: 300));     
      //do
      state.GetGifs();
      //test
      identical(delay,delay300);
    }
  );

  test('If delay is 500 milliseconds then delay variable should not be identical to delay variable', () {
      //setup   
      var delay500 = Future.delayed(Duration(milliseconds: 500));     
      //do
      state.GetGifs();
      //test
      isNot(identical(delay,delay500));
    }
  );

  test('If search is null then response variable should be identical with responseWhenSearchIsNull variable', () async {
      //setup    
        String _search = '';
        http.Response response = await http.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/trending?api_key=$_key&$_limit&rating=G'));

         http.Response responseWhenSearchIsNull = await http.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/trending?api_key=$_key&$_limit&rating=G'));          
      //do
      state.GetGifs();
      //test
      identical(response,  responseWhenSearchIsNull);
    }
  );

  test('If search is not null then response variable should not be identical with responseWhenSearchNotNull variable', () async {
      //setup    
        String _search = 'cats';
        http.Response response = await http.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/trending?api_key=$_key&$_limit&rating=G'));

         http.Response responseWhenSearchIsNull = await http.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/search?api_key=$_key&q=$_search&$_limit&offset=$_offset&rating=G&lang=en'));          
      //do
      state.GetGifs();
      //test
      isNot(identical(response,  responseWhenSearchIsNull));
    }
  );
}