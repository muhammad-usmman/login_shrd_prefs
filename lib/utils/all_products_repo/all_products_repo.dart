import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../model/products_model/all_products_model.dart';

abstract class ProductRepository{
  Future<List<Product>>  getProducts();
}


class ProductRepositoryApi extends ProductRepository{
  @override
  Future<List<Product>> getProducts() async {
  String url = 'https://dummyjson.com/products';
 var response = await http.get(Uri.parse(url));

 if(response.statusCode== 200){
var data = jsonDecode(response.body);
List<Product> products= ProductList.fromJson(data).products;
return products;
 }else{
   throw Exception(response.statusCode);
 }

  }

}