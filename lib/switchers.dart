import 'dart:io';

import 'package:flutter/material.dart';

class Switchers extends StatefulWidget {
  @override
  _SwitchersState createState() => _SwitchersState();
}

class _SwitchersState extends State<Switchers> {
  bool all;
  bool tested;
  bool non_tested;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    all=true;
    tested=false;
    non_tested=false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
