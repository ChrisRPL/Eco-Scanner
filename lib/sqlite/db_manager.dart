import 'dart:io' as io;
import 'dart:async';
import 'package:eco_scanner/models/product_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DbManager {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String COMPANY_NAME = 'company_name';
  static const String IMAGE_URL = 'image_url';
  static const String BARCODE = 'barcode';
  static const String IS_CRUELTY = 'is_cruelty';
  static const String TABLE = 'Products';
  static const String DB_NAME = 'products.db';

  Future<Database> get db async {
    if(_db != null){
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async{
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async{
      await db.execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME TEXT,"
          "$COMPANY_NAME TEXT, $IMAGE_URL TEXT, $BARCODE TEXT, $IS_CRUELTY INTEGER)");
  }

  Future<ProductItem> save(ProductItem productItem) async {
    var dbClient = await db;
    productItem.id = await dbClient.insert(TABLE, productItem.toMap());
    return productItem;
  }


  Future<List<ProductItem>> getCrueltyProducts() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME, COMPANY_NAME, IMAGE_URL, BARCODE, IS_CRUELTY]);
    //List<Map> maps = await dbClient.query("SELECT * FROM $TABLE");
    List<ProductItem> products = [];
    if(maps.length>0) {
      for(int i=0; i<maps.length; i++){
        if(ProductItem.fromMap(maps[i]).isCruelty==1)
          products.add(ProductItem.fromMap(maps[i]));
      }
    }
    return products;
  }

  Future<List<ProductItem>> getAllProducts() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME, COMPANY_NAME, IMAGE_URL, BARCODE, IS_CRUELTY]);
    //List<Map> maps = await dbClient.query("SELECT * FROM $TABLE");
    List<ProductItem> products = [];
    if(maps.length>0) {
      for(int i=0; i<maps.length; i++){
        products.add(ProductItem.fromMap(maps[i]));
      }
    }
    return products;
  }

  Future<List<ProductItem>> getCrueltyFreeProducts() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME, COMPANY_NAME, IMAGE_URL, BARCODE, IS_CRUELTY]);
    //List<Map> maps = await dbClient.query("SELECT * FROM $TABLE");
    List<ProductItem> products = [];
    if(maps.length>0) {
      for(int i=0; i<maps.length; i++){
        if(ProductItem.fromMap(maps[i]).isCruelty==0)
            products.add(ProductItem.fromMap(maps[i]));
      }
    }
    return products;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(ProductItem productItem) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, productItem.toMap(),
        where: '$ID = ?', whereArgs: [productItem.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

}

