import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/constants/constants.dart';
import 'package:grocery_app/constants/routes.dart';
import 'package:grocery_app/firebase_helper/firebase_storage/firebase_storage.dart';
import 'package:grocery_app/firebase_helper/firestore_helper/firestore_helper.dart';
import '../model/product_model/product_model.dart';
import '../model/user_model/user_model.dart';

class AppProvider with ChangeNotifier{


  final List<ProductModel> _cartProductList = [];
  final List<ProductModel> _buyProductList = [];

  UserModel? _userModel;
  UserModel get getUserInformation => _userModel!;


  void addCartProduct(ProductModel productModel){
    _cartProductList.add(productModel);
    notifyListeners();
  }

  void removeCartProduct(ProductModel productModel){
    _cartProductList.remove(productModel);
    notifyListeners();
  }

  List<ProductModel> get getCartProductList => _cartProductList;



  final List<ProductModel> _favouriteProductList = [];
  void addFavouriteProduct(ProductModel productModel){
    _favouriteProductList.add(productModel);
    notifyListeners();
  }

  void removeFavouriteProduct(ProductModel productModel){
    _favouriteProductList.remove(productModel);
    notifyListeners();
  }

  List<ProductModel> get getFavouriteProductList => _favouriteProductList;

//user information

  void getUserInfoFirebase() async{
    _userModel = await FirestoreHelper.instance.getUserInformation();
    notifyListeners();
  }
  
  void updateUserInfoFirebase(BuildContext context, UserModel userModel, File? file) async{
    showLoaderDialog(context);
    if(file == null && userModel.name == null){
      Navigator.pop(context);
    }else if(file == null){
      showLoaderDialog(context);
      _userModel = userModel;
      await FirebaseFirestore.instance.collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
      showMessage("Successfully updated profile");
      notifyListeners();
    }else {
      showLoaderDialog(context);
      String imageUrl = await FirebaseStorageHelper.instance.uploadUserImage(file);
      _userModel = userModel.copyWith(image: imageUrl, name: _userModel!.name!.isEmpty?null:_userModel!.name);
      await FirebaseFirestore.instance.collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
      showMessage("Successfully updated profile");
      notifyListeners();
    }

  }

//total Price
  double totalPrice() {
    double totalPrice = 0.0;
    for(var element in _cartProductList){
      totalPrice += element.price*element.qty!;
    }
    return totalPrice;
  }

  double totalPriceBuyProductList() {
    double totalPrice = 0.0;
    for(var element in _buyProductList){
      totalPrice += element.price*element.qty!;
    }
    return totalPrice;
  }

  void updateQty(ProductModel productModel, int qty){
    int index = _cartProductList.indexOf(productModel);
    _cartProductList[index].qty = qty;
    notifyListeners();
  }

  void addBuyProduct(ProductModel model){
    _buyProductList.add(model);
    notifyListeners();
  }

  void addBuyProductCartList(){
    _buyProductList.addAll(_cartProductList);
    notifyListeners();
  }

  void clearCart(){
    _cartProductList.clear();
    notifyListeners();
  }

  void clearBuyProduct(){
    _buyProductList.clear();
    notifyListeners();
  }

  List<ProductModel> get getBuyProductList => _buyProductList;

}



