import 'package:cruisedeals/models/userConfig.dart';
import 'package:flutter/material.dart';

typedef UserConfig ConfigChanger(UserConfig widget);

class _CheckableItem extends StatefulWidget {
  _CheckableItem({Key key, this.initialValue, this.onChanged, this.child})
      : super(key: key);

  final bool initialValue;
  final ValueChanged<bool> onChanged;
  final Widget child;

  @override
  State<StatefulWidget> createState() => new _CheckableItemState(initialValue);
}



class _CheckableItemState<T> extends State<_CheckableItem> {
  _CheckableItemState(this.value): super();
  bool value;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
        onTap: () {
          setState(() => value = !value);
          this.widget.onChanged(value);
        },
        child: new Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Icon(value?Icons.check_circle:Icons.check_circle_outline, size: 36.0, color: Colors.black),
                  new Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: widget.child
                  )
                ]
            )
        )
    );
  }
}


class _CruiseLineItem extends StatelessWidget {
  _CruiseLineItem({Key key, CruiseLine this.line, this.initialValue, this.onChanged})
      : super(key: key);

  final CruiseLine line;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return new _CheckableItem(
        initialValue: initialValue,
        onChanged: onChanged,
        child: new Center( child: new Image.asset("assets/lines/${line.icon}",height: 35.0))
    );
  }

}

class _TextCheckableItem extends StatelessWidget {
  _TextCheckableItem({Key key, this.text, this.initialValue, this.onChanged})
      : super(key: key);

  final String text;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return new _CheckableItem(
        initialValue: initialValue,
        onChanged: onChanged,
        child: new Text(text)
    );
  }

}



class LoginPage extends StatefulWidget {
  UserConfigChanger onUpdateConfig;
  UserConfig userConfig;

  LoginPage({Key key, UserConfigChanger this.onUpdateConfig, this.userConfig}) : super(key: key);

  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  int get step => widget.userConfig==null||widget.userConfig.email==null?0:1;

  Set<String> lines = new Set<String>();
  Set<String> destinations = new Set<String>();
  Set<String> times = new Set<String>();

  @override
  void initState() {
    super.initState();
    lines = new Set.from(widget.userConfig.lines??[]);
    destinations = new Set.from(widget.userConfig.destinations??[]);
    times = new Set.from(widget.userConfig.times??[]);
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
        child: new DefaultTextStyle(
            style: new TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
            child: new Container(
                padding: new EdgeInsets.all(20.0),
                decoration: new BoxDecoration(
                    backgroundColor: new Color.fromARGB(255, 159, 37, 140)),
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  new Padding(
                      padding: new EdgeInsets.symmetric(horizontal: 10.0),
                      child: new Image.asset("assets/header-logo-2016.png",
                          fit: ImageFit.fitWidth)),
                  new Text("Step ${step+1} of 2", style: new TextStyle(fontSize:18.0), textAlign: TextAlign.center),
                  new Text(step==0?"Introduce Yourself":"Your Cruise Preferences", textAlign: TextAlign.center),
                  step==0?_buildIntroduce():_buildPreferences(),
                  step==0?new RaisedButton(
                      child: new Text("Skip this step"), onPressed: ()  {
                    setState(() {
                      var userConfig = new UserConfig.Anonymous();
                      this.widget.onUpdateConfig(userConfig);
                      } );
                  }):new RaisedButton(
                      color: new Color(0xff8dbd35),
                      child: new Text("Take me to the Deals!", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0)),
                      onPressed: _configUpdater(
                        (cfg) => cfg..onBoarded=true
                      ))
                ]))));
  }
  void _updateConfig(ConfigChanger changer) {
    print("Preparing to updae");
     setState(()  {
       print("updating change");

       widget.userConfig = changer(widget.userConfig);
       this.widget.onUpdateConfig(widget.userConfig);
    });
  }
  VoidCallback _configUpdater(ConfigChanger changer) {
    return () => _updateConfig(changer);
  }
  UserConfig _updateState(UserConfig cfg) {
    setState(() {
      widget.userConfig = cfg;
    });
    return cfg;
  }

