import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/constants/constants.dart';
import 'package:grocery_app/constants/routes.dart';
import 'package:grocery_app/model/product_model/product_model.dart';
import 'package:grocery_app/provider/app_provider.dart';
import 'package:grocery_app/screens/cart_screen/cart_screen.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel singleProduct;
  const ProductDetails({Key? key, required this.singleProduct}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int qty = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Routes.instance.push(const CartScreen(), context);
              },
              icon: const Icon(Icons.shopping_cart)
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Image.network(
                  widget.singleProduct.image,
                height: 400,
                width: 400,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.singleProduct.name,
                  style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        widget.singleProduct.isFavourite = !widget.singleProduct.isFavourite;
                      });
                    },
                    icon:  Icon(widget.singleProduct.isFavourite? Icons.favorite: Icons.favorite_border)
                )
              ],
            ),
            Text(widget.singleProduct.desc),
            Row(
              children: [
                CupertinoButton(
                  onPressed: () {
                    setState(() {
                      if(qty>=2){
                        qty--;
                      }
                    });
                  },
                    child: const CircleAvatar(
                      radius: 15,
                      child: Icon(Icons.remove),
                    ),
                ),
                const SizedBox(width: 2,),
                Text(qty.toString(), style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                const SizedBox(width: 2,),
                CupertinoButton(
                  onPressed: () {
                    setState(() {
                      qty++;
                    });
                  },
                  child: const CircleAvatar(
                    radius: 15,
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: (){
                      AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
                      appProvider.addCartProduct(widget.singleProduct);
                      showMessage("Added to Cart");
                    },
                    child: const Text("ADD TO CART", style: TextStyle(color: Colors.green),)
                ),
                const SizedBox(width: 12,),
                SizedBox(
                  width: 136,
                  child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("BUY")
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}