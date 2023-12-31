import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));
String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    required this.image,
    required this.id,
    required this.name,
    required this.price,
    required this.desc,
    required this.isFavourite,
    this.qty,
  });

  String image;
  String id;
  String name;
  int price;
  String desc;
  bool isFavourite;
  int? qty;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      ProductModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        price: json["price"],
        desc: json["desc"],
        isFavourite: false,
        qty: json["qty"],
      );


  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name": name,
        "image": image,
        "price": price,
        "desc": desc,
        "isFavourite": isFavourite,
        "qty": qty,
      };

  ProductModel copyWith({
    int? qty,
  }) => ProductModel(
      image: image,
      id: id,
      name: name,
      price: price,
      desc: desc,
      isFavourite: isFavourite,
      qty: qty ?? this.qty
  );
}