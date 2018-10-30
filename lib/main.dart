import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:convert';
import 'User.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new _MyAppWidget(),
    );
  }
}

class _MyAppWidget extends StatefulWidget {
  @override
  State createState() {
    return new _MyAppState();
  }
}

class _MyAppState extends State<_MyAppWidget> {
  String jsonStr;
  var userData;

  void _loadJson() async {
    rootBundle.loadString('assets/data/user.json').then((val) {
      var user = json.decode(val);
      setState(() {
        userData = user['data'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(),
      body: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new IconButton(
              icon: new Icon(Icons.refresh),
              onPressed: () {
                _loadJson();
                if (jsonStr != null) {
                  var user = json.decode(jsonStr);
                  print(user['data']);
                }
              },
            ),
            new Expanded(
              child: userData == null
                  ? new Text("$jsonStr")
                  : new ListView.builder(
                      itemBuilder: (context, index) {
                        return new Column(
                          children: <Widget>[
                            new ListTile(
                              title: new Text('${userData[index]['title']}'),
                            ),
                          ],
                        );
                      },
                      itemCount: userData.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
