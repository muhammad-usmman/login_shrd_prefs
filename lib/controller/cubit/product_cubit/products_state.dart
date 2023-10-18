part of 'products_cubit.dart';



@immutable
abstract class ProductsState  extends Equatable{}

class ProductsInitial extends ProductsState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ProductsLoading extends ProductsState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ProductsResponse extends ProductsState {
  final  List<Product> products;
  ProductsResponse(this.products);

  @override
  List<Object> get props => [];
}

class ProductsError extends ProductsState {
  final String message;

  ProductsError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}


