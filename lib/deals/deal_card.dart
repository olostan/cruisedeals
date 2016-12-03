
import 'package:cruisedeals/models/deal.dart';
import 'package:flutter/material.dart';

class DealCard extends StatelessWidget {
  final TextStyle titleStyle = const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600);
  final TextStyle authorStyle = const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54);

  DealCard({ Key key, this.deal, this.onTap }) : super(key: key);

  final Deal deal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: onTap,
        child: new Card(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //new SizedBox(height: 48.0, child:
                      new Text(deal.title,
                          overflow: TextOverflow.fade,
                          style: new TextStyle(
                              color: Colors.purple[500], fontWeight: FontWeight.bold,
                            fontSize: 20.0

                          )
                  //)
                  ),
                  new Expanded( child:
                  new Hero(
                      tag: deal.imagePath,
                      child:      new Image.network(deal.imagePath, fit: ImageFit.fill)
                          //)
                      )
                  ),
                  new SizedBox(height: 7.0),
                  new RaisedButton(onPressed: onTap,color: Colors.green[500],
                      child: new Text("View Deal", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0)))
                ]
            )
        )
    );
  }
}