import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vnrplacements/Firebase/displayCompanyDetails.dart';

class DisplayFilteredCompanies extends StatefulWidget {
  final String filtertype;
  const DisplayFilteredCompanies(this.filtertype);
  @override
  State<StatefulWidget> createState() {
    return DisplayFilteredCompaniesState();
  }
}

enum Status { loading, loaded }

class DisplayFilteredCompaniesState extends State<DisplayFilteredCompanies> {
  final fb = FirebaseDatabase.instance;
  SplayTreeSet companies, items;
  TextEditingController editingController = TextEditingController();

  int _status;
  String filtertype;
  @override
  void initState() {
    super.initState();
    this.filtertype = widget.filtertype;
    this._status = Status.loading.index;
    this.companies = new SplayTreeSet<dynamic>();
    this.items = new SplayTreeSet<dynamic>();
    _fetchData();
  }

  @override
  void dispose() {
    editingController.clear();
    editingController.dispose();
    super.dispose();
  }

  _fetchData() {
    final ref = fb.reference();
    ref.child("Filter").child(this.filtertype).once().then((DataSnapshot data) {
      setState(() {
        this.companies.addAll(data.value.values.toList());
        this.items.addAll(this.companies);
        this._status = Status.loaded.index;
      });
    });
  }

  void filterSearchResults(String query) {
    List<dynamic> dummySearchList = List<dynamic>();
    dummySearchList.addAll(this.companies);
    if (query.isNotEmpty) {
      List<dynamic> dummyListData = List<dynamic>();
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(this.companies);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.search),
          centerTitle: true,
          title: TextField(
            //autofocus: true,
            controller: editingController,
            style: new TextStyle(
              color: Colors.white,
            ),
            onChanged: (value) {
              filterSearchResults(value.toLowerCase());
            },
            cursorColor: Colors.white,
            cursorWidth: 2.5,
            showCursor: true,
            decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: "Search ..",
                hintStyle: new TextStyle(color: Colors.white)),
          ),
        ),
        body: Container(
            //decoration: new BoxDecoration(gradient: Gradients.coldLinear),
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
          child: companiesList(),
        )));
  }

  Widget companiesList() {
    return (Center(
      child: this._status == Status.loading.index
          ? SpinKitWave(color: Colors.pink, type: SpinKitWaveType.start)
          : Container(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                    child: Text(
                      this.filtertype,
                      style: TextStyle(
                          fontSize: 21,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  Expanded(
                      child: items.length == 0
                          ? Text("☹️ No such Company found..!")
                          : Scrollbar(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return DisplayCompanyDetails(this
                                                  .items
                                                  .elementAt(index)
                                                  .toString());
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        //padding: EdgeInsets.all(20),
                                        child: Card(
                                          child: ListTile(
                                            trailing: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.blue),
                                            title: Text(
                                              this
                                                  .items
                                                  .elementAt(index)
                                                  .toString()
                                                  .trim()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        //color: index % 2 == 0 ? Colors.blue : Colors.white,
                                      ),
                                    );
                                  })))
                ],
              ),
            ),
    ));
  }
}
