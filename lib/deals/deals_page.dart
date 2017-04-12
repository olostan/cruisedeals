import 'dart:async';
import 'dart:convert' show JSON;
import 'dart:io';
import 'package:cruisedeals/deals/deal_card.dart';
import 'package:cruisedeals/deals/deal_page.dart';
import 'package:cruisedeals/deals/deals_logo.dart';
import 'package:cruisedeals/models/deal.dart';
import 'package:cruisedeals/models/userConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/http.dart' as http;
import 'package:flutter/services.dart';


//const double _kAppBarHeight = 128.0;
const double _kAppBarHeight = 128.0;

class DealsPage extends StatefulWidget {
  UserConfig userConfig;
  UserConfigChanger changer;

  DealsPage({Key key,this.userConfig, this.changer}) : super(key: key);

  @override
  DealsPageState createState() => new DealsPageState();
}

class DealsPageState extends State<DealsPage> {
  static final GlobalKey<ScrollableState> scrollableKey = new GlobalKey<ScrollableState>();

  @override
  initState() {
    super.initState();
    loadFromCache();
    reload();
  }

  Future<File> _getLocalFile() async {
    // get the path to the document directory.
    String dir = (await PathProvider.getTemporaryDirectory()).path;
    return new File('$dir/deals.json');
  }

  loadFromCache() async {
    print("Getting from cache");
    File file = await _getLocalFile();
    if (!(await file.exists())) return;
    var content = await file.readAsString();
    _setDealsFromString(content);
    print("Loaded from cache");
  }


  Future<Null> reload() async {
    print("Reloading...");
    setState(() { loading = true;});

    var content = await http
        .get('https://www.cruisedeals.co.uk/wp-json/wp/v2/posts/?_embed=featuredmedia&per_page=10');

    _setDealsFromString(content.body);
    File file = await _getLocalFile();
    await file.writeAsString(content.body);
    setState(() { loading = false;});
  }

  void _setDealsFromString(String s)  {
    var data = JSON.decode(s);
    var deals = data.map((d) => new Deal.fromMap(d)).toList(growable: false);
    setState(() {
      this.deals = deals;
    });
  }

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Deal> deals = [];
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return new Scaffold(
        key: scaffoldKey,
        scrollableKey: scrollableKey,
        backgroundColor: Colors.grey[300],
        appBarBehavior: AppBarBehavior.under,
        appBar: buildAppBar(context, statusBarHeight),
        /*floatingActionButton: new FloatingActionButton(
                child: new Icon(Icons.edit),
                onPressed: () {
                  scaffoldKey.currentState.showSnackBar(new SnackBar(
                      content: new Text('Not supported.')
                  ));
                }
            ),*/
        body: buildBody(context, statusBarHeight));
  }

  Widget buildAppBar(BuildContext context, double statusBarHeight) {
    return new AppBar(
        leading: new Container(),
        expandedHeight: _kAppBarHeight,
        /*actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () {
                scaffoldKey.currentState.showSnackBar(new SnackBar(
                    content: new Text('Not supported.')
                ));
              }
          )
        ],*/
        bottom: loading ? new MyLinearProgressIndicator() : null,
        flexibleSpace: new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          final Size size = constraints.biggest;
          final double appBarHeight = size.height - statusBarHeight;
          final double t = (appBarHeight - kToolbarHeight) /
              (_kAppBarHeight - kToolbarHeight);
          final double extraPadding =
              new Tween<double>(begin: 5.0, end: 14.0).lerp(t);
          //final double logoHeight = appBarHeight - 1.5 * extraPadding;
          return new Padding(
              padding: new EdgeInsets.only(
                  top: statusBarHeight + 0.5 * extraPadding,
                  bottom: extraPadding),
              child: new DealsLogo(height: appBarHeight, t: t.clamp(0.0, 1.0),
                onSettings: () {
                      widget.changer(widget.userConfig..onBoarded = false);
                    }
                ));
        }));
  }


  Widget buildBody(BuildContext context, double statusBarHeight) {
    final EdgeInsets padding = new EdgeInsets.fromLTRB(
        8.0, 8.0 + _kAppBarHeight + statusBarHeight, 8.0, 8.0);
    print("Sc key ${scrollableKey}");
    return new RefreshIndicator(
        refresh: reload,
        scrollableKey: scrollableKey,
      displacement: 160.0,
        location: RefreshIndicatorLocation.both,
        child:
      new ScrollableGrid(
          scrollableKey: scrollableKey,
          delegate: new MaxTileWidthGridDelegate(
              tileAspectRatio: 1.3,
              rowSpacing: 8.0,
              columnSpacing: 8.0,
              padding: padding,
              maxTileWidth: 600.0),
          children: deals.map((Deal deal) {
            return new DealCard(
                deal: deal,
                onTap: () {
                  showDealPage(context, deal);
                });
          })),
    );
  }

  void showDealPage(BuildContext context, Deal deal) {
    Navigator.push(
        context,
        new MaterialPageRoute<Null>(
            settings: const RouteSettings(name: "/deal"),
            builder: (BuildContext context) {
              return new DealPage(deal: deal);
            }));
  }
}

class MyLinearProgressIndicator extends LinearProgressIndicator
    implements AppBarBottomWidget {
  @override
  double get bottomHeight => 70.0;
}

/*
const List<Deal> sampleDeals = const [
  const Deal(imagePath:'assets/deals/1.jpg', title: "5-night Queen Victoria Big Band Ball cruise sailing from Southampton with Cunard from only £439pp"),
  const Deal(imagePath:'assets/deals/2.jpg', title:"a")
];
*/
