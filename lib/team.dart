import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Team extends StatefulWidget {
  @override
  TeamState createState() => TeamState();
}

class TeamState extends State<Team> {
  static List<int> indices = [0, 1, 2, 3, 4, 5];
  static List<String> images = [
    "images/anuragh.JPG",
    "images/anuragh.JPG",
    "images/anuragh.JPG",
    "images/anuragh.JPG",
    "images/anuragh.JPG",
    "images/anuragh.JPG",
  ];
  static List<String> names = [
    "BVK Mam",
    "RK Sir",
    "Bharath Sir",
    "Yamini",
    "Harini",
    "Anuragh"
  ];
  static List<String> designation = [
    "HOD",
    "Placement Cordinator",
    "Placement Cordinator",
    "Student",
    "Student",
    "Student"
  ];
  final List<Widget> imageSliders = indices
      .map((item) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image.asset(images[item]),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  names[item],
                  style: TextStyle(
                    fontSize: 25,
                      color:Colors.indigo,fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                ),
                Text(designation[item],
                style: TextStyle(
                      fontWeight: FontWeight.w600,))
              ]))
      .toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return (SizedBox(child: imageSliders[index]));
              },
              itemCount: images.length,

              viewportFraction: 0.8,
              scale: 0.8,
              //indicatorLayout: PageIndicatorLayout.COLOR,
              pagination: new SwiperPagination(
                  builder: new DotSwiperPaginationBuilder(
                      color: Colors.grey,
                      activeSize: 11,
                      size: 8,
                      activeColor: Colors.blue[900])),
              //control: new SwiperControl(color: Colors.white),
              scrollDirection: Axis.horizontal,
            )));
  }
}
