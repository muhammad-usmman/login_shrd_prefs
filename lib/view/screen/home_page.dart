import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_shrd_prefs/controller/cubit/product_cubit/products_cubit.dart';
import 'package:login_shrd_prefs/model/products_model/all_products_model.dart';
import 'package:login_shrd_prefs/view/screen/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> _products = [];
  String name = '';

  //
  // @override
  // void initState() {
  //   super.initState();
  //   _loadDataFromSharedPreferences();
  // }
  //
  Future<void> _loadDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedData = prefs.getString('username') ?? '';
    setState(() {
      name = savedData;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<ProductsCubit>();
      cubit.fetchAllProducts();
      _loadDataFromSharedPreferences();
    });
  }

  double rating = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          drawer: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 15.0, left: 8.0, right: 8.0),
                child: DrawerHeader(
                  padding: const EdgeInsets.fromLTRB(20, 8, 8, 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(child: Text(name.split(" ")[0][0])),
                          Text("   $name")
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            prefs.remove('username');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                          child: const Text('Logout')),
                    ],
                  ),
                ),
              ),
            ],
          ),
          appBar: AppBar(
            title: const Text('Available Products'),
            backgroundColor: Colors.white,
          ),
          body: BlocListener<ProductsCubit, ProductsState>(
            listener: (context, state) {
              if (state is ProductsResponse) {
                _products = state.products;
              }
            },
            child: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state is ProductsInitial || state is ProductsLoading) {
                  return const Center(
                    child: SpinKitCircle(
                      size: 40,
                      color: Colors.blue,
                    ),
                  );
                } else if (state is ProductsResponse) {
                  return RefreshIndicator(
                    onRefresh: () async{
                      _products = [];
                      state = ProductsLoading();
                      context.read<ProductsCubit>().fetchAllProducts();
                    },
                    child: ListView.builder(
                      itemCount: _products.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        final Product = _products[index];
                        return Row(
                          children: [
                            InkWell(

                              onTap: () {},
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  height: 0.3.sh,
                                  width: 0.9.sw,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(color: Colors.white12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              width: 0.25.sw,
                                              height:  0.25.sh,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: Product.images[0]
                                                        .toString() ??
                                                    '',
                                                fit: BoxFit.fill,
                                                placeholder: (context, url) =>
                                                    Container(
                                                      child: spinkit2,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(
                                                  Icons.error_outline,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        height: 0.25.sh,
                                        width: 00.5.sw,
                                        child: Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  Product.title,
                                                  softWrap: false,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                Text(
                                                  Product.description
                                                      .toString(),
                                                    softWrap: false,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.grey,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Price:  \$',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    Text(
                                                      Product.price.toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      Product.discountPercentage
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.green,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    Text(
                                                      ' % off: ',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.green,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    RatingBar.builder(
                                                      itemSize: 15,
                                                      // itemPadding = EdgeInsets.zero,
                                                      initialRating:
                                                          Product.rating,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 2.0),
                                                      itemBuilder:
                                                          (context, _) =>
                                                              const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate:
                                                          (rating) =>
                                                              setState(() {
                                                        this.rating = rating;
                                                      }),
                                                    ),
                                                    Text(
                                                      Product.rating.toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.grey,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      Product.stock.toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.grey,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                    Text(
                                                      ' pieces remaining',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Brand: ',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.grey,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                    Text(
                                                      Product.brand.toString(),
                                                      softWrap: false,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.black87,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Category: ',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                    Text(
                                                      Product.category
                                                          .toString(),
                                                      style:
                                                         GoogleFonts.poppins(
                                                        color: Colors.black87,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }else if (state is ProductsError) {
                  return Text(state.message);
                }
                return Center(
                  child: Text(state.toString()),
                );
              },
            ),
          )),
    );
  }
}

const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 35,
);
