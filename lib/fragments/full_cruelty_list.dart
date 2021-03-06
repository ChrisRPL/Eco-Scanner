import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

import 'package:eco_scanner/widgets/custom_dialog.dart';
import 'package:eco_scanner/main_screens/home_page.dart';

class FullCrueltyList extends StatefulWidget {
  @override
  _FullCrueltyListState createState() => _FullCrueltyListState();
}

class _FullCrueltyListState extends State<FullCrueltyList> {
  TextEditingController editingController;
  List products;
  List unfilterProducts;
  Future getCompanyNames;

  Future getCrueltyList() async {
    var client = http.Client();
    Response response = await client
        .get("https://crueltyfree.peta.org/companies-do-test/?per_page=all");
    var document = parse(response.body);
    var companyNamesElements = document
        .getElementsByClassName("search-results")[0]
        .getElementsByTagName("li");
    var listOfMatches = companyNamesElements
        .map((e) => e.getElementsByTagName("a")[0].attributes["title"])
        .toList();
    setState(() {
      products = listOfMatches;
      unfilterProducts = products;
    });
    return listOfMatches;
  }

  searchCompanyByName(str) {
    var strExist = str.length > 0 ? true : false;

    if (strExist) {
      var filterData = [];
      for (var i = 0; i < unfilterProducts.length; i++) {
        //EXTRACT COMPANY NAME FROM HTML AND CLEAN STRING
        String word = unfilterProducts[i]
            .replaceAll("amp;", "")
            .replaceAll("\\u0027", "'")
            .replaceAll("\"com_ComName\":", "")
            .replaceAll("\"", "")
            .replaceAll("&#233;", "e")
            .replaceAll("&#246;", "o")
            .replaceAll("&#244;;", "e");

        if (word.toLowerCase().contains(str) ||
            word.toUpperCase().contains(str)) {
          filterData.add(unfilterProducts[i]);
        }
      }

      setState(() {
        this.products = filterData;
      });
    } else {
      setState(() {
        this.products = this.unfilterProducts;
      });
    }
  }

  _checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
          context: context,
          builder: (ctx) => CustomDialog(
                buttonText: "OK",
                title: "Oooppsss!",
                description:
                    "It seems like you are not connected to a network! To show informations on this page, you have to connect to the internet!",
                avatarColor: Colors.orange,
                icon: Icons.warning,
                dialogAction: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext ctx) => HomePage()));
                },
              ),
          barrierDismissible: false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkInternetConnectivity();
    editingController = new TextEditingController();
    getCompanyNames = getCrueltyList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 15, left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Full Cruelty List",
                    style: TextStyle(
                        fontFamily: "OpenSans",
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 1.0,
                            color: Colors.black26,
                            offset: Offset(1.0, 1.0),
                          ),
                        ])),
              ],
            ),
          ),
          Divider(
            color: Colors.white,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                      "Here is full list of companies that do tests on animals, list shared by PETA organization",
                      softWrap: true,
                      style: TextStyle(
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 1.0,
                              color: Colors.black26,
                              offset: Offset(1.0, 1.0),
                            ),
                          ])),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: InkWell(
                      splashColor: Colors.blue,
                      child: Text("https://www.peta.org/",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "OpenSans",
                              color: Colors.blue,
                              fontWeight: FontWeight.normal,
                              shadows: [
                                Shadow(
                                  blurRadius: 1.0,
                                  color: Colors.black26,
                                  offset: Offset(1.0, 1.0),
                                ),
                              ])),
                      onTap: () async {
                        await launch("https://www.peta.org/");
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.white,
          ),
          Container(
            margin: EdgeInsets.only(left: 5, right: 5, bottom: 5),
            child: TextField(
              onChanged: (_) =>
                  searchCompanyByName(editingController.text.toString()),
              controller: editingController,
              decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  )),
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: getCompanyNames,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.work),
                            title: Text(products[index]
                                .replaceAll("amp;", "")
                                .replaceAll("\\u0027", "'")
                                .replaceAll("\"com_ComName\":", "")
                                .replaceAll("\"", "")
                                .replaceAll("&#233;", "e")
                                .replaceAll("&#246;", "o")
                                .replaceAll("&#244;", "e")),
                          ),
                        );
                      },
                    );
                  }
                  return Container(
                      child: Center(
                          child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  )));
                }),
          ),
        ],
      ),
    );
  }
}
