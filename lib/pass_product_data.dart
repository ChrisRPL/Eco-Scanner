import 'dart:io';

import 'package:eco_scanner/product_review.dart';
import 'package:eco_scanner/sqlite/db_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'custom_dialog.dart';
import 'home_page.dart';
import 'models/product_item.dart';

class PassProductData extends StatefulWidget {
  bool isCruelty;
  String barcode;

  PassProductData(this.isCruelty, this.barcode);

  @override
  _PassProductDataState createState() => _PassProductDataState(isCruelty, barcode);
}

class _PassProductDataState extends State<PassProductData> {
  File _image;
  bool isImageLoaded = false;
  bool isCruelty;
  String barcode;
  var dbManager;
  TextEditingController productName, companyName;

  _PassProductDataState(this.isCruelty, this.barcode);




  _getImageFile(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        cropStyle: CropStyle.rectangle,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.lightGreen,
            toolbarWidgetColor: Colors.lime,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
        )
    );



    setState(() {
      _image = croppedFile;
      isImageLoaded = true;
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbManager = DbManager();
    productName = TextEditingController();
    companyName = TextEditingController();
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14))
        ),
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            children: <Widget>[
              Card(
                color: Colors.lightGreen,
                elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: !isImageLoaded ? Icon(Icons.image, color: Colors.white, size: 130,) :
              Image.file(_image, width: 130, height: 130, fit: BoxFit.cover,)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: RaisedButton.icon(
                    onPressed: (){ _getImageFile(ImageSource.camera);},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    color: Colors.grey,
                    icon: Icon(Icons.photo_camera, color: Colors.white,),
                    label:
                    Text("TAKE PHOTO", style: TextStyle(fontFamily: "OpenSans" ,fontWeight: FontWeight.normal, color: Colors.white, shadows: [
                      Shadow(
                        blurRadius: 1.0,
                        color: Colors.black26,
                        offset: Offset(1.0, 1.0),
                      ),
                    ])),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: RaisedButton.icon(
                    onPressed: (){ _getImageFile(ImageSource.gallery);},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    color: Colors.grey,
                    icon: Icon(Icons.add_photo_alternate, color: Colors.white,),
                    label:
                    Text("FROM GALLERY", style: TextStyle(fontFamily: "OpenSans" ,fontWeight: FontWeight.normal, color: Colors.white, shadows: [
                      Shadow(
                        blurRadius: 1.0,
                        color: Colors.black26,
                        offset: Offset(1.0, 1.0),
                      ),
                    ])),
                  ),
                ),
              ],
            ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: TextFormField(
                  controller: productName,
                  decoration: new InputDecoration(
                    labelText: "Product name",
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
                      return "Please provide valid product name!";
                    }else{
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: TextFormField(
                  controller: companyName,
                  decoration: new InputDecoration(
                    labelText: "Company name",
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
                      return "Please provide valid company name!";
                    }else{
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: OutlineButton(
                  onPressed: (){
                    dbManager.save(ProductItem(DateTime.now().millisecond, productName.text, companyName.text, _image.path, barcode, isCruelty ? 1 : 0));
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
                  splashColor: Colors.lime,
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text("ADD PRODUCT", style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.normal, fontSize: 18, color: Colors.lightGreen, shadows: [
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
