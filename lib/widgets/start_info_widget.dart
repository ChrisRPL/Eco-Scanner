import 'package:flutter/material.dart';

class StartInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String result = "Check your product, if is animal-tested!";

    return Container(
      margin: EdgeInsets.only(top: 50, left: 40, right: 40, bottom: 40),
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    result,
                    style: new TextStyle(fontSize: 20.0, fontFamily: "OpenSans", fontWeight: FontWeight.bold, color: Colors.lightGreen, shadows: [
                      Shadow(
                        blurRadius: 3.0,
                        color: Colors.black12,
                        offset: Offset(1.5, 1.5),
                      ),
                    ],),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(child: Image.asset("assets/bunny.png", height: 100, width: 100,)),
                SizedBox(height: 20,),
                Center(child: Text("Why to choose cruelty-free products?:", textAlign: TextAlign.center, style: TextStyle(fontFamily: "OpenSans" ,fontWeight: FontWeight.normal, fontSize: 15, color: Colors.lightGreen, shadows: [
                  Shadow(
                    blurRadius: 1.0,
                    color: Colors.black26,
                    offset: Offset(1.0, 1.0),
                  ),
                ])
                  ,)
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.start ,children: <Widget>[
                    Icon(Icons.insert_emoticon),
                    Text(" Products like this are better for our planet", textAlign: TextAlign.left, style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w300),)
                  ],),
                ),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.start ,children: <Widget>[
                    Icon(Icons.sentiment_very_dissatisfied),
                    Text(" Animal testing harms the animals", textAlign: TextAlign.left, style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w300),)
                  ],),
                ),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.start ,children: <Widget>[
                    Icon(Icons.insert_emoticon),
                    Text(" Cruelty-free products use less chemicals", textAlign: TextAlign.left, style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w300),)
                  ],),
                ),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.start ,children: <Widget>[
                    Icon(Icons.insert_emoticon),
                    Text(" Many cruelty-free brands are budget-friendly", textAlign: TextAlign.left, style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w300),)
                  ],),
                ),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.only(right: 3.0, left: 3.0, top: 3.0, bottom: 10.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.start ,children: <Widget>[
                    Icon(Icons.sentiment_very_dissatisfied),
                    Text(" Cats and dogs are being used in experiments", textAlign: TextAlign.left, style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w300),)
                  ],),
                ),
              ],
            ),
            elevation: 10,
          ),
    );
  }
}
