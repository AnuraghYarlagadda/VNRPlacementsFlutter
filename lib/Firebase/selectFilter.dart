import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:vnrplacements/Firebase/displayFilteredCompanies.dart';
import 'package:vnrplacements/FirebaseSignInAnonymous.dart';
import 'package:vnrplacements/StoragePermissions.dart';
import 'package:vnrplacements/card.dart';

class Filter extends StatefulWidget {
  @override
  FilterState createState() => FilterState();
}

class FilterState extends State<Filter> {
  String filter = 'Click on Dropdown to select a category';
  List cards = new List<card>();
  List<String> spinnerItems = [
    "Click on Dropdown to select a category",
    "Core",
    "Software and Service",
    "Software and Product"
  ];
  @override
  void initState() {
    super.initState();
    firebaseSignIn();
    grantStoragePermissionAndCreateDir(context);
    this.cards.add(new card("Alumni Details", "",Colors.pink));
    this.cards.add(new card("List Of Companies", "",Colors.cyan));
    this.cards.add(new card("Requirements and Sample Resume", "",Colors.teal));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        leading: Icon(Icons.home),
      ),
      body: OfflineBuilder(
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
                    color: connected ? Colors.green : Colors.red,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: connected
                          ? Text(
                              'Online',
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
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
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                ),
                spinner(),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                  ),
                  items: this
                      .cards
                      .map((item) => Container(
                            child: Center(child: (item)),
                            color: Colors.white,
                            padding: EdgeInsets.all(10),
                          ))
                      .toList(),
                )
              ]))),
    );
  }

  Widget spinner() {
    return (Center(
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                        color: Colors.blue, style: BorderStyle.solid, width: 2),
                  ),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                    value: filter,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    iconSize: 30,
                    //isDense: true,
                    style: TextStyle(color: Colors.white, fontSize: 17),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (String data) {
                      setState(() {
                        this.filter = data;
                        if (this.filter !=
                            "Click on Dropdown to select a category") {
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
                  )))
            ]))));
  }
}
