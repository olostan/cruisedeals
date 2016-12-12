import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class DealsLogo extends StatefulWidget {
  DealsLogo({this.height, this.t, this.onSettings});

  final double height;
  final double t;
  final VoidCallback onSettings;

  @override
  _DealsLogoState createState() => new _DealsLogoState();
}


class _DealsLogoState extends State<DealsLogo> {
  // Native sizes for logo and its image/text components.
  static const double kLogoHeight = 108.0;
  static const double kLogoWidth = 220.0;
  static const double kImageHeight = 108.0;
  static const double kTextHeight = 48.0;
  final TextStyle titleStyle = const TextStyle(fontSize: kTextHeight, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3.0);
  final TextStyle openingStyle = const TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 11.0);

  final RectTween _textRectTween = new RectTween(
      begin: new Rect.fromLTWH(0.0, kLogoHeight,  kLogoWidth, kTextHeight),
      end:   new Rect.fromLTWH(0.0, kImageHeight, kLogoWidth, kTextHeight)
  );
  final Curve _textOpacity = const Interval(0.4, 1.0, curve: Curves.easeInOut);
  final Curve _upPosition = const Interval(0.0, 1.0, curve: Curves.easeInOut);

  final RectTween _imageRectTween = new RectTween(
      begin: new Rect.fromLTWH(0.0, 0.0, kLogoWidth, kLogoHeight),
      end: new Rect.fromLTWH(0.0, 0.0, kLogoWidth, kImageHeight)
  );
  final RectTween _rightRectTween = new RectTween(
      begin: new Rect.fromLTWH(0.0, 0.0, kLogoWidth, kLogoHeight),
      end: new Rect.fromLTWH(0.0, 0.0, kLogoWidth, kImageHeight)
  );

  /*@override
  Widget build(BuildContext context) {
    return new Transform(
        transform: new Matrix4.identity()..scale(config.t.clamp(0.3,1)),
        alignment: FractionalOffset.topCenter,
        child:
            //new SizedBox(
            //width: kLogoWidth,
            //child:
            //new SizedBox.expand( child: new DecoratedBox(decoration: new BoxDecoration(backgroundColor: Colors.red[200])))

            new Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  new Positioned.fromRect(
                      rect: _imageRectTween.lerp(config.t),
                      child: new Image.asset("assets/header-logo-2016.png", fit: ImageFit.contain)
                  ),
                  new Align(alignment: FractionalOffset.topRight,
                      child: new Text("Opening hours is from", style:new TextStyle(fontSize: 18.0, color: Colors.white))
                  ),
                  new Positioned.fromRect(
                      rect: _textRectTween.lerp(config.t),
                      child: new Opacity(
                        opacity: _textOpacity.transform(config.t),
                        child: new Text('Call our cruise experts today!', style: titleStyle, textAlign: TextAlign.center),
                      )
                  )
                ]
           // )
            )

    );
  }*/
  Widget build(BuildContext context) {

    return new Stack(
        children: [
          new Positioned(left:0.0, top:0.0,
              child: new Align(
                  alignment: FractionalOffset.topLeft,
                  child:new SizedBox(height: 50.0,child:  new Image.asset("assets/header-logo-2016.png", fit: ImageFit.fill)))
          ),
          new Positioned(left:0.0, top:55.0-_upPosition.transform(1-config.t)*55,right: 0.0,
            child: new Opacity(opacity: _textOpacity.transform(config.t),child:
            new Text("Call our cruise experts today!", style: new TextStyle(color: Colors.white, fontSize: 18.0),textAlign: TextAlign.center)
          )),
          new Positioned(left:0.0, top:75.0-_upPosition.transform(1-config.t)*55,right: 0.0,
              child: new Opacity(opacity: _textOpacity.transform(config.t),child:
                  new GestureDetector(
                    onTap: () {
                      UrlLauncher.launch("tel:/0800-107-1590");
                    },
                    child:new Text("✆ 0800 107 1590", style: new TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 28.0),textAlign: TextAlign.center))
          )),
          new Positioned(right: 10.0, top:75.0-_upPosition.transform(1-config.t)*55,
              child: new Opacity(opacity: _textOpacity.transform(config.t),child:
                  new InkWell(
                      onTap: config.onSettings,
                      child:
                new Icon(Icons.settings, color: Colors.white))
              )
          ),
          new Positioned(right: 10.0, child:
              new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    new Text("Opening hours:", style: openingStyle ),
                    new Text("Mon - Thu 09.00 - 21.30", style: openingStyle),
                    new Text("Fri - Sat 09.00 - 20.00", style: openingStyle),
                    new Text("Sun 09.30 - 19.30", style: openingStyle),
              ])
          )

        ]
    );
  }

}