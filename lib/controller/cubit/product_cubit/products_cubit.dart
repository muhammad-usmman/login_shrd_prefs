import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:login_shrd_prefs/model/products_model/all_products_model.dart';
import 'package:login_shrd_prefs/utils/all_products_repo/all_products_repo.dart';
import 'package:meta/meta.dart';
part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductRepository _productRepo;

  ProductsCubit( this._productRepo) : super(ProductsInitial());

  Future<void> fetchAllProducts() async {
    emit(ProductsLoading());
    try{
      List<Product> product = await _productRepo.getProducts();
      if (kDebugMode) {
        print(product.toString());
      }
      emit(ProductsResponse(product));

    }catch(e){
      emit(ProductsError(e.toString()));
    }
    throw Exception("Some error occured");

  }

}
