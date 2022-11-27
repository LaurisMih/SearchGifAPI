import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'gif_page.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String _key = 'SvWzp4qyn5UA9cYCpNF9tYbNyyHqA3Vl'; //insert your key here
  String _search = '';
  int _offset = 0;
  int _limit = 20;
  int GetCount(List data) {
    if (_search == null || _search.isEmpty) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Future<Map> GetGifs() async {
    http.Response response;
    await Future.delayed(Duration(milliseconds: 300));
    if (_search == null) {
      response = await http.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/trending?api_key=$_key&$_limit&rating=G'));
    } else {
      response = await http.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/search?api_key=$_key&q=$_search&$_limit&offset=$_offset&rating=G&lang=en'));
    }
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Search gifs app',
          )),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 3.0),
                ),
                labelText: 'Search here!',
                labelStyle: TextStyle(color: Colors.black),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 20.0),
              textAlign: TextAlign.center,
              onSubmitted: (submittedText) {
                setState(() {
                  _search = submittedText;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: GetGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      child: const SizedBox(
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                          ),
                        ),
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return CreateGifTable(context, snapshot);
                    }
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget CreateGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      itemCount: GetCount(snapshot.data['data']),
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data['data'].length) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data['data'][index]['images']['fixed_height']
                  ['url'],
              height: 300.0,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GifPage(snapshot.data['data'][index])));
            },
            onLongPress: () {
              Share.share(snapshot.data['data'][index]['images']['fixed_height']
                  ['url']);
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              child: Column(
                children: const <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70.0,
                  ),
                  Text(
                    'Load more...',
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  )
                ],
              ),
              onTap: () {
                setState(
                  () {
                    _offset += 19;
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}
