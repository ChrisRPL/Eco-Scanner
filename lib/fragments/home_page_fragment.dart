import 'package:connectivity/connectivity.dart';
import 'package:eco_scanner/widgets/insert_barcode.dart';
import 'package:eco_scanner/widgets/start_info_widget.dart';
import 'package:flutter/material.dart';

import 'package:eco_scanner/widgets/custom_dialog.dart';

class HomePageFragment extends StatefulWidget {
  var scanQr;
  var checkProductInWeb;

  HomePageFragment(this.scanQr, this.checkProductInWeb);

  @override
  HomePageFragmentState createState() {
    return new HomePageFragmentState(scanQr, checkProductInWeb);
  }
}

class HomePageFragmentState extends State<HomePageFragment> {
  var scanQr;
  var checkProductInWeb;

  HomePageFragmentState(this.scanQr, this.checkProductInWeb);

  _showBarcodeInsertSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        elevation: 8,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return GestureDetector(
              onTap: () {}, child: InsertBarcode(checkProductInWeb));
        });
  }

  _checkInternetConnectivity(var action) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
          context: context,
          builder: (ctx) => CustomDialog(
                buttonText: "OK",
                title: "Oooppsss!",
                description:
                    "To use this function, you have to be connected to internet!",
                avatarColor: Colors.orange,
                icon: Icons.warning,
                dialogAction: () {
                  Navigator.of(context).pop();
                },
              ),
          barrierDismissible: false);
    } else {
      action();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightGreen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StartInfo(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: FloatingActionButton.extended(
                    heroTag: "1",
                    icon: Icon(Icons.center_focus_weak),
                    label: Text(
                      "Scan barcode",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: "OpenSans",
                        fontSize: 15,
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black12,
                            offset: Offset(3.0, 3.0),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () => _checkInternetConnectivity(scanQr),
                    backgroundColor: Colors.lime,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: FloatingActionButton.extended(
                    heroTag: "2",
                    icon: Icon(Icons.create),
                    label: Text(
                      "Insert barcode",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: "OpenSans",
                        fontSize: 15,
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black12,
                            offset: Offset(3.0, 3.0),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () => _checkInternetConnectivity(
                        () => _showBarcodeInsertSheet(context)),
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