/*  void _openDeals(BuildContext context) {
    Navigator.popAndPushNamed(context,"/deals");
    /*Navigator.popAndPushNamed(context, new MaterialPageRoute<Null>(
        settings: const RouteSettings(name: "/deals"),
        builder: (BuildContext context) {
          return new DealsPage();
        }
    ));*/
  }*/

  Widget _buildLoginWidget(Color color) {
    return new SizedBox(
        width: 64.0,
        height: 64.0,
        child: new Padding(padding: new EdgeInsets.all(7.0), child:new DecoratedBox(
            decoration: new BoxDecoration(
                backgroundColor: color))));
  }
  Widget _buildIntroduce() {
    return  new Expanded(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Text(
                  "Tap one of the below buttons to sign with an account.",
                  textAlign: TextAlign.center),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLoginWidget(new Color.fromARGB(255,44,60,142)),
                    _buildLoginWidget(new Color.fromARGB(255,34,119,186)),
                    _buildLoginWidget(new Color.fromARGB(255,50,171,223)),
                    _buildLoginWidget(new Color.fromARGB(255,188,33,49)),
                  ])
            ]));
  }
  Widget _buildPreferences() {
    return new Expanded(
        child: new DefaultTextStyle(
            style: new TextStyle(fontSize: 16.0),
            child:
        new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              new SizedBox(height: 20.0),
              new Text("Your favourite cruise lines:",textAlign: TextAlign.center),
              new RaisedButton(child: _GetTextForBox(lines, CruiseLines),onPressed: () {
                showDialog(context:context,child:_cruiseLinesDialog());
              }),
              new SizedBox(height: 20.0),
              new Text("Destinations you want to visit:",textAlign: TextAlign.center),
              new RaisedButton(child: _GetTextForBox(destinations, Destinations),onPressed: () {
                showDialog(context:context,child:_cruiseDestinationsDialog());
              }),
              new SizedBox(height: 20.0),
              new Text("Times of the year you’d like to cruise:",textAlign: TextAlign.center),
              new RaisedButton(child: _GetTextForBox(times, TimesOfYear),onPressed: () {
                showDialog(context:context,child:_TimesDialog());
              }),
              new SizedBox(height: 20.0),
              new Text("Length of time you’d like to cruise for:",textAlign: TextAlign.center),
              new RaisedButton(child: new Text(_GetTextForLength()),onPressed: () {
                showDialog(context:context,child:new _LengthDialog(userConfig: widget.userConfig, changer: _updateState));

              }),
            ])));
  }
  String _GetTextForLength() {
    if (widget.userConfig==null) return "Click here to select";
    if (widget.userConfig.lengthMin == widget.userConfig.lengthMax) return "Exactly ${widget.userConfig.lengthMin} days";
    return "Approximately ${widget.userConfig.lengthMin}-${widget.userConfig.lengthMax} days";
  }
  Widget _GetTextForBox(Set<String> values, List<KeyName> dic) {
    if (values.length ==0) return new Text("Click here ot select");
    var names = values.map((v) => dic.firstWhere((e)=>e.key==v).name);
    if (names.length<=2) return new Text(names.join(", "));
    else return new Text("${names.take(2).join(", ")} and ${names.length-2} more");
  }

  Widget _cruiseLinesDialog() {
    return new SimpleDialog(
        title: new Text('Select Cruise Lines'),
        children: <Widget>[]..addAll(CruiseLines.map((line) => new _CruiseLineItem(
            line: line,
            onChanged: (value) {
              setState(() {
                if (value) lines.add(line.key);
                else lines.remove(line.key);
              });
            },
            initialValue: lines.contains(line.key)
        )).toList(growable: false))..add(
          new RaisedButton(
              color: new Color(0xfff8ae4c),
              child: new Text("Confirm Selection", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: ()  {
                  setState(() {
                    widget.onUpdateConfig(widget.userConfig..lines = lines.toList(growable: false));
                  });
                  Navigator.pop(context);
              }
          ))
    );
  }

  Widget _KeyNameRow(KeyName item, Set<String> values) {
    return new _TextCheckableItem(text: item.name,initialValue: values.contains(item.key),onChanged: (value) {
      setState( () {
        if (value)
          values.add(item.key);
        else
          values.remove(item.key);
      });
    });

  }
  Widget _cruiseDestinationsDialog() {
    return new SimpleDialog(
        title: new Text('Select Destinations'),
        children: (Destinations.map((d) => _KeyNameRow(d,destinations)).toList(growable: true))..add(
          new RaisedButton(
              color: new Color(0xfff8ae4c),
              child: new Text("Confirm Selection", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: ()  {
                setState(() {
                  widget.onUpdateConfig(widget.userConfig..destinations = destinations.toList(growable: false));
                });
                Navigator.pop(context);
              }
          )
        )
    );
  }
  Widget _TimesDialog() {
    return new SimpleDialog(
        title: new Text('Select Times of the year'),
        children: (TimesOfYear.map((t) => _KeyNameRow(t,times)).toList(growable: true))..add(
            new RaisedButton(
                color: new Color(0xfff8ae4c),
                child: new Text("Confirm Selection", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: ()  {
                  setState(() {
                    widget.onUpdateConfig(widget.userConfig..times= times.toList(growable: false));
                  });
                  Navigator.pop(context);
                }
            )
        )
    );
  }
  Widget _LengthDialogOld() {
    return new SimpleDialog(
        title: new Text('Select Times of the year'),
        children: [
            new Text("Minimal number of days:"),
            //new Slider(value: widget.userConfig.lengthMin.toDouble(), onChanged: (nv) => _configUpdater( (cfg) => cfg..lengthMin=nv.toInt()), max: 10.0),
            new Slider(value: widget.userConfig.lengthMin.toDouble(), onChanged: (nv) {
              print("Changed to ${nv}");
              _updateConfig( (cfg) => cfg..lengthMin = nv.toInt());

            }, max: 10.0),
            new Text("Maximum number of days:"),
            new Slider(value: widget.userConfig.lengthMax.toDouble(), onChanged: (nv) => _configUpdater( (cfg) => cfg..lengthMax=nv.toInt()), max: 20.0),

            new RaisedButton(
                color: new Color(0xfff8ae4c),
                child: new Text("Confirm Selection", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed:  ()  {
                  Navigator.pop(context);
                }
            )
        ]

    );
  }

}

class _LengthDialog extends StatefulWidget {

  UserConfig userConfig;
  ConfigChanger changer;
  _LengthDialog({Key key, this.userConfig, this.changer}): super(key:key);

  @override
  State<StatefulWidget> createState() {
    return new _LengthDialogState();
  }
}

typedef _valueConfigChanger(UserConfig state, int newValue);

class _LengthDialogState extends State<_LengthDialog> {

  _valueUpdater(_valueConfigChanger vcb) {
    return (double nv) {
    setState( () {
      this.widget.userConfig = this.widget.changer(vcb(this.widget.userConfig,nv.toInt()));
    });
    };
  }

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
        title: new Text('Select Times of the year:'),
        children: [
          new Text("Minimal stay - ${widget.userConfig.lengthMin} days.", textAlign: TextAlign.center),
          new Slider(value: widget.userConfig.lengthMin.toDouble(), onChanged: _valueUpdater((cfg, nv) => cfg..lengthMin=nv), min: 1.0, max: widget.userConfig.lengthMax.toDouble(), label: "${this.widget.userConfig.lengthMin.toInt()}"),
          new Text("Maximum stay  - ${widget.userConfig.lengthMax} days.", textAlign: TextAlign.center),
          new Slider(value: widget.userConfig.lengthMax.toDouble(), onChanged: _valueUpdater((cfg, nv) => cfg..lengthMax=nv), min: widget.userConfig.lengthMin.toDouble(),max:30.0, label: "${this.widget.userConfig.lengthMax.toInt()}"),

          new RaisedButton(
              color: new Color(0xfff8ae4c),
              child: new Text("Confirm Selection", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed:  ()  {
                Navigator.pop(context);
              }
          )
        ]

    );
  }
}
