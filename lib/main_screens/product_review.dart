import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:eco_scanner/models/product_item.dart';
import 'package:eco_scanner/widgets/pass_product_data.dart';
import 'package:eco_scanner/sqlite/db_manager.dart';
import 'package:flutter/material.dart';

import 'package:eco_scanner/widgets/custom_dialog.dart';
import 'package:eco_scanner/main_screens/home_page.dart';


class ProductReview extends StatefulWidget {

  String name;
  String imageUrl;
  bool isCruelty;
  String companyName;
  String productBarcode;
  static final productReviewRoute = "/product_review";

  ProductReview({@required this.name, @required this.imageUrl, @required this.isCruelty, @required this.companyName, @required this.productBarcode});

  @override
  ProductReviewState createState() => ProductReviewState();
}

class ProductReviewState extends State<ProductReview> {
  var dbManager;


  _showBarcodeInsertSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        elevation: 8,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return GestureDetector(
              onTap: (){},
              child: PassProductData(widget.isCruelty, widget.productBarcode)
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    dbManager = DbManager();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
            color: Colors.white,),
          onPressed: ()=>Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        title: Text("Eco Scanner", style: TextStyle(fontFamily: "OpenSans", color: Colors.lightGreenAccent, shadows: [
          Shadow(
            blurRadius: 3.0,
            color: Colors.black12,
            offset: Offset(3.0, 3.0),
          ),
        ],),),
      ),
      body: Builder(
        builder: (ctx) => Container(
          color: Colors.lightGreen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              widget.imageUrl=="" ?
              Card(
                margin: EdgeInsets.only(left: 40, right: 40, top: 100, bottom: 100),
                color: Colors.white,
                elevation: 8,
                child: Column(
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                      color: Colors.orange,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 5, right: 5),
                              child: Icon(Icons.warning, color: Colors.white,),
                            ),
                            Text("Couldn't load the product resources :(", textAlign: TextAlign.center, style: TextStyle(fontFamily: "OpenSans" ,fontWeight: FontWeight.normal, color: Colors.white, shadows: [
                              Shadow(
                                blurRadius: 1.0,
                                color: Colors.black26,
                                offset: Offset(1.0, 1.0),
                              ),
                            ])
                              ,)
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 15,  bottom: 15),
                      elevation: 8,
                      color: widget.isCruelty ? Colors.red : Colors.green,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Icon(widget.isCruelty ? Icons.sentiment_very_dissatisfied : Icons.sentiment_very_satisfied, color: Colors.white,),
                            Text(widget.isCruelty ? "Oooppss! Your product could be tested on animals! Company " + widget.companyName + " which owns that product tests its products on animals!" : "But your product has not been found in \"animal-tested\" list, it's cruelty-free! :)", textAlign: TextAlign.center, style: TextStyle(fontFamily: "OpenSans" ,fontWeight: FontWeight.normal, color: Colors.white, shadows: [
                              Shadow(
                                blurRadius: 1.0,
                                color: Colors.black26,
                                offset: Offset(1.0, 1.0),
                              ),
                            ])
                              ,)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: BarCodeImage(
                        padding: EdgeInsets.all(5),
                        params: Code39BarCodeParams(
                          widget.productBarcode,
                          lineWidth: 0.6,
                          barHeight: 50.0,
                          withText: true,
                        ),
                        onError: (error) {
                          print('error = $error');
                        },
                      ),
                    ),
                  ],
                ),
              )
              :
              Card(
                margin: EdgeInsets.only(left: 15, right: 15, top: 50, bottom: 50),
                color: Colors.white,
                elevation: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Card(
                          margin: EdgeInsets.only(top: 10),
                          child: Container(
                            width: 200,
                            child: Text(widget.name,softWrap: true, textAlign: TextAlign.center, style: TextStyle(fontFamily: "OpenSans" ,fontWeight: FontWeight.normal, color: Colors.black, shadows: [
                              Shadow(
                                blurRadius: 1.0,
                                color: Colors.black26,
                                offset: Offset(1.0, 1.0),
                              ),
                            ])
                              ,),
                          )
                        ),
                            Card(
                              margin: EdgeInsets.only(top: 15, bottom: 5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                              elevation: 8,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: Image.network(widget.imageUrl, fit: BoxFit.fitWidth, width: 80,),
                      ),
                            ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: BarCodeImage(
                        padding: EdgeInsets.all(5),
                        params: Code39BarCodeParams(
                        widget.productBarcode,
                        lineWidth: 0.6,
                        barHeight: 50.0,
                        withText: true,
                        ),
                        onError: (error) {
                        print('error = $error');
                        },
                          ),
                    ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 150,
                      child: Card(
                        margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                        elevation: 8,
                        color: widget.isCruelty ? Colors.red : Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              children: <Widget>[
                                Container(margin: EdgeInsets.only(bottom: 10),child: Icon(widget.isCruelty ? Icons.sentiment_very_dissatisfied : Icons.sentiment_very_satisfied, color: Colors.white,size: 30,)),
                                Text(widget.isCruelty ? "Oooppss! Your product could be tested on animals! Company " + widget.companyName + " which owns that product tests its products on animals!" : "Your product is cruelty-free :)", textAlign: TextAlign.center, softWrap: true, style: TextStyle(fontFamily: "OpenSans" ,fontWeight: FontWeight.normal, color: Colors.white, shadows: [
                                  Shadow(
                                    blurRadius: 1.0,
                                    color: Colors.black26,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ])
                                  ,)
                              ],
                            ),
                        ),
                      ),
                    ),
                  ],
                      )),
              widget.imageUrl=="" ?  RaisedButton.icon(
                  onPressed: (){ _showBarcodeInsertSheet(context);},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                color: Colors.grey,
                icon: Icon(Icons.add, color: Colors.white, size: 25,),
                label:
                  Text("Add product data yourself", style: TextStyle(fontFamily: "OpenSans" ,fontSize:16, fontWeight: FontWeight.normal, color: Colors.white, shadows: [
                    Shadow(
                      blurRadius: 1.0,
                      color: Colors.black26,
                      offset: Offset(1.0, 1.0),
                    ),
                  ])),
                  ) :
                  RaisedButton.icon(
                      onPressed: (){
                        dbManager.save(ProductItem(DateTime.now().millisecond, widget.name, widget.companyName, widget.imageUrl, widget.productBarcode, widget.isCruelty ? 1 : 0));
                        showDialog(context: context, builder: (ctx) => CustomDialog(
                          buttonText: "OK",
                          title: "Huurrraayy!",
                          description:"Your product has been added successfully!",
                          avatarColor: Colors.lightGreen,
                          icon: Icons.sentiment_very_satisfied,
                          dialogAction: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (BuildContext ctx) => HomePage()));
                          },
                        ),
                        barrierDismissible: false);
                      },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    color: Colors.grey,
                    icon: Icon(Icons.add, color: Colors.white, size: 25,),
                    label:
                    Text("Add product to list", style: TextStyle(fontFamily: "OpenSans" ,fontSize:16,fontWeight: FontWeight.normal, color: Colors.white, shadows: [
                      Shadow(
                        blurRadius: 1.0,
                        color: Colors.black26,
                        offset: Offset(1.0, 1.0),
                      ),
                    ])),)
            ],
          ),
        ),
      ),
    );
  }
}
