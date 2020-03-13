class ProductItem {
  int id;
  String name;
  String companyName;
  String imageUrl;
  String barcode;
  int isCruelty;

  ProductItem(this.id, this.name, this.companyName, this.imageUrl, this.barcode, this.isCruelty);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'name': name, 'company_name': companyName, 'image_url': imageUrl, 'barcode': barcode, 'is_cruelty': isCruelty};
    return map;
  }

  ProductItem.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    companyName = map['company_name'];
    imageUrl = map['image_url'];
    barcode = map['barcode'];
    isCruelty = map['is_cruelty'];
  }
}