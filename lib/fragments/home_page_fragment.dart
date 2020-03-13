import 'package:eco_scanner/start_info_widget.dart';
import 'package:flutter/material.dart';

import '../InsertBarcode.dart';


class HomePageFragment extends StatefulWidget {
  var scanQr;
  var qrFunction;

  HomePageFragment(this.scanQr, this.qrFunction);

  @override
  HomePageFragmentState createState() {
    return new HomePageFragmentState(scanQr, qrFunction);
  }
}

class HomePageFragmentState extends State<HomePageFragment> {
  String result = "Check your product, if is animal-tested!";

  var scanQr;
  var qrFunction;

  HomePageFragmentState(this.scanQr, this.qrFunction);


  _showBarcodeInsertSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        elevation: 8,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return GestureDetector(
            onTap: (){},
            child: InsertBarcode(qrFunction)
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Colors.lightGreen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            startInfo(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: FloatingActionButton.extended(
                    heroTag: "1",
                    icon: Icon(Icons.center_focus_weak),
                    label: Text("Scan barcode", style: TextStyle(fontWeight: FontWeight.normal,
                      fontFamily: "OpenSans",
                      fontSize: 15,
                      shadows: [
                        Shadow(
                          blurRadius: 3.0,
                          color: Colors.black12,
                          offset: Offset(3.0, 3.0),
                        ),
                      ],),
                    ),
                    onPressed: scanQr,
                    backgroundColor: Colors.lime,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: FloatingActionButton.extended(
                    heroTag: "2",
                    icon: Icon(Icons.create),
                    label: Text("Insert barcode", style: TextStyle(fontWeight: FontWeight.normal,
                      fontFamily: "OpenSans",
                      fontSize: 15,
                      shadows: [
                        Shadow(
                          blurRadius: 3.0,
                          color: Colors.black12,
                          offset: Offset(3.0, 3.0),
                        ),
                      ],),
                    ),
                    onPressed: ()=>_showBarcodeInsertSheet(context),
                    backgroundColor: Colors.lime,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}