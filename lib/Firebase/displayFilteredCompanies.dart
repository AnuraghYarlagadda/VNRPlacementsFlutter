import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
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
  List<dynamic> companies = [];
  int _status;
  String filtertype;
  @override
  void initState() {
    super.initState();
    this.filtertype = widget.filtertype;
    this._status = Status.loading.index;
    _fetchData();
  }

  _fetchData() {
    final ref = fb.reference();
    ref.child("Filter").child(this.filtertype).once().then((DataSnapshot data) {
      setState(() {
        this.companies = data.value.values.toList();
        this.companies.sort();
        this._status = Status.loaded.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.filtertype)),
        body:Container(
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
          )
        ));
  }

  Widget companiesList() {
    return (Center(
      child: this._status == Status.loading.index
          ? SpinKitWave(color: Colors.pink, type: SpinKitWaveType.start)
          : ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              itemCount: this.companies.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return DisplayCompanyDetails(
                              this.companies[index].toString());
                        },
                      ),
                    );
                  },
                  child: Container(
                    //padding: EdgeInsets.all(20),
                    child: Card(
                      child: ListTile(
                        trailing:
                            Icon(Icons.arrow_forward_ios, color: Colors.blue),
                        title: Text(
                          this.companies[index].toString().trim().toUpperCase(),
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
              },
            ),
    ));
  }
}
