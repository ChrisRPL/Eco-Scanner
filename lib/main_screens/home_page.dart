import 'dart:convert';

import 'package:eco_scanner/fragments/full_cruelty_list.dart';
import 'package:eco_scanner/fragments/home_page_fragment.dart';
import 'package:eco_scanner/fragments/tested_fragment.dart';
import 'package:eco_scanner/functions/secret_loader.dart';
import 'package:eco_scanner/main_screens/loading_page.dart';
import 'package:eco_scanner/main_screens/product_review.dart';
import 'package:eco_scanner/models/drawer_item.dart';
import 'package:eco_scanner/models/secret.dart';
import 'package:eco_scanner/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eco_scanner/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem(
      'Home Page',
      Icons.home,
    ),
    new DrawerItem(
      'My products',
      Icons.star,
    ),
    new DrawerItem(
      'Cruelty products list',
      Icons.list,
    )
  ];

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String result;
  var companyName;

  bool findCompanyInProduct(var listOfMatches, var productName) {
    var isCruelty = false;

    //REGULAR EXPRESSION TO EXTRACT SECOND COMPANY NAME IF EXISTS
    RegExp regExp4 = RegExp("\\(.+\\)");

    for (int i = 0; i < listOfMatches.length; i++) {
      //EXTRACT COMPANY NAME FROM HTML AND CLEAN STRING
      var crueltyCompany = listOfMatches[i]
          .replaceAll("amp;", "")
          .replaceAll("\\u0027", "'")
          .replaceAll("\"com_ComName\":", "")
          .replaceAll("\"", "");

      if (crueltyCompany.contains("(")) {
        var companyFirstName = crueltyCompany
            .replaceAll(
                regExp4.allMatches(crueltyCompany).toList()[0].group(0), "")
            .replaceAll(" ", "")
            .toLowerCase();

        var secondCompanyName = regExp4
            .allMatches(crueltyCompany)
            .toList()[0]
            .group(0)
            .replaceAll("(", "")
            .replaceAll(")", "")
            .replaceAll(" ", "")
            .toLowerCase();

        isCruelty = (productName
                .toString()
                .toLowerCase()
                .replaceAll(" ", "")
                .contains(secondCompanyName) ||
            productName
                .toString()
                .toLowerCase()
                .replaceAll(" ", "")
                .contains(companyFirstName));

        // BREAK THE LOOP IF PRODUCT IS CRUELTY
        if (isCruelty) {
          debugPrint(crueltyCompany);
          companyName = crueltyCompany;
          break;
        }
      } else {
        isCruelty = productName
            .toString()
            .toLowerCase()
            .contains(crueltyCompany.toLowerCase());

        if (isCruelty) {
          companyName = crueltyCompany;
          debugPrint(productName);
          debugPrint(crueltyCompany);
          break;
        }
      }
    }
    return isCruelty;
  }

  Future getProductFromWeb(String barcode) async {
    var imageUrl;
    var productName;
    var isCruelty = false;

    //SHOW LOADING SCREEN WHILE SEARCHING FOR DATA
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext ctx) => LoadingPage()));

    try {
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

      Secret secret = await SecretLoader(secretPath: "secrets.json").load();

      var queryRequest = 'https://www.googleapis.com/customsearch/v1?key=' +
          secret.apiKey +
          '&cx=' +
          secret.idKey +
          '&q=' +
          barcode +
          '&searchType=image';

      debugPrint(queryRequest);

      var googleResponse = await http.get(Uri.parse(queryRequest));

      debugPrint(googleResponse.body);
      Map<String, dynamic> responseJson = jsonDecode(googleResponse.body);
      var results = responseJson['items'] as List;
      var firstResult = results[0];

      imageUrl = firstResult['image']['thumbnailLink'];
      productName = firstResult['title'];
      isCruelty = findCompanyInProduct(listOfMatches, productName);
    } catch (exception) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (ctx) => CustomDialog(
                buttonText: "OK I GOT IT",
                title: "Oooppsss!",
                description:
                    "It looks like we could not find that product in the database!",
                avatarColor: Colors.red,
                icon: Icons.sentiment_dissatisfied,
                dialogAction: () {
                  Navigator.of(context).pop();
                },
              ),
          barrierDismissible: false);
      return;
    }

    !isCruelty ? _incrementCrueltyFreeProducts() : _incrementCrueltyProducts();

    //SHOW PAGE WITH PRODUCT REVIEW
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext ctx) => ProductReview(
                  name: productName,
                  imageUrl: imageUrl,
                  isCruelty: isCruelty,
                  companyName: companyName,
                  productBarcode: barcode,
                )));
  }

  _incrementQrScans() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('totalScans') ?? 0) + 1;
    await prefs.setInt('totalScans', counter);
  }

  _incrementCrueltyProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('totalCrueltyScans') ?? 0) + 1;
    await prefs.setInt('totalCrueltyScans', counter);
  }

  _incrementCrueltyFreeProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('totalCrueltyFreeScans') ?? 0) + 1;
    await prefs.setInt('totalCrueltyFreeScans', counter);
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
        _incrementQrScans();
        getProductFromWeb(qrResult);
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new HomePageFragment(_scanQR, getProductFromWeb);
      case 1:
        return new TestedFragment();
      case 2:
        return new FullCrueltyList();

      default:
        return new Text("Error");
    }
  }

  onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon, size: 36),
        title: new Text(d.title,
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
        selected: i == _selectedDrawerIndex,
        onTap: () => onSelectItem(i),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Eco Scanner",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "OpenSans",
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 3.0,
                color: Colors.black12,
                offset: Offset(3.0, 3.0),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.center_focus_weak), onPressed: _scanQR)
        ],
      ),
      drawer: MainDrawer(drawerOptions),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
