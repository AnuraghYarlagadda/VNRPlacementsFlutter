import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vnrplacements/Introslider/intro_slider.dart';
import 'package:vnrplacements/Introslider/slide_object.dart';

class AppTour extends StatefulWidget {
  @override
  AppTourState createState() => AppTourState();
}

class AppTourState extends State<AppTour> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "PERMISSIONS",
        styleTitle: GoogleFonts.lato(
          textStyle: TextStyle(
              letterSpacing: 2.5,
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.w800),
        ),
        description:
            "Tap on Allow!\nApplication tries to save files in 'Internal Storage' under folder 'Placements'!",
        styleDescription: GoogleFonts.patrickHand(
            textStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
        )),
        pathImage: "images/b.jpg",
        backgroundColor: Colors.teal,
      ),
    );
    slides.add(
      new Slide(
        title: "TOUR AGAIN",
        styleTitle: GoogleFonts.lato(
          textStyle: TextStyle(
              letterSpacing: 2.5,
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.w800),
        ),
        description: "Tap on 'INFO' icon highlighted to view 'APP TOUR' again!",
        styleDescription: GoogleFonts.patrickHand(
            textStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
        )),
        pathImage: "images/a.jpg",
        widthImage: 125,
        heightImage: 150,
        backgroundColor: Colors.teal,
      ),
    );
    slides.add(
      new Slide(
        title: "CATEGORY",
        styleTitle: GoogleFonts.lato(
          textStyle: TextStyle(
              letterSpacing: 2.5,
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.w800),
        ),
        description:
            "Selecting a category from the dropdown displays List of Companies under that!",
        styleDescription: GoogleFonts.patrickHand(
            textStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
        )),
        pathImage: "images/c.jpg",
        widthImage: 150,
        heightImage: 150,
        backgroundColor: Colors.teal,
      ),
    );
    slides.add(
      new Slide(
        title: "COMPANY DETAILS",
        styleTitle: GoogleFonts.lato(
          textStyle: TextStyle(
              letterSpacing: 2.5,
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.w800),
        ),
        description: "Tap on a Company to view details!",
        styleDescription: GoogleFonts.patrickHand(
            textStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
        )),
        pathImage: "images/d.jpg",
        backgroundColor: Colors.teal,
      ),
    );
    slides.add(
      new Slide(
        title: "FILES",
        styleTitle: GoogleFonts.lato(
          textStyle: TextStyle(
              letterSpacing: 2.5,
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.w800),
        ),
        description:
            "Download and Open the file or Click on WEBVIEW to view directly in the browser!",
        styleDescription: GoogleFonts.patrickHand(
            textStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
        )),
        pathImage: "images/e.jpg",
        widthImage: 125,
        heightImage: 125,
        backgroundColor: Colors.teal,
      ),
    );
  }

  void onDonePress() {
    Navigator.of(context).pushReplacementNamed("appDescription");
  }

  void onSkipPress() {
    Navigator.of(context).pushReplacementNamed("appDescription");
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
        child: new IntroSlider(
          slides: this.slides,
          onDonePress: this.onDonePress,
          onSkipPress: this.onSkipPress,
        ));
  }
}
