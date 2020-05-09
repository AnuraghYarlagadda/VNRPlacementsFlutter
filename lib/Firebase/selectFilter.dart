import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:vnrplacements/Firebase/displayFilteredCompanies.dart';
import 'package:vnrplacements/FirebaseSignInAnonymous.dart';
import 'package:vnrplacements/StoragePermissions.dart';
import 'package:vnrplacements/card.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';

class Filter extends StatefulWidget {
  @override
  FilterState createState() => FilterState();
}

class FilterState extends State<Filter> {
  String filter = '   Tap here  to select a category';
  List cards = new List<card>();
  List<String> spinnerItems = [
    "   Tap here  to select a category",
    "Core",
    "Software and Service",
    "Software and Product"
  ];
  double width, height;
  @override
  void initState() {
    super.initState();
    firebaseSignIn();
    grantStoragePermissionAndCreateDir(context);
    this.cards.add(new card("Alumni Details", "", Colors.purple));
    this.cards.add(new card("List Of Companies", "", Colors.orange[900]));
    this
        .cards
        .add(new card("Requirements and Sample Resume", "", Colors.indigo));
  }

  @override
  Widget build(BuildContext context) {
    this.height = MediaQuery.of(context).size.height;
    this.width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          decoration: new BoxDecoration(gradient: Gradients.coldLinear),
          child: OfflineBuilder(
              connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
              ) {
                final bool connected = connectivity != ConnectivityResult.none;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    child,
                    Positioned(
                      height: 20.0,
                      left: 0.0,
                      right: 0.0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        color: connected ? Colors.transparent : Colors.red,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: connected
                              ? Text(
                                  '',
                                  style: TextStyle(color: Colors.white),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Offline',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(width: 8.0),
                                    SizedBox(
                                      width: 12.0,
                                      height: 12.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: <Widget>[
                    SizedBox(height: this.height / 10),
                    spinner(),
                    SizedBox(height: this.height / 10),
                    cards.length == 0
                        ? CircularProgressIndicator()
                        : SizedBox(
                            height: this.height / 3,
                            child: Swiper(
                              itemBuilder: (BuildContext context, int index) {
                                return (SizedBox(child: cards[index]));
                              },
                              itemCount: cards.length,
                              itemWidth: this.width - 60,
                              itemHeight: 135,
                              layout: SwiperLayout.STACK,
                              indicatorLayout: PageIndicatorLayout.COLOR,
                              pagination: new SwiperPagination(
                                  builder: new DotSwiperPaginationBuilder(
                                      color: Colors.white,
                                      activeSize: 11,
                                      size: 8,
                                      activeColor: Colors.blue[900])),
                              control: new SwiperControl(color: Colors.white),
                              scrollDirection: Axis.horizontal,
                            )),
                  ])))),
    );
  }

  Widget spinner() {
    return (Center(
        child: Container(
            width: MediaQuery.of(context).size.width - 15,
            child: Center(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Card(
                        color: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15)),
                            side: BorderSide(width: 2, color: Colors.blue)),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                          value: filter,

                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                          iconSize: 35,
                          //isDense: true,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          underline: Container(
                            height: 2,
                            color: Colors.black,
                          ),
                          onChanged: (String data) {
                            setState(() {
                              this.filter = data;
                              if (this.filter != this.spinnerItems[0]) {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return DisplayFilteredCompanies(filter);
                                }));
                              }
                            });
                          },

                          items: this
                              .spinnerItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: (value == this.spinnerItems[0]
                                    ? Text(
                                        value,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      )
                                    : Text(
                                        value,
                                        style: TextStyle(
                                          color: Colors.pink,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      )));
                          }).toList(),
                        ))))))));
  }
}
