import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie app Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Movie App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController input_1 = TextEditingController();

  var output1 = "No Data";

  var poster =
      'https://d338t8kmirgyke.cloudfront.net/icons/icon_pngs/000/000/086/original/picture-multiple.png';
  var title;
  var released;
  var genre;
  var plot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                // ignore: prefer_const_constructors
                children: [
                  const Text("Simple Movie App",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: input_1,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Enter the Movie Name',
                        hintStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                  ElevatedButton(
                    onPressed: _loadMovie,
                    child: const Text("Search"),
                  ),
                  const SizedBox(height: 10),
                  Image.network(
                    poster,
                  ),
                  const SizedBox(height: 20),
                  Text(output1),
                ],
              ),
            ),
          ),
        ));
  }

  _loadMovie() async {
    String movieName = input_1.text;

    ProgressDialog progress = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Searching..."));
    progress.show();

    var apiid = "85807448";
    var url = Uri.parse(
        'http://www.omdbapi.com/?t=$movieName&apikey=$apiid&units=metric');

    var response = await http.get(url);
    var rescode = response.statusCode;

    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);

      title = parsedJson['Title'];
      released = parsedJson['Released'];
      genre = parsedJson['Genre'];
      poster = parsedJson['Poster'];
      plot = parsedJson['Plot'];
      var ratings_Source = parsedJson['Ratings'][0]['Source'];
      var ratings_Value = parsedJson['Ratings'][0]['Value'];
      setState(() {
        output1 =
            ' Title: $title.\n Released: $released\n Genre: $genre \n Rarings: $ratings_Source: $ratings_Value \n Story: $plot ';

        Fluttertoast.showToast(
            msg: "Movie Found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            fontSize: 16.0);
      });
      print(response.statusCode);

      progress.dismiss();
    } else {
      setState(() {
        output1 = "No response";
      });
    }
  }
}
