import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:convert';
import 'User.dart';
import 'widget/Contact.dart';

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
  List userData;

  void _loadJson() async {
    rootBundle.loadString('assets/data/user.json').then((val) {
      Map user = json.decode(val);
      userData = user['data'];
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadJson();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(),
      body: new Center(
        child: new Container(
          child: new Contact(
            data: userData,
          ),
        ),
      ),
    );
  }
}
