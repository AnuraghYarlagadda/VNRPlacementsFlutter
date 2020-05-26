import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:vnrplacements/appDecription.dart';

class AppTour extends StatefulWidget {
  @override
  AppTourState createState() => AppTourState();
}

class AppTourState extends State<AppTour> {
  List<String> images = [
    "images/one.jpeg",
    "images/two.jpeg",
    "images/three.jpeg",
    "images/four.jpeg",
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    Widget cancelButton = FlatButton(
      child: Text(
        "YES",
        style: TextStyle(
            color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.of(context).pop(true);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "NO",
        style: TextStyle(
            color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Do you really want to Exit❓'),
        actions: [
          cancelButton,
          continueButton,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
            appBar: AppBar(
              title: Text("App Tour"),
            ),
            body: OfflineBuilder(
                connectivityBuilder: (
                  BuildContext context,
                  ConnectivityResult connectivity,
                  Widget child,
                ) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      child,
                      Positioned(
                        height: MediaQuery.of(context).size.height / 15,
                        left: 0.0,
                        right: 0.0,
                        child: Row(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.fromLTRB(0, 100, 0, 0)),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: RaisedButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacementNamed("appDescription");
                                    },
                                    color: Colors.yellow[700],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                          topRight: Radius.circular(5),
                                          topLeft: Radius.circular(5)),
                                    ),
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(children: <Widget>[
                                          TyperAnimatedTextKit(
                                            text: [
                                              " S K I P ",
                                            ],
                                            textStyle: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.start,
                                            // speed: Duration(milliseconds: 100),
                                          ),
                                          Icon(
                                            Icons.skip_next,
                                            size: 30,
                                          )
                                        ]))))
                          ],
                        ),
                      ),
                    ],
                  );
                },
                child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    Padding(padding: EdgeInsets.all(25)),
                    SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return new Image.asset(
                              images[index],
                              fit: BoxFit.fill,
                            );
                          },
                          indicatorLayout: PageIndicatorLayout.COLOR,
                          itemCount: images.length,
                          pagination: new SwiperPagination(
                              builder: new FractionPaginationBuilder(
                            color: Colors.black,
                            activeColor: Colors.indigo,
                          )),
                          control: new SwiperControl(
                              iconPrevious: Icons.arrow_back,
                              iconNext: Icons.arrow_forward,
                              color: Colors.black),
                        )),
                  ]),
                ))));
  }
}
