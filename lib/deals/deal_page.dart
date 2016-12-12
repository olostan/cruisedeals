// Displays one Deal. Includes the Deal sheet with a background image.

import 'package:cruisedeals/deals/deal_details.dart';
import 'package:cruisedeals/models/deal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DealPage extends StatefulWidget {
  DealPage({ Key key, this.deal }) : super(key: key);

  final Deal deal;

  @override
  _DealPageState createState() => new _DealPageState();
}

class _DealPageState extends State<DealPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScrollableState> _scrollableKey = new GlobalKey<ScrollableState>();
  final TextStyle menuItemStyle = new TextStyle(fontSize: 15.0, color: Colors.black54, height: 24.0/15.0);
  final Object _disableHeroTransition = new Object();

  double _getAppBarHeight(BuildContext context) => MediaQuery.of(context).size.height * 0.3;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        scrollableKey: _scrollableKey,
        appBarBehavior: AppBarBehavior.scroll,
        appBar: new AppBar(
          heroTag: _disableHeroTransition,
          expandedHeight: _getAppBarHeight(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            new PopupMenuButton<String>(
                onSelected: (String item) {},
                itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  _buildMenuItem(Icons.share, 'Tweet Deal'),
                  _buildMenuItem(Icons.email, 'Email Deal'),
                  _buildMenuItem(Icons.message, 'Message Deal'),
                  _buildMenuItem(Icons.people, 'Share on Facebook'),
                ]
            )
          ],
          flexibleSpace: new FlexibleSpaceBar(
              background: new Stack( children: [
                new Image.network(config.deal.imagePath, fit:ImageFit.cover),
                new DecoratedBox(
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                          begin: const FractionalOffset(0.5, 0.0),
                          end: const FractionalOffset(0.5, 0.40),
                          colors: <Color>[const Color(0x60000000), const Color(0x00000000)]
                      )
                  )
              )])
          ),
        ),
        body: _buildContainer(context),
        floatingActionButton: new FloatingActionButton(
          tooltip: 'Call',
          child: new Icon(Icons.phone),
          onPressed: () {
            UrlLauncher.launch('tel:/0800-107-1590');
          },
        )
    );
  }

  // The full page content with the Deal's image behind it. This
  // adjusts based on the size of the screen. If the Deal sheet touches
  // the edge of the screen, use a slightly different layout.
  Widget _buildContainer(BuildContext context) {
    //final Size screenSize = MediaQuery.of(context).size;
    final double appBarHeight = _getAppBarHeight(context);
    const double fabHalfSize = 28.0;
    return new Stack(
        children: <Widget>[
          new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              height: appBarHeight + fabHalfSize,
              child: new Hero(
                  tag: config.deal.imagePath,
                  child: new Image.network(
                      config.deal.imagePath,
                      fit: ImageFit.fitWidth
                  )
              )
          ),
         /* new Positioned(
              top: 200.0,
              right: 20.0,
              child: new FloatingActionButton()
          ),*/
          new ClampOverscrolls(
              edge: ScrollableEdge.both,
              child: new ScrollableViewport(
                  scrollableKey: _scrollableKey,
                  child: new RepaintBoundary(
                      child: new Padding(
                          padding: new EdgeInsets.only(top: appBarHeight),
                          child: new DealDetails(deal: config.deal)
                      )
                  )
              )
          )
        ]
    );
  }

  PopupMenuItem<String> _buildMenuItem(IconData icon, String label) {
    return new PopupMenuItem<String>(
        child: new Row(
            children: <Widget>[
              new Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: new Icon(icon, color: Colors.black54)
              ),
              new Text(label, style: menuItemStyle)
            ]
        )
    );
  }


}