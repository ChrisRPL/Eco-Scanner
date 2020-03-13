import 'package:flutter/material.dart';

import 'package:eco_scanner/main_screens/loading_page.dart';

class InsertBarcode extends StatefulWidget {
  var qrFunction;

  InsertBarcode(this.qrFunction);

  @override
  _InsertBarcodeState createState() => _InsertBarcodeState(this.qrFunction);
}

class _InsertBarcodeState extends State<InsertBarcode> {
  var qrFunction;

  _InsertBarcodeState(this.qrFunction);
  TextEditingController barcode = TextEditingController();

  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(14.0), topRight: Radius.circular(14.0)),
        ),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    right: 30, left: 30, top: 15, bottom: 15
                ),
                child: Image.asset("assets/product.png", fit: BoxFit.fitWidth,),
              ),
              TextFormField(
                controller: barcode,
                decoration: new InputDecoration(
                  labelText: "Insert barcode",
                  labelStyle: TextStyle(
                      color: Colors.green
                  ),
                  fillColor: Colors.white,
                  enabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                      color: Colors.green,
                    ),
                  ),
                ),
                validator: (val) {
                  if(val.length==0) {
                    return "Please provide valid barcode!";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: OutlineButton(onPressed: (){
                  qrFunction(barcode.text);
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext ctx) => LoadingPage()));
                  },
                  splashColor: Colors.lime,
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text("CHECK!", style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.normal, fontSize: 18, color: Colors.lightGreen, shadows: [
                      Shadow(
                        blurRadius: 3.0,
                        color: Colors.black12,
                        offset: Offset(1.5, 1.5),
                      ),
                    ],),),
                  ),
                  borderSide: BorderSide(
                      color: Colors.lightGreen,
                      style: BorderStyle.solid,
                      width: 1.2
                  ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
