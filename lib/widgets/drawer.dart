import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends StatefulWidget {
  var drawerOptions;

  MainDrawer(this.drawerOptions);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  var totalScans, crueltyScans, crueltyFreeScans;
  _getTotalScans() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('totalScans') ?? 0);
    setState(() {
      totalScans = counter;
    });
  }

  _getTotalCrueltyScans() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('totalCrueltyScans') ?? 0);
    setState(() {
      crueltyScans = counter;
    });
  }

  _getTotalCrueltyFreeScans() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('totalCrueltyFreeScans') ?? 0);
    setState(() {
      crueltyFreeScans = counter;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTotalScans();
    _getTotalCrueltyScans();
    _getTotalCrueltyFreeScans();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Card(
            elevation: 8,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              color: Colors.lime,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 15),),
                  Text(
                    'Eco-Scanner Stats:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: "OpenSans",
                      shadows: <Shadow>[
                        Shadow(color: Colors.black12, offset: Offset(1, 1))
                      ],
                        color: Colors.white, ), textAlign: TextAlign.center,
                  ),
                  Padding(padding: EdgeInsets.only(top: 15),),
                  Text(
                    'Scanned: ' + totalScans.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        fontFamily: "OpenSans",
                        shadows: <Shadow>[
                          Shadow(color: Colors.black12, offset: Offset(1, 1))
                        ],
                        color: Colors.white),textAlign: TextAlign.justify,
                  ),
                  Text(
                    'Animal-tested: ' + crueltyScans.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        fontFamily: "OpenSans",
                        shadows: <Shadow>[
                          Shadow(color: Colors.black12, offset: Offset(1, 1))
                        ],
                        color: Colors.white),textAlign: TextAlign.left,
                  ),
                  Text(
                    'No animal-tested: ' + crueltyFreeScans.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        fontFamily: "OpenSans",
                        shadows: <Shadow>[
                          Shadow(color: Colors.black12, offset: Offset(1, 1))
                        ],
                        color: Colors.white),textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Column(children: widget.drawerOptions,)
        ],
      ),
    );
  }
}
