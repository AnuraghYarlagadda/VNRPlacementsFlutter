import 'package:flutter/material.dart';
import 'cardx.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(),
        body: Container(
            decoration: new BoxDecoration(gradient: Gradients.haze),
            child: Center(
                child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: <Widget>[
                GradientText(
                  'Hello',
                  shaderRect: Rect.fromLTWH(0.0, 0.0, 50.0, 50.0),
                  gradient: Gradients.ali,
                  style: TextStyle(
                    fontSize: 40.0,
                  ),
                ),
              ]),
            ))));
  }
}

// bottomNavigationBar: Container(
//           padding: EdgeInsets.only(left: 4.0, right: 4.0),
//           height: 44.0 + MediaQuery.of(context).padding.bottom,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               IconButton(icon: Icon(Icons.star)),
//               IconButton(icon: Icon(Icons.star)),
//             ],
//           ),
