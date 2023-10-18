import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:login_shrd_prefs/view/screen/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool islogedin = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void login(String username, password,) async {
    try {
      Response response =
          await post(Uri.parse('https://dummyjson.com/auth/login'), body: {
        'username': username,
        'password': password,

      });

      if (response.statusCode == 200)  {
        var data = jsonDecode(response.body.toString());

        debugPrint(data['username']);
        debugPrint(' Login Successful');
        setState(() {
          islogedin = true;
        });

      } else {
        debugPrint('failed');
        setState(() {
          islogedin= false;
        });
        SharedPreferences prefs= await SharedPreferences.getInstance();
        prefs.setString('username', username);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Shared Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                hintText: 'Enter Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20,),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =await SharedPreferences.getInstance();
                  login(_usernameController.text.toString(),
                      _passwordController.text.toString());

                  if (islogedin == true) {
                    Fluttertoast.showToast(msg: 'Login Successful');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                    prefs.setString('username', _usernameController.text);
                    Fluttertoast.showToast(msg: 'Login Successful');
                  }else{
                     Fluttertoast.showToast(msg: 'Invalid Username or Password');

                  }
                },
                child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}
