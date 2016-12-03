import 'package:cruisedeals/markdown/markdown.dart';
import 'package:cruisedeals/models/deal.dart';
import 'package:flutter/material.dart';


class DealDetails extends StatelessWidget {
  DealDetails({Key key, Deal this.deal}) : super(key: key);

  final Deal deal;



  @override
  Widget build(BuildContext context) {


    return new Material(
        child: new Padding( padding: new EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0), child:
            new Markdown(data:deal.content)
        )
    );
  }
}

