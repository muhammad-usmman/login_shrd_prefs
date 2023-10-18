import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_shrd_prefs/controller/cubit/product_cubit/products_cubit.dart';

import 'package:login_shrd_prefs/utils/all_products_repo/all_products_repo.dart';
import 'package:login_shrd_prefs/view/screen/home_page.dart';
import 'package:login_shrd_prefs/view/screen/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var username = prefs.getString('username');
  print(username);
  runApp(BlocProvider(
    create: (context) => ProductsCubit(ProductRepositoryApi()),
    child: ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: username == null ? const LoginPage() : const HomePage(),
      ),
    ),
  ));
}



