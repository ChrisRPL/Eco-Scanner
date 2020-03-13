import 'package:eco_scanner/loading_page.dart';
import 'package:eco_scanner/product_review.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer.dart';
import 'fragments/full_cruelty_list.dart';
import 'fragments/home_page_fragment.dart';
import 'fragments/tested_fragment.dart';
import 'models/drawer_item.dart';

class HomePage extends StatefulWidget {


  final drawerItems = [
    new DrawerItem('Home Page', Icons.home,),
    new DrawerItem( 'My products', Icons.star,),
    new DrawerItem( 'Cruelty products list', Icons.list,)
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
    var isCrueltyFree = false;
    RegExp regExp4 = RegExp("\\(.+\\)");

    for (int i = 0; i < listOfMatches.length; i++) {
      var crueltyCompany = listOfMatches[i].group(0).replaceAll("amp;", "")
          .replaceAll("\\u0027", "'").replaceAll("\"com_ComName\":", "")
          .replaceAll("\"", "");
      if (crueltyCompany.contains("(")) {
        var companyFirstName = crueltyCompany.replaceAll(
            regExp4.allMatches(crueltyCompany).toList()[0].group(0), "")
            .replaceAll(" ", "")
            .toLowerCase();
        var secondCompanyName = regExp4.allMatches(crueltyCompany).toList()[0]
            .group(0).replaceAll("(", "").replaceAll(")", "").replaceAll(
            " ", "")
            .toLowerCase();
        isCrueltyFree =
        (productName.toString().toLowerCase().replaceAll(" ", "").contains(
            secondCompanyName) ||
            productName.toString().toLowerCase().replaceAll(" ", "").contains(
                companyFirstName));
        if (isCrueltyFree) {
          debugPrint(crueltyCompany);
          companyName = crueltyCompany;
          break;
        }
      } else {
        isCrueltyFree =
            productName.toString().toLowerCase().contains(
                crueltyCompany.toLowerCase());
        if (isCrueltyFree) {
          companyName = crueltyCompany;
          debugPrint(productName);
          debugPrint(crueltyCompany);
          break;
        }
      }
    }
    return isCrueltyFree;
  }

  Future initiate(String barcode) async {

    var dataToExtract;
    var imageUrl;
    var productName;
    var isCrueltyFree = false;

    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext ctx) => LoadingPage()));



    var client = http.Client();
    Response response = await client.get("https://features.peta.org/cruelty-free-company-search/cruelty_free_companies_search.aspx?Dotest=8");
    var document = parse(response.body);
    Response response2 = await client.get("https://www.barcodelookup.com/" + barcode);
    debugPrint(barcode);
    var document2 = parse(response2.body);
    RegExp regExp = RegExp("\"com_ComName\":\"[^,]+\"");
    var listOfMatches = regExp.allMatches(document.outerHtml).toList();

    RegExp regExp2 = RegExp("<img src=\.+>");
    RegExp regExp3 = RegExp("alt=\"\.+\" id");
    dataToExtract = regExp2.allMatches(document2.outerHtml).toList()[1].group(0);
    

    if(dataToExtract.contains("Search for another product")) {
      response2 = await client.get("https://pl.search.yahoo.com/search?q=" + barcode);
      document2 = parse(response2.body);
      String product = document2.querySelectorAll("h3.title")[0].text.length > 4 ? document2.querySelectorAll("h3.title")[0].text.split(" ")[0] + " " + document2.querySelectorAll("h3.title")[0].text.split(" ")[1] + " " +
          document2.querySelectorAll("h3.title")[0].text.split(" ")[2]+ " " + document2.querySelectorAll("h3.title")[0].text.split(" ")[3] : document2.querySelectorAll("h3.title")[0].text;
      isCrueltyFree = findCompanyInProduct(listOfMatches, product);
      debugPrint(document2.querySelectorAll("h3.title")[0].text);
      imageUrl="";
      productName = "";
      companyName="";
    } else {
      imageUrl = dataToExtract.replaceAll("<img src=\"", "").split("\"")[0];
      productName =
      regExp3.allMatches(dataToExtract).toList()[0].group(0).split("\"")[1];
      isCrueltyFree = findCompanyInProduct(listOfMatches, productName);
    }

    !isCrueltyFree ? _incrementCrueltyFreeProducts() : _incrementCrueltyProducts();

    debugPrint(imageUrl);
    debugPrint(productName);
    debugPrint(isCrueltyFree.toString());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext ctx) => ProductReview(name: productName, imageUrl: imageUrl, isCruelty: isCrueltyFree, companyName: companyName, productBarcode: barcode,)));



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
        initiate(qrResult);
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
        return new HomePageFragment(_scanQR, initiate);
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
    Navigator.of(context).pop(); // close the drawer
  }


  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon, size: 36),
            title: new Text(d.title, style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
            selected: i == _selectedDrawerIndex,
            onTap: () => onSelectItem(i),
          )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Eco Scanner", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "OpenSans", color: Colors.white, shadows: [
          Shadow(
            blurRadius: 3.0,
            color: Colors.black12,
            offset: Offset(3.0, 3.0),
          ),
        ],),),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.center_focus_weak), onPressed: _scanQR)
        ],
      ),
      drawer:  MainDrawer(drawerOptions),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}