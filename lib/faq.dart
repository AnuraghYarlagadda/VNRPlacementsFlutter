import 'package:flutter/material.dart';

class FAQ extends StatefulWidget {
  @override
  FAQState createState() => FAQState();
}

class FAQState extends State<FAQ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            child: ExpansionTile(
              trailing: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.red,
                size: 25,
              ),
              title: Text(
                '1. Where can I see the downloaded files?',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic),
              ),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'A. 1. GoTo File Manager or File Explorer',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '     2. Open Internal Storage',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '     3. Search for "Placements" Folder inside',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '     4. You can view the Files Downloaded segregated Company-wise in Folders',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          Card(
            child: ExpansionTile(
              trailing: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.red,
                size: 25,
              ),
              title: Text(
                '2. Why am I seeing a grey screen in browser after clicking on "Launch in browser" ?',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic),
              ),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'A. "Launch in browser" tries to open a PDF Document in browser and the "Grey Screen" appears due to the problem caused by "Google Extensions" at that point of time. ',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '     Solution: "Reload the Page" and the document appears with in <=3 tries!',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          Card(
            child: ExpansionTile(
              trailing: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.red,
                size: 25,
              ),
              title: Text(
                '3. What is meant by Core category?',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic),
              ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                  child: Text(
                    'A. Core companies are the ones that specialize in particular sectors like mechanical, electrical or infrastructure sector.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ),
          Card(
            child: ExpansionTile(
              trailing: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.red,
                size: 25,
              ),
              title: Text(
                '4. What is meant by Product category?',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic),
              ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                  child: Text(
                    'A. Product based companies create products and are driven by an idea to help different customers.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ),
          Card(
            child: ExpansionTile(
              trailing: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.red,
                size: 25,
              ),
              title: Text(
                '5. What is meant by Service category?',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic),
              ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                  child: Text(
                    'A. Service Based Companies are driven by customer needs. They offer services and solutions as per customer requirements. ',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ),
          Card(
            child: ExpansionTile(
              trailing: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.red,
                size: 25,
              ),
              title: Text(
                '6. What content is available in Interview Questions?',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic),
              ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                  child: Text(
                    'A. It contains sample questions what could be asked in the interview process of the specific company.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ),
          Card(
            child: ExpansionTile(
              trailing: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.red,
                size: 25,
              ),
              title: Text(
                '7. What content is available in Interview Details?',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic),
              ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                  child: Text(
                    'A. It generally has the information about the interview process and other details about the company.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ),
          Card(
            child: ExpansionTile(
              trailing: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.red,
                size: 25,
              ),
              title: Text(
                '8. Why are a few fields empty for some companies?',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic),
              ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                  child: Text(
                    'A. The available fields are shown as of now. However  the information gets updated with new information day by day.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
