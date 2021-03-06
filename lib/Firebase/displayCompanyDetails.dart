import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:vnrplacements/DataModels/CompanyDetails.dart';
import 'package:vnrplacements/FirebaseSignInAnonymous.dart';
import 'package:vnrplacements/StoragePermissions.dart';
import 'package:vnrplacements/cardx.dart';
import 'package:vnrplacements/getDownloadURLFromFirebase.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';

class DisplayCompanyDetails extends StatefulWidget {
  final String companyName;
  const DisplayCompanyDetails(this.companyName);
  @override
  State<StatefulWidget> createState() {
    return DisplayCompanyDetailsState();
  }
}

class DisplayCompanyDetailsState extends State<DisplayCompanyDetails> {
  final fb = FirebaseDatabase.instance;
  CompanyDetails companyDetails;
  LinkedHashMap ec, jd;
  //String urlOfDetails, urlOfQuestions;
  List cards;
  String companyName;
  double width, height;
  @override
  void initState() {
    super.initState();
    firebaseSignIn();
    grantStoragePermissionAndCreateDir(context);
    this.companyName = widget.companyName;
    fetchDetails();
    fetchurls();
  }

  sort() {
    if (this.companyDetails != null && this.companyDetails.ec != null) {
      //print("EC");
      var sortedKeys = this.companyDetails.ec.keys.toList(growable: false)
        ..sort((a, b) => a.compareTo(b));
      setState(() {
        this.ec = new LinkedHashMap.fromIterable(sortedKeys,
            key: (k) => k, value: (k) => this.companyDetails.ec[k]);
      });
    }
    if (this.companyDetails != null && this.companyDetails.jd != null) {
      //print("JD");
      var sortedKeys = this.companyDetails.jd.keys.toList(growable: false)
        ..sort((a, b) => a.compareTo(b));
      setState(() {
        this.jd = new LinkedHashMap.fromIterable(sortedKeys,
            key: (k) => k, value: (k) => this.companyDetails.jd[k]);
      });
    }
    // print(ec);
    // print(jd);
  }

  fetchDetails() {
    final ref = fb.reference();
    ref
        .child("Company")
        .child(this.companyName)
        .once()
        .then((DataSnapshot data) {
      setState(() {
        this.companyDetails = CompanyDetails.fromSnapshot(data);
        sort();
      });
    });
  }

  fetchurls() async {
    this.cards = new List<cardx>();
    await firebaseurl("questions" + "/" + this.companyName + "_questions.pdf")
        .then((onValue) {
      setState(() {
        if (onValue != null) {
          this.cards.add(
                cardx(
                    "Interview Questions", this.companyName, Gradients.tameer),
              );
        }
      });
    });
    await firebaseurl("details" + "/" + this.companyName + "_details.pdf")
        .then((onValue) {
      setState(() {
        if (onValue != null) {
          this.cards.add(
                cardx(
                    "Interview Details", this.companyName, Gradients.taitanum),
              );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    this.height = MediaQuery.of(context).size.height;
    this.width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.companyName.toString().trim().toUpperCase())),
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
          child: Container(
              child: companyDetails == null
                  ? Center(
                      child: SpinKitDualRing(color: Colors.pink),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              child: ec == null
                                  ? Text("")
                                  : Column(children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      ),
                                      Text(
                                        "Eligibility Criteria",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: ec.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          String key = ec.keys.elementAt(index);
                                          return new Column(
                                            children: <Widget>[
                                              new ListTile(
                                                title: new Text(
                                                  "$key".toString().trim(),
                                                  style: TextStyle(
                                                      //fontSize: 20,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                ),
                                                subtitle: new Text(
                                                  "${ec[key]}"
                                                      .toString()
                                                      .trim(),
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                              new Divider(
                                                height: 2.0,
                                                thickness: 2,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ])),
                          Container(
                              child: jd == null
                                  ? Text("")
                                  : Column(children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      ),
                                      Text(
                                        "Job Description",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: jd.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          String key = jd.keys.elementAt(index);
                                          return new Column(
                                            children: <Widget>[
                                              new ListTile(
                                                title: new Text(
                                                  "$key".toString().trim(),
                                                  style: TextStyle(
                                                      //fontSize: 20,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                ),
                                                subtitle: new Text(
                                                  "${jd[key]}"
                                                      .toString()
                                                      .trim(),
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                              new Divider(
                                                height: 2.0,
                                                thickness: 2,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ])),
                          this.cards.length == 0
                              ? Text("")
                              : (this.cards.length != 1
                                  ? SizedBox(
                                      height: this.height / 3,
                                      child: Swiper(
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return (SizedBox(
                                              child: cards[index]));
                                        },
                                        itemCount: cards.length,
                                        itemWidth: this.width - 60,
                                        itemHeight: 130,
                                        layout: SwiperLayout.STACK,
                                        indicatorLayout:
                                            PageIndicatorLayout.COLOR,
                                        pagination: new SwiperPagination(
                                            builder:
                                                new DotSwiperPaginationBuilder(
                                                    color: Colors.grey,
                                                    size: 8,
                                                    activeSize: 11,
                                                    activeColor:
                                                        Colors.pinkAccent)),
                                        control: new SwiperControl(),
                                        scrollDirection: Axis.horizontal,
                                      ))
                                  : this.cards[0]),
                        ],
                      ))),
        ));
  }
}
