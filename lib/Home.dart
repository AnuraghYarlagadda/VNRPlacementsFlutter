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
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                GradientButton(
                  child: Text('Gradient'),
                  callback: () {
                    print("hi");
                  },
                  gradient: Gradients.blush,
                  shadowColor:
                      Gradients.backToFuture.colors.last.withOpacity(0),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                CircularGradientButton(
                  child: Icon(Icons.gradient),
                  callback: () {},
                  gradient: Gradients.rainbowBlue,
                  shadowColor: Gradients.rainbowBlue.colors.last.withOpacity(0),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                GradientText(
                  'Hello',
                  shaderRect: Rect.fromLTWH(0.0, 0.0, 50.0, 50.0),
                  gradient: Gradients.ali,
                  style: TextStyle(
                    fontSize: 40.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                cardx("Interview Details", "", Gradients.ali),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                cardx("Interview Questions", "", Gradients.blush),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                cardx("Interview Questions", "", Gradients.byDesign),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                cardx("Interview Questions", "", Gradients.taitanum),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                cardx("Interview Questions", "", Gradients.tameer),
                Padding(
                  padding: EdgeInsets.all(10),
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
