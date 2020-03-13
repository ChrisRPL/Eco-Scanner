import 'dart:io';

import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:eco_scanner/models/product_item.dart';
import 'package:eco_scanner/sqlite/db_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:eco_scanner/widgets/custom_dialog.dart';

class TestedFragment extends StatefulWidget {


  @override
  _TestedFragmentState createState() => _TestedFragmentState();


}

class _TestedFragmentState extends State<TestedFragment> {
  bool all;
  bool tested;
  bool non_tested;
  var dbManager ;
  List<ProductItem> list;

  _checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(context: context, builder: (ctx) => CustomDialog(
        buttonText: "OK I GOT IT",
        title: "Oooppsss!",
        description:"It seems like you are not connected to a network! Some information will not be able to be properly loaded!",
        avatarColor: Colors.orange,
        icon: Icons.warning,
        dialogAction: (){
          Navigator.of(context).pop();
        },
      ),
          barrierDismissible: false);
    }
  }


  Future<List<ProductItem>> products;
  final key = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkInternetConnectivity();
    all = true;
    tested = false;
    non_tested = false;
    dbManager = DbManager();
    products = dbManager.getAllProducts();
    debugPrint("INIT STATE");
  }


  Widget _buildElement(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Column(
                  children: <Widget>[
                    Text("All", style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.bold, color: Colors.white, shadows: [
                      Shadow(
                        blurRadius: 3.0,
                        color: Colors.black12,
                        offset: Offset(3.0, 3.0),
                      ),
                    ],)),
                    Switch(value: all, onChanged: (val){
                      setState(() {
                        if(!all) {
                          all = val;
                          tested = !val;
                          non_tested = !val;
                        }
                      });

                    })
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Text("Tested", style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.bold, color: Colors.white, shadows: [
                    Shadow(
                      blurRadius: 3.0,
                      color: Colors.black12,
                      offset: Offset(3.0, 3.0),
                    ),
                  ],)),
                  Switch(activeColor: Colors.red,
                      value: tested, onChanged: (val){
                        setState(() {
                          if(!tested) {
                            tested = val;
                            all = !val;
                            non_tested = !val;
                          }
                        });
                      })
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Non-tested", style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.bold, color: Colors.white, shadows: [
                      Shadow(
                        blurRadius: 3.0,
                        color: Colors.black12,
                        offset: Offset(3.0, 3.0),
                      ),
                    ],)),
                    Switch(activeColor: Colors.lime,
                        value: non_tested, onChanged: (val){
                          setState(() {
                            if(!non_tested) {
                              non_tested = val;
                              all = !val;
                              tested = !val;
                            }
                          });
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
              future: products,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  all ? list = snapshot.data : tested ? list = snapshot.data.where((element) => element.isCruelty==1).toList() : list = snapshot.data.where((element) => element.isCruelty==0).toList();
                  return list.length>0 ? ListView.builder(
                      itemCount: all ? snapshot.data.length : tested ? snapshot.data.where((element) => element.isCruelty==1).toList().length : snapshot.data.where((element) => element.isCruelty==0).toList().length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: Material(
                                elevation: 8,
                                child: InkWell(
                                  splashColor: Colors.green,
                                  onTap: (){
                                    Clipboard.setData(new ClipboardData(text: list[index].barcode));
                                    key.currentState.showSnackBar(
                                        new SnackBar(
                                          content: new Text("Copied barcode to Clipboard"),));
                                  },
                                  child: ListTile(
                                    leading: list[index].imageUrl.contains("https") ?
                                    Image.network(
                                      list[index].imageUrl, width: 50,
                                      fit: BoxFit.fitWidth,):
                                    Image.file(
                                      File(list[index].imageUrl), width: 50,
                                      fit: BoxFit.fitWidth,),
                                    title: Text(list[index].name, style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "OpenSans",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 1.0,
                                            color: Colors.black26,
                                            offset: Offset(1.0, 1.0),
                                          ),
                                        ])),
                                    subtitle:list[index].companyName!=null ? Text(list[index].companyName,
                                        style: TextStyle(fontFamily: "OpenSans",
                                            fontSize: 10,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 1.0,
                                                color: Colors.black26,
                                                offset: Offset(1.0, 1.0),
                                              ),
                                            ])) : Container(),
                                    trailing: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: BarCodeImage(
                                        padding: EdgeInsets.all(5),
                                        params: Code39BarCodeParams(
                                          list[index].barcode,
                                          lineWidth: 0.6,
                                          altText: "Siema",
                                          barHeight: 50,
                                          withText: true,
                                        ),
                                        onError: (error) {
                                          print('error = $error');
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () {
                                    setState(() {
                                      Scaffold.of(context).showSnackBar(
                                          new SnackBar(
                                            content: new Text("Item deleted from list"),)
                                      );
                                      dbManager.delete(list[index].id);
                                      list.removeAt(index);
                                      products = dbManager.getAllProducts();
                                    });
                                  },
                                )
                                ,
                              ]
                              ,
                            ),
                            Divider(color: Colors.lime,)
                          ],
                        );
                      }
                  ) : Center(
                    child: Column(
                      children: <Widget>[
                        Text("Ooooppsss! Your list is empty!", textAlign: TextAlign.center, style: TextStyle(fontFamily: "OpenSans" ,fontWeight: FontWeight.normal, color: Colors.white, shadows: [
                          Shadow(
                            blurRadius: 1.0,
                            color: Colors.black26,
                            offset: Offset(1.0, 1.0),
                          ),
                        ])
                          ,),Divider(),
                        Icon(Icons.sentiment_very_dissatisfied, color: Colors.white, size: 150,),
                      ],
                    ),
                  );
                }


                return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),))
                );




              }
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext ctx) {

    return Scaffold(
      key: key,
      backgroundColor: Colors.lightGreen,
      body: Builder(
        builder: (ctx) => Container(
          color: Colors.lightGreen,
          child: _buildElement(context)
        ),
      ),
    );
  }
}
