import 'dart:async';
import 'dart:io';
import 'package:cruisedeals/deals/deals_page.dart';
import 'package:cruisedeals/login.dart';
import 'package:cruisedeals/models/userConfig.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Cruise Deals',
      theme: new ThemeData(
        primarySwatch: Colors.purple,
      ),
      //home: new MyHomePage(title: 'Flutter Demo Home Page'),
      home: new MyHomePage(),
      routes: <String,WidgetBuilder>{
        "/deals": (BuildContext context) => new DealsPage()
      }
    );
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key) {
  }

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  static final GlobalKey<DealsPageState> dealsKey = new GlobalKey<DealsPageState>();
  static final GlobalKey<LoginPageState> loginKey = new GlobalKey<LoginPageState>();

  UserConfig userConfig;

  @override
  void initState() {
    super.initState();
    _readUserConfig().then((UserConfig widget) {
      setState(() {
        print("widget: ${widget}");
        userConfig = widget;
      });
    });
  }
  Future<File> _getLocalFile() async {
    // get the path to the document directory.
    String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    return new File('$dir/widget.txt');
  }

  Future<UserConfig> _readUserConfig() async {
    try {
      File file = await _getLocalFile();
      String contents = await file.readAsString();
      return JSON.decode(contents,reviver: (k,v)=>k==null?new UserConfig.FromMap(v):v);
    } on FileSystemException {
      return new UserConfig();
    }
  }

  void updateConfig(UserConfig widget) {
    setState(() {
      print("Got new widget: ${widget}");
      userConfig = widget;
      _getLocalFile().then((f) => f.writeAsString(JSON.encode(widget)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      userConfig==null?
        new Container(
            decoration: new BoxDecoration(
                gradient: new RadialGradient(colors:[Colors.purple[800], Colors.black])
            ),
            alignment: FractionalOffset.center,
            child: new CircularProgressIndicator()
        ):
      userConfig.onBoarded?
        new DealsPage(key:dealsKey, userConfig:userConfig, changer: updateConfig)
          :new LoginPage(key:loginKey, userConfig:userConfig, onUpdateConfig: updateConfig);
  }
}
